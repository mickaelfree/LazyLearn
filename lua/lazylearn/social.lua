-- LazyLearn.nvim - Social Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système social et comparaison (Core Drive 5)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local storage = require("lazylearn.storage")
local progression = require("lazylearn.progression")
local community = require("lazylearn.community")

-- Données simulées de la communauté (en prod, ce serait un backend)
M.SIMULATED_USERS = {
  { username = "rustacean_pro", xp = 8500, concepts = 127, streak = 45, lang = "rust" },
  { username = "js_ninja", xp = 7200, concepts = 98, streak = 32, lang = "javascript" },
  { username = "py_wizard", xp = 6800, concepts = 115, streak = 28, lang = "python" },
  { username = "code_master", xp = 6200, concepts = 89, streak = 41, lang = "javascript" },
  { username = "algo_beast", xp = 5900, concepts = 102, streak = 19, lang = "cpp" },
  { username = "react_guru", xp = 5400, concepts = 76, streak = 35, lang = "javascript" },
  { username = "gopher_dev", xp = 4800, concepts = 81, streak = 22, lang = "go" },
  { username = "functional_fp", xp = 4500, concepts = 69, streak = 16, lang = "haskell" },
  { username = "rust_learner", xp = 4200, concepts = 63, streak = 18, lang = "rust" },
  { username = "web_dev_pro", xp = 3900, concepts = 55, streak = 12, lang = "javascript" },
}

-- Charger les données sociales
function M.load_social_data()
  local path = config.options.social.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      following = {},
      groups = {},
      social_stats = {
        rank = nil,
        percentile = nil,
        comparison = {},
      },
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      following = {},
      groups = {},
      social_stats = {
        rank = nil,
        percentile = nil,
        comparison = {},
      },
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    return {
      following = {},
      groups = {},
      social_stats = {
        rank = nil,
        percentile = nil,
        comparison = {},
      },
    }
  end

  return data
end

-- Sauvegarder les données sociales
function M.save_social_data(data)
  local path = config.options.social.data_path
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  return success
end

-- Obtenir le classement de l'utilisateur
function M.calculate_rank()
  local prog_data = progression.load_progression_data()
  local user_xp = prog_data.total_xp or 0

  -- Ajouter l'utilisateur à la liste simulée
  local all_users = vim.deepcopy(M.SIMULATED_USERS)
  table.insert(all_users, {
    username = "YOU",
    xp = user_xp,
    concepts = prog_data.concepts_learned or 0,
    streak = prog_data.daily_streak or 0,
    lang = "mixed",
  })

  -- Trier par XP
  table.sort(all_users, function(a, b) return a.xp > b.xp end)

  -- Trouver le rang
  local rank = 1
  for i, user in ipairs(all_users) do
    if user.username == "YOU" then
      rank = i
      break
    end
  end

  local percentile = math.floor((1 - (rank / #all_users)) * 100)

  return rank, percentile, all_users
end

-- Afficher le leaderboard
function M.show_leaderboard()
  local rank, percentile, all_users = M.calculate_rank()

  local display_text = "# 🏆 Leaderboard Global\n\n"
  display_text = display_text .. "**Votre position:** #" .. rank .. " / " .. #all_users .. "\n"
  display_text = display_text .. "**Percentile:** Top " .. percentile .. "%\n\n"

  if rank <= 3 then
    display_text = display_text .. "🎉 **Vous êtes dans le TOP 3 !**\n\n"
  elseif rank <= 10 then
    display_text = display_text .. "🌟 **Vous êtes dans le TOP 10 !**\n\n"
  elseif percentile >= 90 then
    display_text = display_text .. "⭐ **Vous êtes dans le TOP 10% !**\n\n"
  end

  display_text = display_text .. "---\n\n"

  -- Top 10
  display_text = display_text .. "## Top 10 Apprenants\n\n"

  for i = 1, math.min(10, #all_users) do
    local user = all_users[i]
    local medal = i == 1 and "🥇" or i == 2 and "🥈" or i == 3 and "🥉" or ("  " .. i .. ".")
    local is_you = user.username == "YOU" and " ← VOUS" or ""

    display_text = display_text .. medal .. " **" .. user.username .. "**" .. is_you .. "\n"
    display_text = display_text .. "   XP: " .. user.xp .. " | "
    display_text = display_text .. "Concepts: " .. user.concepts .. " | "
    display_text = display_text .. "Streak: " .. user.streak .. "\n\n"
  end

  ui.show_response(display_text, { title = " 🏆 Leaderboard " })
end

-- Comparaison avec les pairs
function M.show_comparison()
  local prog_data = progression.load_progression_data()
  local concepts = storage.load_concepts()

  -- Calculer moyennes (simulées)
  local avg_xp = 4800
  local avg_concepts = 75
  local avg_streak = 18

  local user_xp = prog_data.total_xp or 0
  local user_concepts = #concepts
  local user_streak = prog_data.daily_streak or 0

  local display_text = "# 📊 Comparaison avec la Communauté\n\n"

  -- XP
  local xp_diff = user_xp - avg_xp
  local xp_percent = math.floor((user_xp / avg_xp) * 100)

  display_text = display_text .. "## XP Total\n\n"
  display_text = display_text .. "**Vous:** " .. user_xp .. " XP\n"
  display_text = display_text .. "**Moyenne:** " .. avg_xp .. " XP\n"

  if xp_diff > 0 then
    display_text = display_text .. "✅ **+" .. xp_diff .. " XP** au-dessus de la moyenne (" .. xp_percent .. "%)\n\n"
  else
    display_text = display_text .. "📈 **" .. math.abs(xp_diff) .. " XP** en dessous (continuez !)\n\n"
  end

  -- Concepts
  local concepts_diff = user_concepts - avg_concepts
  display_text = display_text .. "## Concepts Appris\n\n"
  display_text = display_text .. "**Vous:** " .. user_concepts .. " concepts\n"
  display_text = display_text .. "**Moyenne:** " .. avg_concepts .. " concepts\n"

  if concepts_diff > 0 then
    display_text = display_text .. "✅ **+" .. concepts_diff .. " concepts** au-dessus !\n\n"
  else
    display_text = display_text .. "📚 **" .. math.abs(concepts_diff) .. " concepts** en dessous\n\n"
  end

  -- Streak
  local streak_diff = user_streak - avg_streak
  display_text = display_text .. "## Streak Quotidien\n\n"
  display_text = display_text .. "**Vous:** " .. user_streak .. " jours\n"
  display_text = display_text .. "**Moyenne:** " .. avg_streak .. " jours\n"

  if streak_diff > 0 then
    display_text = display_text .. "🔥 **+" .. streak_diff .. " jours** au-dessus !\n\n"
  else
    display_text = display_text .. "⏰ Continuez votre streak !\n\n"
  end

  -- Rang
  local rank, percentile = M.calculate_rank()
  display_text = display_text .. "---\n\n"
  display_text = display_text .. "**Classement:** #" .. rank .. " (Top " .. percentile .. "%)\n"

  ui.show_response(display_text, { title = " 📊 Comparaison " })
end

-- Créer un groupe d'étude
function M.create_study_group()
  ui.input("Nom du groupe d'étude: ", function(name)
    if not name or name == "" then
      return
    end

    ui.input("Description: ", function(desc)
      local data = M.load_social_data()

      table.insert(data.groups, {
        name = name,
        description = desc or "",
        created = os.time(),
        members = 1, -- Vous
        challenge = nil,
      })

      M.save_social_data(data)
      ui.info("👥 Groupe '" .. name .. "' créé !")
    end)
  end)
end

-- Afficher les groupes
function M.show_groups()
  local data = M.load_social_data()

  if #data.groups == 0 then
    ui.info("Aucun groupe. Créez-en un avec :LLearnCreateGroup")
    return
  end

  local display_text = "# 👥 Groupes d'Étude\n\n"

  for i, group in ipairs(data.groups) do
    display_text = display_text .. "## " .. group.name .. "\n\n"
    display_text = display_text .. "**Description:** " .. group.description .. "\n"
    display_text = display_text .. "**Membres:** " .. group.members .. "\n"
    display_text = display_text .. "**Créé le:** " .. os.date("%Y-%m-%d", group.created) .. "\n\n"

    if group.challenge then
      display_text = display_text .. "**Challenge actif:** " .. group.challenge .. "\n\n"
    end

    display_text = display_text .. "---\n\n"
  end

  ui.show_response(display_text, { title = " 👥 Groupes " })
end

-- Concepts populaires (social proof)
function M.show_trending()
  -- Simuler des concepts populaires
  local trending = {
    { name = "fibonacci-recursion", learners = 347, trend = "🔥" },
    { name = "rust-ownership", learners = 289, trend = "⬆️" },
    { name = "react-hooks-useeffect", learners = 256, trend = "⬆️" },
    { name = "binary-search-tree", learners = 198, trend = "📈" },
    { name = "async-await-javascript", learners = 176, trend = "🔥" },
  }

  local display_text = "# 🔥 Concepts Populaires Cette Semaine\n\n"
  display_text = display_text .. "Les concepts les plus appris par la communauté :\n\n"

  for i, concept in ipairs(trending) do
    display_text = display_text .. i .. ". " .. concept.trend .. " **" .. concept.name .. "**\n"
    display_text = display_text .. "   👥 " .. concept.learners .. " personnes l'apprennent\n\n"
  end

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "*Rejoignez la communauté et apprenez ce qui est tendance !*\n"

  ui.show_response(display_text, { title = " 🔥 Trending " })
end

-- Suivre un mentor (simulé)
function M.follow_mentor()
  local mentors = {
    { username = "rustacean_pro", specialty = "Rust & Performance", concepts = 127 },
    { username = "js_ninja", specialty = "JavaScript & React", concepts = 98 },
    { username = "py_wizard", specialty = "Python & ML", concepts = 115 },
  }

  local items = {}
  for _, mentor in ipairs(mentors) do
    table.insert(items, {
      name = mentor.username,
      icon = "👨‍🏫",
      description = mentor.specialty .. " - " .. mentor.concepts .. " concepts",
      specialty = mentor.specialty,
    })
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    local data = M.load_social_data()

    -- Vérifier si déjà suivi
    for _, followed in ipairs(data.following) do
      if followed.username == selected.name then
        ui.warn("Vous suivez déjà ce mentor")
        return
      end
    end

    table.insert(data.following, {
      username = selected.name,
      specialty = selected.specialty,
      followed_date = os.time(),
    })

    M.save_social_data(data)
    ui.info("✅ Vous suivez maintenant " .. selected.name)
  end)
end

-- Afficher les mentors suivis
function M.show_following()
  local data = M.load_social_data()

  if #data.following == 0 then
    ui.info("Vous ne suivez aucun mentor. Utilisez :LLearnFollowMentor")
    return
  end

  local display_text = "# 👨‍🏫 Vos Mentors\n\n"

  for i, mentor in ipairs(data.following) do
    display_text = display_text .. i .. ". **" .. mentor.username .. "**\n"
    display_text = display_text .. "   Spécialité: " .. mentor.specialty .. "\n"
    display_text = display_text .. "   Suivi depuis: " .. os.date("%Y-%m-%d", mentor.followed_date) .. "\n\n"
  end

  ui.show_response(display_text, { title = " 👨‍🏫 Mentors " })
end

-- Achievements sociaux
M.SOCIAL_ACHIEVEMENTS = {
  {
    id = "top_10",
    name = "👑 Elite Learner",
    description = "Atteindre le Top 10",
    condition = function()
      local rank = M.calculate_rank()
      return rank <= 10
    end,
  },
  {
    id = "top_1_percent",
    name = "🌟 Top 1%",
    description = "Être dans le top 1%",
    condition = function()
      local _, percentile = M.calculate_rank()
      return percentile >= 99
    end,
  },
  {
    id = "social_butterfly",
    name = "🦋 Social Butterfly",
    description = "Suivre 5 mentors",
    condition = function()
      local data = M.load_social_data()
      return #data.following >= 5
    end,
  },
}

return M
