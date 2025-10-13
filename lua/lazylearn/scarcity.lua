-- LazyLearn.nvim - Scarcity Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de rareté et impatience (Core Drive 6)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local progression = require("lazylearn.progression")
local storage = require("lazylearn.storage")

-- Challenges quotidiens (renouvellement toutes les 24h)
M.DAILY_CHALLENGES = {
  {
    id = "daily_learner",
    name = "📚 Apprenant du Jour",
    description = "Apprendre 3 concepts aujourd'hui",
    target = 3,
    reward_xp = 50,
    reward_tokens = 1,
  },
  {
    id = "daily_reviewer",
    name = "🔄 Réviseur Quotidien",
    description = "Compléter 5 révisions aujourd'hui",
    target = 5,
    reward_xp = 40,
    reward_tokens = 1,
  },
  {
    id = "daily_perfect",
    name = "⭐ Perfection du Jour",
    description = "3 révisions parfaites (4-5) aujourd'hui",
    target = 3,
    reward_xp = 60,
    reward_tokens = 2,
  },
}

-- Challenges hebdomadaires (renouvellement tous les lundis)
M.WEEKLY_CHALLENGES = {
  {
    id = "weekly_explorer",
    name = "🗺️ Explorateur de la Semaine",
    description = "Apprendre dans 3 langages différents",
    target = 3,
    reward_xp = 150,
    reward_tokens = 3,
  },
  {
    id = "weekly_master",
    name = "👑 Maître de la Semaine",
    description = "Atteindre 10 concepts appris cette semaine",
    target = 10,
    reward_xp = 200,
    reward_tokens = 5,
  },
}

-- Contenus exclusifs débloquables
M.EXCLUSIVE_CONTENT = {
  {
    id = "advanced_prompts",
    name = "🎯 Prompts Avancés",
    description = "Pack de 5 prompts d'expert (analyse de complexité, refactoring patterns, etc.)",
    unlock_level = 10,
    unlock_tokens = 10,
    unlocked = false,
  },
  {
    id = "rare_badge_collector",
    name = "🏆 Badge Collectionneur Rare",
    description = "Badge exclusif visible sur votre profil",
    unlock_level = 15,
    unlock_tokens = 15,
    unlocked = false,
  },
  {
    id = "custom_mentor_voice",
    name = "🎭 Voix de Mentor Custom",
    description = "Personnalisez le style de réponse de l'IA (Socrate, Richard Feynman, etc.)",
    unlock_level = 5,
    unlock_tokens = 8,
    unlocked = false,
  },
  {
    id = "priority_review_queue",
    name = "⚡ File de Révision Prioritaire",
    description = "Algorithme optimisé pour réviser les concepts les plus critiques",
    unlock_level = 8,
    unlock_tokens = 12,
    unlocked = false,
  },
}

-- Charger les données de rareté
function M.load_scarcity_data()
  local path = config.options.scarcity.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      tokens = 0,
      daily_challenges = {},
      weekly_challenges = {},
      last_daily_reset = os.date("%Y-%m-%d"),
      last_weekly_reset = M.get_week_start(),
      exclusive_unlocked = {},
      daily_stats = {
        concepts_learned = 0,
        reviews_completed = 0,
        perfect_reviews = 0,
      },
      weekly_stats = {
        concepts_learned = 0,
        languages_used = {},
      },
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      tokens = 0,
      daily_challenges = {},
      weekly_challenges = {},
      last_daily_reset = os.date("%Y-%m-%d"),
      last_weekly_reset = M.get_week_start(),
      exclusive_unlocked = {},
      daily_stats = {
        concepts_learned = 0,
        reviews_completed = 0,
        perfect_reviews = 0,
      },
      weekly_stats = {
        concepts_learned = 0,
        languages_used = {},
      },
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    return {
      tokens = 0,
      daily_challenges = {},
      weekly_challenges = {},
      last_daily_reset = os.date("%Y-%m-%d"),
      last_weekly_reset = M.get_week_start(),
      exclusive_unlocked = {},
      daily_stats = {
        concepts_learned = 0,
        reviews_completed = 0,
        perfect_reviews = 0,
      },
      weekly_stats = {
        concepts_learned = 0,
        languages_used = {},
      },
    }
  end

  return data
end

-- Sauvegarder les données de rareté
function M.save_scarcity_data(data)
  local path = config.options.scarcity.data_path
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  return success
end

-- Obtenir le lundi de la semaine actuelle
function M.get_week_start()
  local time = os.time()
  local day_of_week = tonumber(os.date("%w", time)) -- 0 = dimanche
  local days_since_monday = (day_of_week + 6) % 7
  local monday_time = time - (days_since_monday * 86400)
  return os.date("%Y-%m-%d", monday_time)
end

-- Vérifier si les challenges quotidiens doivent être réinitialisés
function M.check_daily_reset()
  local data = M.load_scarcity_data()
  local today = os.date("%Y-%m-%d")

  if data.last_daily_reset ~= today then
    -- Reset quotidien
    data.daily_challenges = {}
    data.daily_stats = {
      concepts_learned = 0,
      reviews_completed = 0,
      perfect_reviews = 0,
    }
    data.last_daily_reset = today
    M.save_scarcity_data(data)
    return true
  end

  return false
end

-- Vérifier si les challenges hebdomadaires doivent être réinitialisés
function M.check_weekly_reset()
  local data = M.load_scarcity_data()
  local current_week = M.get_week_start()

  if data.last_weekly_reset ~= current_week then
    -- Reset hebdomadaire
    data.weekly_challenges = {}
    data.weekly_stats = {
      concepts_learned = 0,
      languages_used = {},
    }
    data.last_weekly_reset = current_week
    M.save_scarcity_data(data)
    return true
  end

  return false
end

-- Tracker un concept appris
function M.track_concept_learned(language)
  M.check_daily_reset()
  M.check_weekly_reset()

  local data = M.load_scarcity_data()
  data.daily_stats.concepts_learned = data.daily_stats.concepts_learned + 1
  data.weekly_stats.concepts_learned = data.weekly_stats.concepts_learned + 1

  -- Ajouter le langage à la liste hebdomadaire
  if language then
    local found = false
    for _, lang in ipairs(data.weekly_stats.languages_used) do
      if lang == language then
        found = true
        break
      end
    end
    if not found then
      table.insert(data.weekly_stats.languages_used, language)
    end
  end

  M.save_scarcity_data(data)
  M.check_challenge_completion()
end

-- Tracker une révision
function M.track_review(difficulty)
  M.check_daily_reset()

  local data = M.load_scarcity_data()
  data.daily_stats.reviews_completed = data.daily_stats.reviews_completed + 1

  if difficulty >= 4 then
    data.daily_stats.perfect_reviews = data.daily_stats.perfect_reviews + 1
  end

  M.save_scarcity_data(data)
  M.check_challenge_completion()
end

-- Vérifier la complétion des challenges
function M.check_challenge_completion()
  local data = M.load_scarcity_data()
  local completed_any = false

  -- Vérifier les challenges quotidiens
  for _, challenge in ipairs(M.DAILY_CHALLENGES) do
    local already_completed = false
    for _, completed in ipairs(data.daily_challenges) do
      if completed.id == challenge.id then
        already_completed = true
        break
      end
    end

    if not already_completed then
      local progress = 0
      if challenge.id == "daily_learner" then
        progress = data.daily_stats.concepts_learned
      elseif challenge.id == "daily_reviewer" then
        progress = data.daily_stats.reviews_completed
      elseif challenge.id == "daily_perfect" then
        progress = data.daily_stats.perfect_reviews
      end

      if progress >= challenge.target then
        -- Challenge complété !
        table.insert(data.daily_challenges, {
          id = challenge.id,
          completed_date = os.time(),
        })
        data.tokens = data.tokens + challenge.reward_tokens

        ui.info("⏰ Challenge quotidien complété : " .. challenge.name .. " (+" .. challenge.reward_xp .. " XP, +" .. challenge.reward_tokens .. " 🎫)")

        if config.options.progression.enabled then
          progression.add_xp(challenge.reward_xp, "Challenge quotidien")
        end

        completed_any = true
      end
    end
  end

  -- Vérifier les challenges hebdomadaires
  for _, challenge in ipairs(M.WEEKLY_CHALLENGES) do
    local already_completed = false
    for _, completed in ipairs(data.weekly_challenges) do
      if completed.id == challenge.id then
        already_completed = true
        break
      end
    end

    if not already_completed then
      local progress = 0
      if challenge.id == "weekly_explorer" then
        progress = #data.weekly_stats.languages_used
      elseif challenge.id == "weekly_master" then
        progress = data.weekly_stats.concepts_learned
      end

      if progress >= challenge.target then
        -- Challenge complété !
        table.insert(data.weekly_challenges, {
          id = challenge.id,
          completed_date = os.time(),
        })
        data.tokens = data.tokens + challenge.reward_tokens

        ui.info("🗓️ Challenge hebdomadaire complété : " .. challenge.name .. " (+" .. challenge.reward_xp .. " XP, +" .. challenge.reward_tokens .. " 🎫)")

        if config.options.progression.enabled then
          progression.add_xp(challenge.reward_xp, "Challenge hebdomadaire")
        end

        completed_any = true
      end
    end
  end

  if completed_any then
    M.save_scarcity_data(data)
  end
end

-- Afficher les challenges quotidiens
function M.show_daily_challenges()
  M.check_daily_reset()

  local data = M.load_scarcity_data()
  local display_text = "# ⏰ Challenges Quotidiens\n\n"

  -- Temps restant
  local now = os.time()
  -- Calculer le début de demain (minuit) en ajoutant les secondes jusqu'à minuit
  local seconds_today = tonumber(os.date("%H")) * 3600 + tonumber(os.date("%M")) * 60 + tonumber(os.date("%S"))
  local tomorrow = now - seconds_today + 86400
  local hours_left = math.floor((tomorrow - now) / 3600)
  local mins_left = math.floor(((tomorrow - now) % 3600) / 60)

  display_text = display_text .. "⏳ **Temps restant:** " .. hours_left .. "h " .. mins_left .. "m\n\n"
  display_text = display_text .. "---\n\n"

  for _, challenge in ipairs(M.DAILY_CHALLENGES) do
    local completed = false
    for _, c in ipairs(data.daily_challenges) do
      if c.id == challenge.id then
        completed = true
        break
      end
    end

    local progress = 0
    if challenge.id == "daily_learner" then
      progress = data.daily_stats.concepts_learned
    elseif challenge.id == "daily_reviewer" then
      progress = data.daily_stats.reviews_completed
    elseif challenge.id == "daily_perfect" then
      progress = data.daily_stats.perfect_reviews
    end

    local status = completed and "✅" or "⏰"
    display_text = display_text .. status .. " **" .. challenge.name .. "**\n"
    display_text = display_text .. "   " .. challenge.description .. "\n"
    display_text = display_text .. "   Progression: " .. progress .. "/" .. challenge.target .. "\n"
    display_text = display_text .. "   Récompense: +" .. challenge.reward_xp .. " XP, +" .. challenge.reward_tokens .. " 🎫\n\n"
  end

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "🎫 **Tokens disponibles:** " .. data.tokens .. "\n"

  ui.show_response(display_text, { title = " ⏰ Challenges Quotidiens " })
end

-- Afficher les challenges hebdomadaires
function M.show_weekly_challenges()
  M.check_weekly_reset()

  local data = M.load_scarcity_data()
  local display_text = "# 🗓️ Challenges Hebdomadaires\n\n"

  -- Temps restant jusqu'au lundi prochain
  local now = os.time()
  local day_of_week = tonumber(os.date("%w", now))
  local days_until_monday = (8 - day_of_week) % 7
  if days_until_monday == 0 then days_until_monday = 7 end
  local hours_left = days_until_monday * 24 - tonumber(os.date("%H"))

  display_text = display_text .. "⏳ **Temps restant:** " .. math.floor(hours_left / 24) .. " jour(s) " .. (hours_left % 24) .. "h\n\n"
  display_text = display_text .. "---\n\n"

  for _, challenge in ipairs(M.WEEKLY_CHALLENGES) do
    local completed = false
    for _, c in ipairs(data.weekly_challenges) do
      if c.id == challenge.id then
        completed = true
        break
      end
    end

    local progress = 0
    if challenge.id == "weekly_explorer" then
      progress = #data.weekly_stats.languages_used
    elseif challenge.id == "weekly_master" then
      progress = data.weekly_stats.concepts_learned
    end

    local status = completed and "✅" or "🗓️"
    display_text = display_text .. status .. " **" .. challenge.name .. "**\n"
    display_text = display_text .. "   " .. challenge.description .. "\n"
    display_text = display_text .. "   Progression: " .. progress .. "/" .. challenge.target .. "\n"
    display_text = display_text .. "   Récompense: +" .. challenge.reward_xp .. " XP, +" .. challenge.reward_tokens .. " 🎫\n\n"
  end

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "🎫 **Tokens disponibles:** " .. data.tokens .. "\n"

  ui.show_response(display_text, { title = " 🗓️ Challenges Hebdomadaires " })
end

-- Afficher le contenu exclusif
function M.show_exclusive_content()
  local data = M.load_scarcity_data()
  local prog_data = progression.load_progression_data()

  local display_text = "# 🔒 Contenu Exclusif\n\n"
  display_text = display_text .. "🎫 **Tokens disponibles:** " .. data.tokens .. "\n"
  display_text = display_text .. "⭐ **Niveau actuel:** " .. prog_data.level .. "\n\n"
  display_text = display_text .. "---\n\n"

  for _, content in ipairs(M.EXCLUSIVE_CONTENT) do
    local unlocked = false
    for _, id in ipairs(data.exclusive_unlocked) do
      if id == content.id then
        unlocked = true
        break
      end
    end

    local can_unlock = prog_data.level >= content.unlock_level and data.tokens >= content.unlock_tokens

    if unlocked then
      display_text = display_text .. "✅ **" .. content.name .. "** (DÉBLOQUÉ)\n"
      display_text = display_text .. "   " .. content.description .. "\n\n"
    elseif can_unlock then
      display_text = display_text .. "🔓 **" .. content.name .. "** (DISPONIBLE)\n"
      display_text = display_text .. "   " .. content.description .. "\n"
      display_text = display_text .. "   Coût: " .. content.unlock_tokens .. " 🎫 | Niveau requis: " .. content.unlock_level .. "\n"
      display_text = display_text .. "   💡 Utilisez :LLearnUnlock " .. content.id .. "\n\n"
    else
      display_text = display_text .. "🔒 **" .. content.name .. "** (VERROUILLÉ)\n"
      display_text = display_text .. "   " .. content.description .. "\n"
      display_text = display_text .. "   Coût: " .. content.unlock_tokens .. " 🎫 | Niveau requis: " .. content.unlock_level

      if prog_data.level < content.unlock_level then
        display_text = display_text .. " (" .. (content.unlock_level - prog_data.level) .. " niveaux restants)"
      end
      if data.tokens < content.unlock_tokens then
        display_text = display_text .. " (" .. (content.unlock_tokens - data.tokens) .. " 🎫 restants)"
      end
      display_text = display_text .. "\n\n"
    end
  end

  ui.show_response(display_text, { title = " 🔒 Contenu Exclusif " })
end

-- Débloquer un contenu exclusif
function M.unlock_exclusive(content_id)
  local data = M.load_scarcity_data()
  local prog_data = progression.load_progression_data()

  -- Trouver le contenu
  local content = nil
  for _, c in ipairs(M.EXCLUSIVE_CONTENT) do
    if c.id == content_id then
      content = c
      break
    end
  end

  if not content then
    ui.error("Contenu introuvable: " .. content_id)
    return
  end

  -- Vérifier si déjà débloqué
  for _, id in ipairs(data.exclusive_unlocked) do
    if id == content_id then
      ui.warn("Ce contenu est déjà débloqué !")
      return
    end
  end

  -- Vérifier les conditions
  if prog_data.level < content.unlock_level then
    ui.error("Niveau insuffisant ! Niveau " .. content.unlock_level .. " requis (vous êtes niveau " .. prog_data.level .. ")")
    return
  end

  if data.tokens < content.unlock_tokens then
    ui.error("Tokens insuffisants ! " .. content.unlock_tokens .. " 🎫 requis (vous avez " .. data.tokens .. " 🎫)")
    return
  end

  -- Débloquer
  data.tokens = data.tokens - content.unlock_tokens
  table.insert(data.exclusive_unlocked, content_id)
  M.save_scarcity_data(data)

  ui.info("🎉 Contenu débloqué : " .. content.name .. " !")
end

-- Menu pour débloquer du contenu
function M.unlock_menu()
  local data = M.load_scarcity_data()
  local prog_data = progression.load_progression_data()

  local items = {}
  for _, content in ipairs(M.EXCLUSIVE_CONTENT) do
    local unlocked = false
    for _, id in ipairs(data.exclusive_unlocked) do
      if id == content.id then
        unlocked = true
        break
      end
    end

    if not unlocked then
      local can_unlock = prog_data.level >= content.unlock_level and data.tokens >= content.unlock_tokens
      local icon = can_unlock and "🔓" or "🔒"

      table.insert(items, {
        name = content.name,
        icon = icon,
        description = content.description .. " | " .. content.unlock_tokens .. " 🎫, Niv." .. content.unlock_level,
        id = content.id,
        can_unlock = can_unlock,
      })
    end
  end

  if #items == 0 then
    ui.info("Tout le contenu exclusif est déjà débloqué !")
    return
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    if not selected.can_unlock then
      ui.warn("Vous ne pouvez pas encore débloquer ce contenu")
      return
    end

    M.unlock_exclusive(selected.id)
  end)
end

return M
