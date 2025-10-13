-- LazyLearn.nvim - Storage Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")

-- Charger les concepts depuis le fichier JSON
function M.load_concepts()
  local path = config.options.storage.path

  if vim.fn.filereadable(path) ~= 1 then
    return {}
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {}
  end

  local success, concepts = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    ui.error("Impossible de charger les concepts: fichier corrompu")
    return {}
  end

  return concepts
end

-- Sauvegarder les concepts dans le fichier JSON
function M.save_concepts(concepts)
  local path = config.options.storage.path

  -- Créer le répertoire parent si nécessaire
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  -- Sauvegarder
  local success, error = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(concepts) }, path)
  end)

  if not success then
    ui.error("Impossible de sauvegarder les concepts: " .. tostring(error))
    return false
  end

  return true
end

-- Ajouter un nouveau concept
function M.add_concept(name, text, response)
  local concepts = M.load_concepts()

  local concept = {
    name = name,
    text = text,
    response = response,
    timestamp = os.time(),
    tags = {},
    review_count = 0,
    next_review = os.time() + (24 * 60 * 60), -- 1 jour
  }

  table.insert(concepts, concept)

  if M.save_concepts(concepts) then
    ui.info("Concept '" .. name .. "' sauvegardé")
    return true
  end

  return false
end

-- Obtenir les concepts dus pour révision
function M.get_due_concepts()
  local concepts = M.load_concepts()
  local now = os.time()
  local due = {}

  for i, concept in ipairs(concepts) do
    if concept.next_review and concept.next_review <= now then
      table.insert(due, { index = i, concept = concept })
    end
  end

  return due
end

-- Mettre à jour un concept après révision
function M.update_review(concept_index, difficulty)
  local concepts = M.load_concepts()

  if not concepts[concept_index] then
    ui.error("Concept introuvable")
    return false
  end

  -- Intervalles en jours basés sur la difficulté (1-5)
  local intervals = config.options.spaced_repetition.intervals
  local interval = intervals[difficulty] or 1

  -- Mise à jour du concept
  concepts[concept_index].review_count = (concepts[concept_index].review_count or 0) + 1
  concepts[concept_index].next_review = os.time() + (interval * 24 * 60 * 60)
  concepts[concept_index].last_difficulty = difficulty
  concepts[concept_index].last_review = os.time()

  return M.save_concepts(concepts)
end

-- Supprimer un concept
function M.delete_concept(concept_index)
  local concepts = M.load_concepts()

  if not concepts[concept_index] then
    ui.error("Concept introuvable")
    return false
  end

  table.remove(concepts, concept_index)

  if M.save_concepts(concepts) then
    ui.info("Concept supprimé")
    return true
  end

  return false
end

-- Rechercher des concepts par nom ou tags
function M.search_concepts(query)
  local concepts = M.load_concepts()
  local results = {}

  query = query:lower()

  for i, concept in ipairs(concepts) do
    local name_match = concept.name:lower():find(query, 1, true)
    local tag_match = false

    if concept.tags then
      for _, tag in ipairs(concept.tags) do
        if tag:lower():find(query, 1, true) then
          tag_match = true
          break
        end
      end
    end

    if name_match or tag_match then
      table.insert(results, { index = i, concept = concept })
    end
  end

  return results
end

-- Ajouter un tag à un concept
function M.add_tag(concept_index, tag)
  local concepts = M.load_concepts()

  if not concepts[concept_index] then
    ui.error("Concept introuvable")
    return false
  end

  concepts[concept_index].tags = concepts[concept_index].tags or {}
  table.insert(concepts[concept_index].tags, tag)

  return M.save_concepts(concepts)
end

-- Obtenir les statistiques
function M.get_stats()
  local concepts = M.load_concepts()
  local now = os.time()

  local stats = {
    total = #concepts,
    due_today = 0,
    reviewed_today = 0,
    avg_review_count = 0,
  }

  local total_reviews = 0

  for _, concept in ipairs(concepts) do
    -- Concepts dus aujourd'hui
    if concept.next_review and concept.next_review <= now then
      stats.due_today = stats.due_today + 1
    end

    -- Concepts révisés aujourd'hui
    if concept.last_review then
      local last_review_date = os.date("%Y-%m-%d", concept.last_review)
      local today_date = os.date("%Y-%m-%d", now)
      if last_review_date == today_date then
        stats.reviewed_today = stats.reviewed_today + 1
      end
    end

    -- Nombre total de révisions
    total_reviews = total_reviews + (concept.review_count or 0)
  end

  if stats.total > 0 then
    stats.avg_review_count = math.floor(total_reviews / stats.total * 10) / 10
  end

  return stats
end

-- Afficher tous les concepts sauvegardés
function M.show_all_concepts()
  local concepts = M.load_concepts()

  if #concepts == 0 then
    ui.info("Aucun concept sauvegardé")
    return
  end

  local display_text = "# Concepts Sauvegardés (" .. #concepts .. ")\n\n"

  for i, concept in ipairs(concepts) do
    local date_str = os.date("%Y-%m-%d %H:%M", concept.timestamp)
    local next_review_str = "Prochaine révision: " ..
        os.date("%Y-%m-%d", concept.next_review or (concept.timestamp + (24 * 60 * 60)))
    local review_count = concept.review_count or 0

    display_text = display_text .. "## " .. i .. ". " .. concept.name .. "\n"
    display_text = display_text .. "**Créé:** " .. date_str .. " | "
    display_text = display_text .. "**Révisions:** " .. review_count .. "\n"
    display_text = display_text .. next_review_str .. "\n\n"

    -- Tags
    if concept.tags and #concept.tags > 0 then
      display_text = display_text .. "**Tags:** " .. table.concat(concept.tags, ", ") .. "\n\n"
    end

    -- Texte original
    display_text = display_text .. "### Code/Texte original\n\n```\n"
    display_text = display_text .. concept.text .. "\n```\n\n"

    -- Réponse
    display_text = display_text .. "### Explication\n\n"
    display_text = display_text .. concept.response .. "\n\n"
    display_text = display_text .. "---\n\n"
  end

  ui.show_response(display_text, { title = " Concepts Sauvegardés " })
end

-- Afficher les statistiques
function M.show_stats()
  local stats = M.get_stats()

  local display_text = "# Statistiques LazyLearn\n\n"
  display_text = display_text .. "📚 **Total de concepts:** " .. stats.total .. "\n\n"
  display_text = display_text .. "⏰ **Concepts à réviser aujourd'hui:** " .. stats.due_today .. "\n\n"
  display_text = display_text .. "✅ **Concepts révisés aujourd'hui:** " .. stats.reviewed_today .. "\n\n"
  display_text = display_text .. "📊 **Moyenne de révisions par concept:** " .. stats.avg_review_count .. "\n\n"

  if stats.due_today > 0 then
    display_text = display_text .. "\n💡 Utilisez `:LLearnReview` ou `<leader>sr` pour commencer la révision!\n"
  end

  ui.show_response(display_text, { title = " Statistiques " })
end

-- Vérifier les révisions dues au démarrage
function M.check_due_reviews()
  if not config.options.spaced_repetition.enabled or not config.options.spaced_repetition.check_on_startup then
    return
  end

  local due_concepts = M.get_due_concepts()

  if #due_concepts > 0 then
    ui.info(#due_concepts .. " concept(s) à réviser aujourd'hui. Utilisez :LLearnReview ou <leader>sr")
  end
end

-- Démarrer une session de révision
function M.start_review_session()
  local due_concepts = M.get_due_concepts()

  if #due_concepts == 0 then
    ui.info("Aucun concept à réviser maintenant")
    return
  end

  M._review_queue = due_concepts
  M._review_current_index = 1

  M.show_next_review()
end

-- Afficher le prochain concept à réviser
function M.show_next_review()
  if not M._review_queue or #M._review_queue == 0 then
    ui.info("Session de révision terminée!")
    M._review_queue = nil
    M._review_current_index = nil
    return
  end

  local review_item = M._review_queue[M._review_current_index]
  if not review_item then
    ui.info("Session de révision terminée!")
    M._review_queue = nil
    M._review_current_index = nil
    return
  end

  local concept = review_item.concept
  local index = review_item.index

  local remaining = #M._review_queue - M._review_current_index + 1

  local display_text = "# Révision: " .. concept.name .. "\n\n"
  display_text = display_text .. "**Restant:** " .. remaining .. " concept(s)\n\n"
  display_text = display_text .. "---\n\n"

  -- Code/Texte original
  display_text = display_text .. "## Code/Texte\n\n```\n"
  display_text = display_text .. concept.text .. "\n```\n\n"

  -- Réponse
  display_text = display_text .. "## Explication\n\n"
  display_text = display_text .. concept.response .. "\n\n"
  display_text = display_text .. "---\n\n"

  -- Instructions d'évaluation
  display_text = display_text .. "## Évaluez votre compréhension\n\n"
  display_text = display_text .. "Appuyez sur un chiffre (1-5) pour évaluer:\n\n"
  display_text = display_text .. "**1** - Très difficile (revoir demain)\n"
  display_text = display_text .. "**2** - Difficile (revoir dans 3 jours)\n"
  display_text = display_text .. "**3** - Moyen (revoir dans 1 semaine)\n"
  display_text = display_text .. "**4** - Facile (revoir dans 2 semaines)\n"
  display_text = display_text .. "**5** - Très facile (revoir dans 1 mois)\n\n"
  display_text = display_text .. "**s** - Passer ce concept\n"
  display_text = display_text .. "**d** - Supprimer ce concept\n"

  local win, buf = ui.show_response(display_text, { title = " Révision - " .. concept.name .. " " })

  -- Raccourcis pour évaluation
  for i = 1, 5 do
    vim.keymap.set("n", tostring(i), function()
      M.update_review(index, i)

      -- Tracker la progression
      if config.options.progression and config.options.progression.enabled and config.options.progression.auto_track then
        local progression = require("lazylearn.progression")
        progression.record_review(concept.name, i)

        -- Tracker pour scarcity (challenges quotidiens)
        if config.options.scarcity and config.options.scarcity.enabled and config.options.scarcity.auto_check_challenges then
          local scarcity = require("lazylearn.scarcity")
          scarcity.track_review(i)
        end
      end

      local intervals = config.options.spaced_repetition.intervals
      local interval = intervals[i] or 1

      ui.info("Programmé pour révision dans " .. interval .. " jour(s)")

      -- Passer au suivant
      M._review_current_index = M._review_current_index + 1
      ui.close_window(win)

      vim.defer_fn(function()
        M.show_next_review()
      end, 500)
    end, { buffer = buf, silent = true })
  end

  -- Passer
  vim.keymap.set("n", "s", function()
    M._review_current_index = M._review_current_index + 1
    ui.close_window(win)
    vim.defer_fn(function()
      M.show_next_review()
    end, 200)
  end, { buffer = buf, silent = true })

  -- Supprimer
  vim.keymap.set("n", "d", function()
    ui.input("Supprimer '" .. concept.name .. "'? (oui/non): ", function(input)
      if input and input:lower() == "oui" then
        M.delete_concept(index)
        M._review_current_index = M._review_current_index + 1
        ui.close_window(win)
        vim.defer_fn(function()
          M.show_next_review()
        end, 200)
      end
    end)
  end, { buffer = buf, silent = true })
end

return M
