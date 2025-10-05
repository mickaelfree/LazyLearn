-- LazyLearn.nvim - Main Entry Point
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Un plugin Neovim pour apprendre à coder avec l'aide d'une IA

local M = {}

-- Modules
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local api = require("lazylearn.api")
local prompts = require("lazylearn.prompts")
local storage = require("lazylearn.storage")

-- État du plugin
M.is_setup = false

-- Fonction principale pour interroger l'IA
function M.learn()
  -- Vérifier le mode
  local mode = vim.fn.mode()
  local text = ""

  if mode == "v" or mode == "V" or mode == "\22" then
    -- Mode visuel: récupérer la sélection
    text = ui.get_visual_selection()
  else
    -- Mode normal: proposer de prendre le buffer entier
    ui.input("Analyser le buffer entier? (oui/non): ", function(input)
      if input and input:lower() == "oui" then
        text = ui.get_buffer_content()
        M._continue_learn(text)
      else
        ui.warn("Aucune sélection. Sélectionnez du code en mode visuel et réessayez.")
      end
    end, { default = "oui" })
    return
  end

  M._continue_learn(text)
end

-- Continuer le processus d'apprentissage avec le texte fourni
function M._continue_learn(text)
  if not text or text == "" then
    ui.error("Aucun texte à analyser")
    return
  end

  -- Récupérer tous les prompts
  local all_prompts = prompts.get_all()

  -- Afficher le menu de sélection
  ui.select_prompt(all_prompts, function(selected_prompt)
    if not selected_prompt then
      return
    end

    -- Afficher un indicateur de chargement
    local loading_win = ui.show_loading("Interrogation de l'IA...")

    -- Interroger l'API
    api.query(selected_prompt.prompt, text, function(response, error)
      -- Fermer le chargement
      if loading_win then
        ui.close_window(loading_win)
      end

      if error then
        ui.error("Erreur: " .. error)
        return
      end

      if not response then
        ui.error("Aucune réponse de l'IA")
        return
      end

      -- Afficher la réponse
      ui.show_response(response, { title = " " .. selected_prompt.name .. " " })

      -- Proposer de sauvegarder si l'option est activée
      if config.options.storage.enabled then
        vim.defer_fn(function()
          if config.options.storage.auto_save then
            -- Sauvegarder automatiquement avec un nom généré
            local name = selected_prompt.name .. " - " .. os.date("%Y-%m-%d %H:%M")
            storage.add_concept(name, text, response)
          else
            -- Demander à l'utilisateur
            ui.input("Sauvegarder ce concept? (nom ou vide pour ignorer): ", function(name)
              if name and name ~= "" then
                storage.add_concept(name, text, response)
              end
            end)
          end
        end, 1000)
      end
    end)
  end)
end

-- Commandes exposées

-- Afficher les concepts sauvegardés
function M.show_concepts()
  storage.show_all_concepts()
end

-- Démarrer une session de révision
function M.review()
  storage.start_review_session()
end

-- Afficher les statistiques
function M.stats()
  storage.show_stats()
end

-- Changer de provider
function M.select_provider()
  api.select_provider()
end

-- Tester la connexion au provider
function M.test_connection()
  api.test_connection()
end

-- Configuration du plugin
function M.setup(opts)
  -- Charger la configuration
  config.setup(opts)

  -- Créer les commandes utilisateur
  vim.api.nvim_create_user_command("LLearn", function()
    M.learn()
  end, { range = true, desc = "Apprendre avec LazyLearn" })

  vim.api.nvim_create_user_command("LLearnConcepts", function()
    M.show_concepts()
  end, { desc = "Afficher les concepts sauvegardés" })

  vim.api.nvim_create_user_command("LLearnReview", function()
    M.review()
  end, { desc = "Réviser les concepts dus" })

  vim.api.nvim_create_user_command("LLearnStats", function()
    M.stats()
  end, { desc = "Afficher les statistiques" })

  vim.api.nvim_create_user_command("LLearnProvider", function()
    M.select_provider()
  end, { desc = "Changer de provider IA" })

  vim.api.nvim_create_user_command("LLearnTest", function()
    M.test_connection()
  end, { desc = "Tester la connexion au provider" })

  -- Créer les raccourcis clavier
  -- Mode visuel: déclencher LazyLearn
  vim.keymap.set("v", config.options.keymaps.trigger, function()
    M.learn()
  end, {
    silent = true,
    desc = "Apprendre avec LazyLearn",
  })

  -- Mode normal: afficher les concepts
  vim.keymap.set("n", config.options.keymaps.show_concepts, function()
    M.show_concepts()
  end, {
    silent = true,
    desc = "Afficher les concepts sauvegardés",
  })

  -- Mode normal: réviser les concepts
  vim.keymap.set("n", config.options.keymaps.review_concepts, function()
    M.review()
  end, {
    silent = true,
    desc = "Réviser les concepts dus",
  })

  -- Vérifier les révisions dues au démarrage
  if config.options.spaced_repetition.enabled and config.options.spaced_repetition.check_on_startup then
    vim.defer_fn(function()
      storage.check_due_reviews()
    end, 2000)
  end

  M.is_setup = true
end

return M
