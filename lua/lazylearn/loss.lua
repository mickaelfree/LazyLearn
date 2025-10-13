-- LazyLearn.nvim - Loss & Avoidance Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de perte et d'évitement (Core Drive 8)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local progression = require("lazylearn.progression")
local storage = require("lazylearn.storage")

-- Seuils de déclin de maîtrise
M.MASTERY_DECAY = {
  warning_days = 7,    -- Avertir après 7 jours sans révision
  decay_days = 14,     -- Commencer à décliner après 14 jours
  critical_days = 30,  -- Déclin critique après 30 jours
}

-- Coût des protections de streak
M.STREAK_PROTECTION_COST = 3 -- 3 tokens pour protéger le streak

-- Charger les données de perte/évitement
function M.load_loss_data()
  local path = config.options.loss.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      streak_protections_available = 0,
      streak_protected_dates = {},
      concepts_at_risk = {},
      warnings_dismissed = {},
      total_losses_avoided = 0,
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      streak_protections_available = 0,
      streak_protected_dates = {},
      concepts_at_risk = {},
      warnings_dismissed = {},
      total_losses_avoided = 0,
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    return {
      streak_protections_available = 0,
      streak_protected_dates = {},
      concepts_at_risk = {},
      warnings_dismissed = {},
      total_losses_avoided = 0,
    }
  end

  return data
end

-- Sauvegarder les données de perte/évitement
function M.save_loss_data(data)
  local path = config.options.loss.data_path
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  return success
end

-- Vérifier les concepts en danger de déclin
function M.check_decaying_concepts()
  local concepts = storage.load_concepts()
  local now = os.time()
  local at_risk = {}

  for i, concept in ipairs(concepts) do
    if concept.last_review then
      local days_since_review = math.floor((now - concept.last_review) / 86400)

      if days_since_review >= M.MASTERY_DECAY.critical_days then
        table.insert(at_risk, {
          index = i,
          concept = concept,
          days_since_review = days_since_review,
          risk_level = "critical",
        })
      elseif days_since_review >= M.MASTERY_DECAY.decay_days then
        table.insert(at_risk, {
          index = i,
          concept = concept,
          days_since_review = days_since_review,
          risk_level = "high",
        })
      elseif days_since_review >= M.MASTERY_DECAY.warning_days then
        table.insert(at_risk, {
          index = i,
          concept = concept,
          days_since_review = days_since_review,
          risk_level = "warning",
        })
      end
    end
  end

  return at_risk
end

-- Afficher les concepts en déclin
function M.show_decaying_concepts()
  local at_risk = M.check_decaying_concepts()

  if #at_risk == 0 then
    ui.info("✅ Aucun concept en danger ! Tous vos concepts sont à jour.")
    return
  end

  local display_text = "# ⚠️ Concepts en Déclin\n\n"
  display_text = display_text .. "**Total à risque:** " .. #at_risk .. "\n\n"
  display_text = display_text .. "---\n\n"

  -- Grouper par niveau de risque
  local critical = {}
  local high = {}
  local warning = {}

  for _, item in ipairs(at_risk) do
    if item.risk_level == "critical" then
      table.insert(critical, item)
    elseif item.risk_level == "high" then
      table.insert(high, item)
    elseif item.risk_level == "warning" then
      table.insert(warning, item)
    end
  end

  -- Afficher critique
  if #critical > 0 then
    display_text = display_text .. "## 🔴 CRITIQUE (" .. #critical .. ")\n\n"
    display_text = display_text .. "**Déclin sévère ! Révisez IMMÉDIATEMENT pour éviter la perte.**\n\n"
    for _, item in ipairs(critical) do
      display_text = display_text .. "- **" .. item.concept.name .. "** (+" .. item.days_since_review .. " jours)\n"
      display_text = display_text .. "  Révisions: " .. (item.concept.review_count or 0) .. " | "
      display_text = display_text .. "Risque de perte imminente\n\n"
    end
  end

  -- Afficher high
  if #high > 0 then
    display_text = display_text .. "## 🟠 RISQUE ÉLEVÉ (" .. #high .. ")\n\n"
    display_text = display_text .. "**Déclin en cours. Révisez bientôt.**\n\n"
    for _, item in ipairs(high) do
      display_text = display_text .. "- **" .. item.concept.name .. "** (+" .. item.days_since_review .. " jours)\n"
      display_text = display_text .. "  Révisions: " .. (item.concept.review_count or 0) .. "\n\n"
    end
  end

  -- Afficher warning
  if #warning > 0 then
    display_text = display_text .. "## 🟡 AVERTISSEMENT (" .. #warning .. ")\n\n"
    display_text = display_text .. "**Révisez cette semaine pour maintenir votre maîtrise.**\n\n"
    for _, item in ipairs(warning) do
      display_text = display_text .. "- **" .. item.concept.name .. "** (+" .. item.days_since_review .. " jours)\n"
      display_text = display_text .. "  Révisions: " .. (item.concept.review_count or 0) .. "\n\n"
    end
  end

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "💡 Utilisez `:LLearnReview` pour réviser vos concepts maintenant !\n"

  ui.show_response(display_text, { title = " ⚠️ Déclin de Concepts " })
end

-- Vérifier le risque de perte de streak
function M.check_streak_risk()
  local prog_data = progression.load_progression_data()
  local loss_data = M.load_loss_data()
  local today = os.date("%Y-%m-%d")
  local yesterday_time = os.time() - 86400
  local yesterday = os.date("%Y-%m-%d", yesterday_time)

  -- Vérifier si aujourd'hui est protégé
  local is_today_protected = false
  for _, protected_date in ipairs(loss_data.streak_protected_dates or {}) do
    if protected_date == today then
      is_today_protected = true
      break
    end
  end

  -- Si aujourd'hui est protégé, considérer le streak comme sécurisé
  if is_today_protected then
    return {
      at_risk = false,
      broken = false,
      streak = prog_data.daily_streak or 0,
      protected = true,
    }
  end

  -- Check for nil last_activity_date (first time user)
  if not prog_data.last_activity_date then
    return {
      at_risk = false,
      broken = false,
      streak = 0,
    }
  end

  if prog_data.last_activity_date ~= today and prog_data.last_activity_date ~= yesterday then
    -- Streak déjà cassé
    return {
      at_risk = false,
      broken = true,
      streak = 0,
    }
  end

  if prog_data.last_activity_date == yesterday then
    -- Dernière activité hier, streak à risque aujourd'hui !
    return {
      at_risk = true,
      broken = false,
      streak = prog_data.daily_streak or 0,
      hours_remaining = 24 - tonumber(os.date("%H")),
    }
  end

  -- Activité aujourd'hui, streak sauf
  return {
    at_risk = false,
    broken = false,
    streak = prog_data.daily_streak or 0,
  }
end

-- Afficher l'état du streak avec avertissements
function M.show_streak_status()
  local risk = M.check_streak_risk()
  local loss_data = M.load_loss_data()

  local display_text = "# 🔥 État du Streak\n\n"

  if risk.broken then
    display_text = display_text .. "💔 **STREAK CASSÉ**\n\n"
    display_text = display_text .. "Votre streak de " .. risk.streak .. " jours a été perdu.\n"
    display_text = display_text .. "Recommencez dès aujourd'hui pour reconstruire !\n\n"
  elseif risk.at_risk then
    display_text = display_text .. "⚠️ **STREAK EN DANGER !**\n\n"
    display_text = display_text .. "**Streak actuel:** " .. risk.streak .. " jour(s)\n"
    display_text = display_text .. "**Temps restant:** " .. risk.hours_remaining .. " heure(s)\n\n"
    display_text = display_text .. "🚨 **Vous allez PERDRE votre streak si vous n'agissez pas !**\n\n"
    display_text = display_text .. "**Options:**\n"
    display_text = display_text .. "1. Apprenez 1 concept ou révisez maintenant\n"

    if loss_data.streak_protections_available > 0 then
      display_text = display_text .. "2. Utilisez une protection de streak (" .. loss_data.streak_protections_available .. " disponible(s))\n"
      display_text = display_text .. "   Commande: `:LLearnProtectStreak`\n"
    else
      display_text = display_text .. "2. Achetez une protection de streak (" .. M.STREAK_PROTECTION_COST .. " 🎫)\n"
      display_text = display_text .. "   Commande: `:LLearnBuyProtection`\n"
    end
  else
    display_text = display_text .. "✅ **STREAK SÉCURISÉ**\n\n"
    display_text = display_text .. "**Streak actuel:** " .. risk.streak .. " jour(s)\n"
    display_text = display_text .. "Vous avez appris ou révisé aujourd'hui !\n\n"
  end

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "**Protections disponibles:** " .. loss_data.streak_protections_available .. "\n"
  display_text = display_text .. "**Pertes évitées (total):** " .. loss_data.total_losses_avoided .. "\n"

  ui.show_response(display_text, { title = " 🔥 Streak " })
end

-- Acheter une protection de streak
function M.buy_streak_protection()
  if not config.options.scarcity or not config.options.scarcity.enabled then
    ui.error("Le système de tokens (scarcity) doit être activé")
    return
  end

  local scarcity = require("lazylearn.scarcity")
  local scarcity_data = scarcity.load_scarcity_data()

  if scarcity_data.tokens < M.STREAK_PROTECTION_COST then
    ui.error("Tokens insuffisants ! " .. M.STREAK_PROTECTION_COST .. " 🎫 requis (vous avez " .. scarcity_data.tokens .. " 🎫)")
    return
  end

  -- Acheter la protection
  scarcity_data.tokens = scarcity_data.tokens - M.STREAK_PROTECTION_COST
  scarcity.save_scarcity_data(scarcity_data)

  local loss_data = M.load_loss_data()
  loss_data.streak_protections_available = loss_data.streak_protections_available + 1
  M.save_loss_data(loss_data)

  ui.info("🛡️ Protection de streak achetée ! (+" .. loss_data.streak_protections_available .. " protection(s))")
end

-- Utiliser une protection de streak
function M.use_streak_protection()
  local loss_data = M.load_loss_data()

  if loss_data.streak_protections_available == 0 then
    ui.error("Aucune protection disponible ! Achetez-en une avec :LLearnBuyProtection")
    return
  end

  local risk = M.check_streak_risk()

  if not risk.at_risk then
    ui.warn("Votre streak n'est pas en danger. Pas besoin de protection !")
    return
  end

  -- Utiliser la protection
  loss_data.streak_protections_available = loss_data.streak_protections_available - 1
  loss_data.total_losses_avoided = loss_data.total_losses_avoided + 1

  local today = os.date("%Y-%m-%d")
  table.insert(loss_data.streak_protected_dates, today)

  M.save_loss_data(loss_data)

  -- Simuler une activité aujourd'hui pour sauver le streak
  local prog_data = progression.load_progression_data()
  prog_data.last_activity_date = today
  progression.save_progression_data(prog_data)

  ui.info("🛡️ Streak protégé ! Votre streak de " .. risk.streak .. " jours est sauvé pour aujourd'hui.")
end

-- Calculer le progrès perdu potentiel
function M.calculate_potential_loss()
  local at_risk = M.check_decaying_concepts()
  local risk = M.check_streak_risk()

  local potential_xp_loss = 0
  local concepts_at_risk = #at_risk

  -- Calculer XP investi dans concepts à risque
  for _, item in ipairs(at_risk) do
    local reviews = item.concept.review_count or 0
    potential_xp_loss = potential_xp_loss + (reviews * 8) -- Moyenne 8 XP par révision
  end

  -- Calculer valeur du streak
  local streak_value = 0
  if risk.at_risk then
    streak_value = risk.streak * 5 -- 5 XP bonus par jour de streak
  end

  return {
    concepts_at_risk = concepts_at_risk,
    potential_xp_loss = potential_xp_loss,
    streak_at_risk = risk.at_risk,
    streak_value = streak_value,
    total_loss = potential_xp_loss + streak_value,
  }
end

-- Afficher le rapport de pertes potentielles
function M.show_potential_losses()
  local loss = M.calculate_potential_loss()

  local display_text = "# 📉 Rapport de Pertes Potentielles\n\n"

  if loss.total_loss == 0 then
    display_text = display_text .. "✅ **Aucune perte potentielle détectée !**\n\n"
    display_text = display_text .. "Vous êtes à jour sur tous vos concepts et votre streak est sécurisé.\n"
  else
    display_text = display_text .. "⚠️ **Vous risquez de perdre du progrès !**\n\n"
    display_text = display_text .. "---\n\n"

    -- Concepts à risque
    if loss.concepts_at_risk > 0 then
      display_text = display_text .. "## 📚 Concepts en Déclin\n\n"
      display_text = display_text .. "**Nombre:** " .. loss.concepts_at_risk .. " concept(s)\n"
      display_text = display_text .. "**XP investi:** ~" .. loss.potential_xp_loss .. " XP\n"
      display_text = display_text .. "**Statut:** ⚠️ Risque de perte de maîtrise\n\n"
      display_text = display_text .. "💡 Action: `:LLearnDecay` pour voir la liste\n\n"
    end

    -- Streak à risque
    if loss.streak_at_risk then
      display_text = display_text .. "## 🔥 Streak en Danger\n\n"
      display_text = display_text .. "**Valeur du streak:** ~" .. loss.streak_value .. " XP\n"
      display_text = display_text .. "**Statut:** 🚨 Perte imminente\n\n"
      display_text = display_text .. "💡 Action: Apprenez 1 concept ou utilisez `:LLearnProtectStreak`\n\n"
    end

    display_text = display_text .. "---\n\n"
    display_text = display_text .. "### 💔 Perte Totale Potentielle\n\n"
    display_text = display_text .. "**~" .. loss.total_loss .. " XP** en danger de perte\n\n"
    display_text = display_text .. "🚨 **N'attendez pas ! Agissez maintenant pour éviter de perdre votre progrès.**\n"
  end

  ui.show_response(display_text, { title = " 📉 Pertes Potentielles " })
end

-- Notifications FOMO pour concepts dus
function M.show_fomo_notifications()
  local due_concepts = storage.get_due_concepts()
  local at_risk = M.check_decaying_concepts()
  local risk = M.check_streak_risk()

  if #due_concepts == 0 and #at_risk == 0 and not risk.at_risk then
    return -- Rien à notifier
  end

  local messages = {}

  if risk.at_risk and risk.hours_remaining <= 6 then
    table.insert(messages, "🚨 URGENT ! Votre streak de " .. risk.streak .. " jours sera perdu dans " .. risk.hours_remaining .. "h !")
  end

  if #at_risk > 0 then
    local critical = 0
    for _, item in ipairs(at_risk) do
      if item.risk_level == "critical" then
        critical = critical + 1
      end
    end
    if critical > 0 then
      table.insert(messages, "🔴 " .. critical .. " concept(s) en déclin critique ! Risque de perte imminente.")
    end
  end

  if #due_concepts >= 5 then
    table.insert(messages, "⏰ " .. #due_concepts .. " concepts en attente de révision. Ne laissez pas votre maîtrise décliner !")
  end

  if #messages > 0 then
    for _, msg in ipairs(messages) do
      ui.warn(msg)
    end
  end
end

-- Visualiser le sunk cost (coût irrécupérable)
function M.show_sunk_cost()
  local prog_data = progression.load_progression_data()
  local concepts = storage.load_concepts()

  local display_text = "# 💎 Votre Investissement d'Apprentissage\n\n"
  display_text = display_text .. "**Tout ce que vous avez construit jusqu'à maintenant.**\n\n"
  display_text = display_text .. "---\n\n"

  -- XP total
  display_text = display_text .. "## ⭐ XP Total\n\n"
  display_text = display_text .. "**" .. prog_data.total_xp .. " XP** accumulé\n"
  display_text = display_text .. "Niveau " .. prog_data.level .. " atteint\n\n"

  -- Concepts appris
  display_text = display_text .. "## 📚 Concepts\n\n"
  display_text = display_text .. "**" .. #concepts .. " concepts** appris\n"
  display_text = display_text .. "**" .. prog_data.reviews_completed .. " révisions** complétées\n\n"

  -- Streak
  display_text = display_text .. "## 🔥 Streak\n\n"
  display_text = display_text .. "**" .. prog_data.daily_streak .. " jour(s)** consécutifs\n"
  display_text = display_text .. "Valeur: ~" .. (prog_data.daily_streak * 5) .. " XP en bonus\n\n"

  -- Temps investi (estimation)
  local estimated_hours = math.floor((#concepts * 5 + prog_data.reviews_completed * 2) / 60 * 10) / 10
  display_text = display_text .. "## ⏱️ Temps Investi\n\n"
  display_text = display_text .. "**~" .. estimated_hours .. " heures** d'apprentissage\n\n"

  display_text = display_text .. "---\n\n"
  display_text = display_text .. "💪 **Vous avez investi beaucoup d'efforts. Ne laissez pas ce progrès se perdre !**\n\n"
  display_text = display_text .. "⚠️ Utilisez `:LLearnLosses` pour voir ce qui est en danger.\n"

  ui.show_response(display_text, { title = " 💎 Investissement " })
end

return M
