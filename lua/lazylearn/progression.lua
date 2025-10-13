-- LazyLearn.nvim - Progression Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de progression, XP, niveaux et skill tree (Core Drive 2)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local storage = require("lazylearn.storage")
local community = require("lazylearn.community")

-- XP par action
M.XP_VALUES = {
  learn_concept = 10,
  review_easy = 5,
  review_medium = 8,
  review_hard = 12,
  perfect_review = 20, -- 5 révisions parfaites d'affilée
  share_concept = 15,
  daily_streak = 5, -- Bonus par jour de streak
}

-- Niveaux (XP requis pour chaque niveau)
M.LEVEL_THRESHOLDS = {
  0, 100, 250, 500, 850, 1300, 1850, 2500, 3250, 4100,
  5050, 6100, 7250, 8500, 9850, 11300, 12850, 14500, 16250, 18100, 20000
}

-- Charger les données de progression
function M.load_progression_data()
  local path = config.options.progression.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      total_xp = 0,
      level = 1,
      xp_in_level = 0,
      concepts_learned = 0,
      concepts_mastered = 0,
      reviews_completed = 0,
      perfect_reviews_streak = 0,
      daily_streak = 0,
      last_activity_date = nil,
      skill_trees = {}, -- Par langage
      challenges = {},
      achievements = {},
      mastery_levels = {}, -- Par concept
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    ui.warn("Fichier de progression vide, utilisation des valeurs par défaut")
    return {
      total_xp = 0,
      level = 1,
      xp_in_level = 0,
      concepts_learned = 0,
      concepts_mastered = 0,
      reviews_completed = 0,
      perfect_reviews_streak = 0,
      daily_streak = 0,
      last_activity_date = nil,
      skill_trees = {},
      challenges = {},
      achievements = {},
      mastery_levels = {},
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    ui.error("Impossible de charger les données de progression")
    return {
      total_xp = 0,
      level = 1,
      xp_in_level = 0,
      concepts_learned = 0,
      concepts_mastered = 0,
      reviews_completed = 0,
      perfect_reviews_streak = 0,
      daily_streak = 0,
      last_activity_date = nil,
      skill_trees = {},
      challenges = {},
      achievements = {},
      mastery_levels = {},
    }
  end

  return data
end

-- Sauvegarder les données de progression
function M.save_progression_data(data)
  local path = config.options.progression.data_path

  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success, error = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  if not success then
    ui.error("Impossible de sauvegarder la progression: " .. tostring(error))
    return false
  end

  return true
end

-- Calculer le niveau à partir de l'XP total
function M.calculate_level(total_xp)
  local level = 1
  for i, threshold in ipairs(M.LEVEL_THRESHOLDS) do
    if total_xp >= threshold then
      level = i
    else
      break
    end
  end
  return level
end

-- Calculer l'XP dans le niveau actuel
function M.calculate_xp_in_level(total_xp, level)
  local current_threshold = M.LEVEL_THRESHOLDS[level] or 0
  local next_threshold = M.LEVEL_THRESHOLDS[level + 1] or M.LEVEL_THRESHOLDS[#M.LEVEL_THRESHOLDS]
  local xp_in_level = total_xp - current_threshold
  local xp_needed = next_threshold - current_threshold
  return xp_in_level, xp_needed
end

-- Ajouter de l'XP
function M.add_xp(amount, reason)
  local data = M.load_progression_data()
  local old_level = data.level

  data.total_xp = data.total_xp + amount
  data.level = M.calculate_level(data.total_xp)
  data.xp_in_level = M.calculate_xp_in_level(data.total_xp, data.level)

  M.save_progression_data(data)

  -- Notifier
  ui.info("+" .. amount .. " XP (" .. reason .. ")")

  -- Level up ?
  if data.level > old_level then
    ui.info("🎉 LEVEL UP ! Niveau " .. data.level .. " atteint !")
    M.check_level_unlocks(data.level)
  end

  return data
end

-- Vérifier les débloquages au level up
function M.check_level_unlocks(level)
  local unlocks = {
    [5] = "Accès aux techniques avancées débloqué !",
    [10] = "Mode Expert débloqué !",
    [15] = "Techniques de Master débloquées !",
    [20] = "Statut de Légende atteint !",
  }

  if unlocks[level] then
    ui.info("🔓 " .. unlocks[level])
  end
end

-- Mettre à jour le streak quotidien
function M.update_daily_streak()
  local data = M.load_progression_data()
  local today = os.date("%Y-%m-%d")

  if data.last_activity_date ~= today then
    local yesterday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)

    if data.last_activity_date == yesterday then
      -- Continuer le streak
      data.daily_streak = data.daily_streak + 1
      M.add_xp(M.XP_VALUES.daily_streak * data.daily_streak, "Streak bonus x" .. data.daily_streak)
    else
      -- Streak cassé
      if data.daily_streak > 0 then
        ui.warn("Streak cassé ! Vous étiez à " .. data.daily_streak .. " jours.")
      end
      data.daily_streak = 1
    end

    data.last_activity_date = today
    M.save_progression_data(data)
  end
end

-- Enregistrer un concept appris
function M.record_concept_learned(concept_name, language)
  -- Load data once
  local data = M.load_progression_data()
  local old_level = data.level

  -- Update daily streak (inline to avoid second load-save)
  local today = os.date("%Y-%m-%d")
  if data.last_activity_date ~= today then
    local yesterday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
    if data.last_activity_date == yesterday then
      data.daily_streak = data.daily_streak + 1
      ui.info("🔥 Streak " .. data.daily_streak .. " jours!")
    else
      if data.daily_streak > 0 then
        ui.warn("Streak cassé ! Vous étiez à " .. data.daily_streak .. " jours.")
      end
      data.daily_streak = 1
    end
    data.last_activity_date = today
  end

  -- Increment concepts learned
  data.concepts_learned = data.concepts_learned + 1

  -- Initialize mastery level
  data.mastery_levels[concept_name] = {
    level = 1,
    reviews = 0,
    last_review = os.time(),
  }

  -- Update skill tree per language
  if language then
    data.skill_trees[language] = data.skill_trees[language] or {
      xp = 0,
      level = 1,
      concepts = 0,
    }
    data.skill_trees[language].concepts = data.skill_trees[language].concepts + 1
    data.skill_trees[language].xp = data.skill_trees[language].xp + M.XP_VALUES.learn_concept
    data.skill_trees[language].level = math.floor(data.skill_trees[language].xp / 100) + 1
  end

  -- Add XP (inline to avoid second load-save)
  data.total_xp = data.total_xp + M.XP_VALUES.learn_concept
  data.level = M.calculate_level(data.total_xp)
  data.xp_in_level = M.calculate_xp_in_level(data.total_xp, data.level)

  -- Notify XP gain
  ui.info("+" .. M.XP_VALUES.learn_concept .. " XP (Concept appris)")

  -- Check for level up
  if data.level > old_level then
    ui.info("🎉 LEVEL UP ! Niveau " .. data.level .. " atteint !")
    M.check_level_unlocks(data.level)
  end

  -- Save once at the end
  M.save_progression_data(data)

  -- Check challenges
  M.check_challenges(data)
end

-- Enregistrer une révision
function M.record_review(concept_name, difficulty)
  -- Load data once
  local data = M.load_progression_data()
  local old_level = data.level

  -- Update daily streak (inline to avoid second load-save)
  local today = os.date("%Y-%m-%d")
  if data.last_activity_date ~= today then
    local yesterday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
    if data.last_activity_date == yesterday then
      data.daily_streak = data.daily_streak + 1
      ui.info("🔥 Streak " .. data.daily_streak .. " jours!")
    else
      if data.daily_streak > 0 then
        ui.warn("Streak cassé ! Vous étiez à " .. data.daily_streak .. " jours.")
      end
      data.daily_streak = 1
    end
    data.last_activity_date = today
  end

  -- Increment reviews completed
  data.reviews_completed = data.reviews_completed + 1

  -- Update mastery level
  if data.mastery_levels[concept_name] then
    data.mastery_levels[concept_name].reviews = data.mastery_levels[concept_name].reviews + 1
    data.mastery_levels[concept_name].last_review = os.time()

    -- Mastery progression
    local reviews = data.mastery_levels[concept_name].reviews
    if reviews >= 20 then
      data.mastery_levels[concept_name].level = 5 -- Master
    elseif reviews >= 10 then
      data.mastery_levels[concept_name].level = 4 -- Expert
    elseif reviews >= 5 then
      data.mastery_levels[concept_name].level = 3 -- Proficient
    elseif reviews >= 2 then
      data.mastery_levels[concept_name].level = 2 -- Competent
    end

    -- Notify if level up
    local mastery_names = { "Novice", "Competent", "Proficient", "Expert", "Master" }
    local level = data.mastery_levels[concept_name].level
    if reviews == 2 or reviews == 5 or reviews == 10 or reviews == 20 then
      ui.info("📈 Mastery: " .. concept_name .. " → " .. mastery_names[level])
    end
  end

  -- XP based on difficulty
  local xp_amount = M.XP_VALUES.review_easy
  if difficulty == 1 or difficulty == 2 then
    xp_amount = M.XP_VALUES.review_hard
  elseif difficulty == 3 then
    xp_amount = M.XP_VALUES.review_medium
  end

  -- Perfect review streak
  if difficulty >= 4 then
    data.perfect_reviews_streak = data.perfect_reviews_streak + 1
    if data.perfect_reviews_streak >= 5 then
      xp_amount = M.XP_VALUES.perfect_review
      ui.info("🔥 Perfect Review Streak x" .. data.perfect_reviews_streak .. "!")
    end
  else
    data.perfect_reviews_streak = 0
  end

  -- Count mastered concepts (mastery level >= 4)
  local mastered = 0
  for _, mastery in pairs(data.mastery_levels) do
    if mastery.level >= 4 then
      mastered = mastered + 1
    end
  end
  data.concepts_mastered = mastered

  -- Add XP (inline to avoid second load-save)
  data.total_xp = data.total_xp + xp_amount
  data.level = M.calculate_level(data.total_xp)
  data.xp_in_level = M.calculate_xp_in_level(data.total_xp, data.level)

  -- Notify XP gain
  ui.info("+" .. xp_amount .. " XP (Révision)")

  -- Check for level up
  if data.level > old_level then
    ui.info("🎉 LEVEL UP ! Niveau " .. data.level .. " atteint !")
    M.check_level_unlocks(data.level)
  end

  -- Save once at the end
  M.save_progression_data(data)

  -- Check challenges
  M.check_challenges(data)
end

-- Système de challenges
M.CHALLENGES = {
  {
    id = "first_steps",
    name = "Premiers Pas",
    description = "Apprendre 5 concepts",
    condition = function(data) return data.concepts_learned >= 5 end,
    reward_xp = 50,
  },
  {
    id = "dedicated_learner",
    name = "Apprenant Dévoué",
    description = "Apprendre 25 concepts",
    condition = function(data) return data.concepts_learned >= 25 end,
    reward_xp = 200,
  },
  {
    id = "knowledge_master",
    name = "Maître du Savoir",
    description = "Apprendre 100 concepts",
    condition = function(data) return data.concepts_learned >= 100 end,
    reward_xp = 500,
  },
  {
    id = "review_warrior",
    name = "Guerrier des Révisions",
    description = "Compléter 50 révisions",
    condition = function(data) return data.reviews_completed >= 50 end,
    reward_xp = 150,
  },
  {
    id = "streak_champion",
    name = "Champion du Streak",
    description = "Maintenir un streak de 7 jours",
    condition = function(data) return data.daily_streak >= 7 end,
    reward_xp = 100,
  },
  {
    id = "polyglot",
    name = "Polyglotte",
    description = "Apprendre des concepts dans 5 langages différents",
    condition = function(data)
      local count = 0
      for _ in pairs(data.skill_trees) do count = count + 1 end
      return count >= 5
    end,
    reward_xp = 250,
  },
  {
    id = "master_craftsman",
    name = "Artisan Maître",
    description = "Atteindre le niveau Master sur 5 concepts",
    condition = function(data) return data.concepts_mastered >= 5 end,
    reward_xp = 300,
  },
}

-- Vérifier et débloquer les challenges
function M.check_challenges(data)
  for _, challenge in ipairs(M.CHALLENGES) do
    -- Vérifier si déjà complété
    local already_completed = false
    for _, completed in ipairs(data.challenges) do
      if completed.id == challenge.id then
        already_completed = true
        break
      end
    end

    -- Si pas complété et condition remplie
    if not already_completed and challenge.condition(data) then
      table.insert(data.challenges, {
        id = challenge.id,
        name = challenge.name,
        completed_date = os.time(),
      })
      M.save_progression_data(data)
      ui.info("🏆 Challenge complété : " .. challenge.name .. " (+" .. challenge.reward_xp .. " XP)")
      M.add_xp(challenge.reward_xp, "Challenge: " .. challenge.name)
    end
  end
end

-- Afficher la progression globale
function M.show_progression()
  local data = M.load_progression_data()
  local xp_in_level, xp_needed = M.calculate_xp_in_level(data.total_xp, data.level)
  local progress_percent = math.floor((xp_in_level / xp_needed) * 100)

  local display_text = "# 📈 Votre Progression\n\n"

  -- Niveau et XP
  display_text = display_text .. "## ⭐ Niveau Global\n\n"
  display_text = display_text .. "**Niveau:** " .. data.level .. "\n"
  display_text = display_text .. "**XP Total:** " .. data.total_xp .. "\n"
  display_text = display_text .. "**Prochain niveau:** " .. xp_in_level .. " / " .. xp_needed .. " XP (" .. progress_percent .. "%)\n\n"

  -- Barre de progression
  local bar_width = 20
  local filled = math.floor((xp_in_level / xp_needed) * bar_width)
  local bar = "[" .. string.rep("█", filled) .. string.rep("░", bar_width - filled) .. "]"
  display_text = display_text .. bar .. "\n\n"

  -- Stats globales
  display_text = display_text .. "## 📊 Statistiques\n\n"
  display_text = display_text .. "📚 **Concepts appris:** " .. data.concepts_learned .. "\n"
  display_text = display_text .. "🏆 **Concepts maîtrisés:** " .. data.concepts_mastered .. "\n"
  display_text = display_text .. "✅ **Révisions complétées:** " .. data.reviews_completed .. "\n"
  display_text = display_text .. "🔥 **Streak actuel:** " .. data.daily_streak .. " jour(s)\n\n"

  -- Skill trees par langage
  if next(data.skill_trees) then
    display_text = display_text .. "## 🌳 Skill Trees (Par Langage)\n\n"

    -- Trier par niveau
    local sorted_trees = {}
    for lang, tree in pairs(data.skill_trees) do
      table.insert(sorted_trees, { lang = lang, tree = tree })
    end
    table.sort(sorted_trees, function(a, b) return a.tree.level > b.tree.level end)

    for _, item in ipairs(sorted_trees) do
      display_text = display_text .. "### " .. string.upper(item.lang) .. "\n"
      display_text = display_text .. "- **Niveau:** " .. item.tree.level .. "\n"
      display_text = display_text .. "- **XP:** " .. item.tree.xp .. "\n"
      display_text = display_text .. "- **Concepts:** " .. item.tree.concepts .. "\n\n"
    end
  end

  -- Challenges complétés
  if #data.challenges > 0 then
    display_text = display_text .. "## 🏆 Challenges Complétés (" .. #data.challenges .. "/" .. #M.CHALLENGES .. ")\n\n"
    for _, challenge in ipairs(data.challenges) do
      local date = os.date("%Y-%m-%d", challenge.completed_date)
      display_text = display_text .. "- ✅ **" .. challenge.name .. "** (" .. date .. ")\n"
    end
    display_text = display_text .. "\n"
  end

  -- Challenges restants
  local remaining_challenges = {}
  for _, challenge in ipairs(M.CHALLENGES) do
    local completed = false
    for _, c in ipairs(data.challenges) do
      if c.id == challenge.id then
        completed = true
        break
      end
    end
    if not completed then
      table.insert(remaining_challenges, challenge)
    end
  end

  if #remaining_challenges > 0 then
    display_text = display_text .. "## 🎯 Challenges Disponibles\n\n"
    for _, challenge in ipairs(remaining_challenges) do
      display_text = display_text .. "- [ ] **" .. challenge.name .. "**\n"
      display_text = display_text .. "  - " .. challenge.description .. "\n"
      display_text = display_text .. "  - Récompense: " .. challenge.reward_xp .. " XP\n\n"
    end
  end

  ui.show_response(display_text, { title = " 📈 Progression " })
end

-- Afficher le skill tree visuel
function M.show_skill_tree()
  local data = M.load_progression_data()

  local display_text = "# 🌳 Skill Tree\n\n"
  display_text = display_text .. "Arbre de compétences par langage de programmation\n\n"

  if not next(data.skill_trees) then
    display_text = display_text .. "*Aucun skill tree encore. Commencez à apprendre des concepts !*\n"
  else
    for lang, tree in pairs(data.skill_trees) do
      display_text = display_text .. "## " .. string.upper(lang) .. " - Niveau " .. tree.level .. "\n\n"

      -- Visualisation ASCII
      local levels_visual = {
        [1] = "    🌱 Débutant",
        [5] = "    🌿 Intermédiaire",
        [10] = "    🌳 Avancé",
        [15] = "    🏆 Expert",
        [20] = "    👑 Master",
      }

      for level, label in pairs(levels_visual) do
        if tree.level >= level then
          display_text = display_text .. "✅ " .. label .. "\n"
        else
          display_text = display_text .. "🔒 " .. label .. " (niveau " .. level .. " requis)\n"
        end
      end

      display_text = display_text .. "\n**Stats:**\n"
      display_text = display_text .. "- Concepts appris: " .. tree.concepts .. "\n"
      display_text = display_text .. "- XP: " .. tree.xp .. "\n\n"
    end
  end

  ui.show_response(display_text, { title = " 🌳 Skill Tree " })
end

-- Afficher les concepts avec leur mastery level
function M.show_mastery_levels()
  local data = M.load_progression_data()
  local concepts_storage = storage.load_concepts()

  local display_text = "# 🎓 Mastery Levels\n\n"

  local mastery_names = {
    [1] = "🌱 Novice",
    [2] = "📘 Competent",
    [3] = "📗 Proficient",
    [4] = "📙 Expert",
    [5] = "👑 Master",
  }

  -- Grouper par mastery level
  local grouped = { {}, {}, {}, {}, {} }
  for name, mastery in pairs(data.mastery_levels) do
    table.insert(grouped[mastery.level], {
      name = name,
      reviews = mastery.reviews,
      level = mastery.level,
    })
  end

  -- Afficher du plus haut au plus bas
  for level = 5, 1, -1 do
    if #grouped[level] > 0 then
      display_text = display_text .. "## " .. mastery_names[level] .. " (" .. #grouped[level] .. ")\n\n"
      for _, concept in ipairs(grouped[level]) do
        display_text = display_text .. "- **" .. concept.name .. "** (" .. concept.reviews .. " révisions)\n"
      end
      display_text = display_text .. "\n"
    end
  end

  ui.show_response(display_text, { title = " 🎓 Mastery Levels " })
end

return M
