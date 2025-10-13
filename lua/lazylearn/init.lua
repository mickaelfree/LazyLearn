-- LazyLearn.nvim - Main Entry Point
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Un plugin Neovim pour apprendre à coder avec l'aide d'une IA

local M = {}

-- Seed le générateur de nombres aléatoires une seule fois au chargement du module
math.randomseed(os.time() + (vim.loop.hrtime() % 100000))

-- Modules - avec gestion d'erreur
local function safe_require(module_name)
  local ok, module = pcall(require, module_name)
  if not ok then
    vim.notify("LazyLearn: Erreur lors du chargement du module " .. module_name .. ": " .. tostring(module), vim.log.levels.ERROR)
    return nil
  end
  return module
end

local config = safe_require("lazylearn.config")
local ui = safe_require("lazylearn.ui")
local api = safe_require("lazylearn.api")
local prompts = safe_require("lazylearn.prompts")
local storage = safe_require("lazylearn.storage")
local obsidian = safe_require("lazylearn.obsidian")
local naming = safe_require("lazylearn.naming")
local community = safe_require("lazylearn.community")
local progression = safe_require("lazylearn.progression")
local creativity = safe_require("lazylearn.creativity")
local ownership = safe_require("lazylearn.ownership")
local social = safe_require("lazylearn.social")
local scarcity = safe_require("lazylearn.scarcity")
local unpredictability = safe_require("lazylearn.unpredictability")
local loss = safe_require("lazylearn.loss")

-- Vérifier que les modules critiques sont chargés
if not config or not ui then
  error("LazyLearn: Impossible de charger les modules critiques (config ou ui)")
end

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
      if config.options.storage.enabled or config.options.obsidian.enabled then
        vim.defer_fn(function()
          -- Générer un nom automatique
          local auto_name = naming.generate_name(text, selected_prompt.name, response)

          if config.options.storage.auto_save or config.options.obsidian.auto_save then
            -- Sauvegarder automatiquement avec le nom généré
            if config.options.obsidian.enabled then
              obsidian.save_concept(auto_name, text, response, selected_prompt.name)
            else
              storage.add_concept(auto_name, text, response)
            end
          else
            -- Demander confirmation avec le nom pré-rempli
            ui.input("Nom du concept (Entrée pour accepter '" .. auto_name .. "'): ", function(name)
              -- Si vide, utiliser le nom auto
              if not name or name == "" then
                name = auto_name
              end

              if name and name ~= "" then
                -- Obsidian ou JSON selon config
                if config.options.obsidian.enabled then
                  obsidian.save_concept(name, text, response, selected_prompt.name)
                else
                  storage.add_concept(name, text, response)
                end

                -- Tracker la progression
                if config.options.progression.enabled and config.options.progression.auto_track and progression and community then
                  local language = community.detect_language(text)
                  progression.record_concept_learned(name, language)

                  -- Tracker pour scarcity (challenges quotidiens/hebdomadaires)
                  if config.options.scarcity.enabled and config.options.scarcity.auto_check_challenges and scarcity then
                    scarcity.track_concept_learned(language)
                  end

                  -- Vérifier les easter eggs aléatoires
                  if config.options.unpredictability.enabled and config.options.unpredictability.enable_easter_eggs and unpredictability then
                    local roll = math.random()
                    if roll <= config.options.unpredictability.easter_egg_check_frequency then
                      unpredictability.check_easter_egg()
                    end
                  end
                end
              end
            end, { default = auto_name })
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

-- Partager un concept avec la communauté
function M.share_concept()
  community.show_share_menu()
end

-- Afficher les stats d'impact communautaire
function M.show_community_impact()
  community.show_impact_stats()
end

-- Afficher la progression (XP, niveaux, challenges)
function M.show_progression()
  if not progression then
    ui.error("Le module progression n'est pas disponible")
    return
  end
  progression.show_progression()
end

-- Afficher le skill tree
function M.show_skill_tree()
  if not progression then
    ui.error("Le module progression n'est pas disponible")
    return
  end
  progression.show_skill_tree()
end

-- Afficher les mastery levels
function M.show_mastery()
  if not progression then
    ui.error("Le module progression n'est pas disponible")
    return
  end
  progression.show_mastery_levels()
end

-- Créer un prompt personnalisé
function M.create_prompt()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.create_custom_prompt()
end

-- Remixer des concepts
function M.remix()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.remix_concepts()
end

-- Choisir un style d'apprentissage
function M.customize_style()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.select_learning_style()
end

-- Afficher la galerie de templates
function M.show_gallery()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.show_template_gallery()
end

-- Utiliser un template
function M.use_template()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.use_template()
end

-- Créer une variation
function M.create_variation()
  if not creativity then
    ui.error("Le module creativity n'est pas disponible")
    return
  end
  creativity.create_variation()
end

-- Afficher le vault
function M.show_vault()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.show_vault()
end

-- Créer une collection
function M.create_collection()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.create_collection()
end

-- Ajouter à une collection
function M.add_to_collection()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.add_to_collection()
end

-- Afficher les collections
function M.show_collections()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.show_collections()
end

-- Personnaliser un concept
function M.customize_concept()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.customize_concept()
end

-- Afficher les favoris
function M.show_favorites()
  if not ownership then
    ui.error("Le module ownership n'est pas disponible")
    return
  end
  ownership.show_favorites()
end

-- Afficher le leaderboard
function M.show_leaderboard()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.show_leaderboard()
end

-- Afficher la comparaison avec les pairs
function M.show_comparison()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.show_comparison()
end

-- Afficher les concepts populaires
function M.show_trending()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.show_trending()
end

-- Créer un groupe d'étude
function M.create_study_group()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.create_study_group()
end

-- Afficher les groupes d'étude
function M.show_groups()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.show_groups()
end

-- Suivre un mentor
function M.follow_mentor()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.follow_mentor()
end

-- Afficher les mentors suivis
function M.show_following()
  if not social then
    ui.error("Le module social n'est pas disponible")
    return
  end
  social.show_following()
end

-- Afficher les challenges quotidiens
function M.show_daily_challenges()
  if not scarcity then
    ui.error("Le module scarcity n'est pas disponible")
    return
  end
  scarcity.show_daily_challenges()
end

-- Afficher les challenges hebdomadaires
function M.show_weekly_challenges()
  if not scarcity then
    ui.error("Le module scarcity n'est pas disponible")
    return
  end
  scarcity.show_weekly_challenges()
end

-- Afficher le contenu exclusif
function M.show_exclusive_content()
  if not scarcity then
    ui.error("Le module scarcity n'est pas disponible")
    return
  end
  scarcity.show_exclusive_content()
end

-- Débloquer un contenu exclusif
function M.unlock_exclusive_menu()
  if not scarcity then
    ui.error("Le module scarcity n'est pas disponible")
    return
  end
  scarcity.unlock_menu()
end

-- Récupérer la récompense mystère quotidienne
function M.claim_mystery_reward()
  if not unpredictability then
    ui.error("Le module unpredictability n'est pas disponible")
    return
  end
  unpredictability.claim_mystery_reward()
end

-- Découvrir un concept aléatoire
function M.discover_random_concept()
  if not unpredictability then
    ui.error("Le module unpredictability n'est pas disponible")
    return
  end
  unpredictability.discover_random_concept()
end

-- Afficher les concepts découverts
function M.show_discovered_concepts()
  if not unpredictability then
    ui.error("Le module unpredictability n'est pas disponible")
    return
  end
  unpredictability.show_discovered_concepts()
end

-- Utiliser un prompt mystère
function M.use_mystery_prompt()
  if not unpredictability then
    ui.error("Le module unpredictability n'est pas disponible")
    return
  end
  unpredictability.use_mystery_prompt()
end

-- Afficher les statistiques de surprises
function M.show_surprise_stats()
  if not unpredictability then
    ui.error("Le module unpredictability n'est pas disponible")
    return
  end
  unpredictability.show_stats()
end

-- Afficher les concepts en déclin
function M.show_decaying_concepts()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.show_decaying_concepts()
end

-- Afficher l'état du streak
function M.show_streak_status()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.show_streak_status()
end

-- Acheter une protection de streak
function M.buy_streak_protection()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.buy_streak_protection()
end

-- Utiliser une protection de streak
function M.use_streak_protection()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.use_streak_protection()
end

-- Afficher les pertes potentielles
function M.show_potential_losses()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.show_potential_losses()
end

-- Afficher l'investissement (sunk cost)
function M.show_sunk_cost()
  if not loss then
    ui.error("Le module loss n'est pas disponible")
    return
  end
  loss.show_sunk_cost()
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

  vim.api.nvim_create_user_command("LLearnIndex", function()
    obsidian.create_index()
  end, { desc = "Créer l'index Obsidian des concepts" })

  vim.api.nvim_create_user_command("LLearnObsidian", function()
    local concepts = obsidian.list_concepts()
    if #concepts == 0 then
      ui.info("Aucun concept Obsidian trouvé")
      return
    end

    ui.select_prompt(concepts, function(concept)
      obsidian.open_in_obsidian(concept.path)
    end)
  end, { desc = "Ouvrir un concept dans Obsidian" })

  vim.api.nvim_create_user_command("LLearnShare", function()
    M.share_concept()
  end, { desc = "Partager un concept avec la communauté" })

  vim.api.nvim_create_user_command("LLearnCommunity", function()
    M.show_community_impact()
  end, { desc = "Afficher votre impact communautaire" })

  vim.api.nvim_create_user_command("LLearnProgress", function()
    M.show_progression()
  end, { desc = "Afficher votre progression (XP, niveaux, challenges)" })

  vim.api.nvim_create_user_command("LLearnSkillTree", function()
    M.show_skill_tree()
  end, { desc = "Afficher votre skill tree par langage" })

  vim.api.nvim_create_user_command("LLearnMastery", function()
    M.show_mastery()
  end, { desc = "Afficher les mastery levels de vos concepts" })

  vim.api.nvim_create_user_command("LLearnCreate", function()
    M.create_prompt()
  end, { desc = "Créer un prompt d'apprentissage personnalisé" })

  vim.api.nvim_create_user_command("LLearnRemix", function()
    M.remix()
  end, { desc = "Remixer deux concepts ensemble" })

  vim.api.nvim_create_user_command("LLearnStyle", function()
    M.customize_style()
  end, { desc = "Choisir votre style d'apprentissage" })

  vim.api.nvim_create_user_command("LLearnGallery", function()
    M.show_gallery()
  end, { desc = "Afficher la galerie de templates" })

  vim.api.nvim_create_user_command("LLearnTemplate", function()
    M.use_template()
  end, { desc = "Utiliser un template de la galerie" })

  vim.api.nvim_create_user_command("LLearnVariation", function()
    M.create_variation()
  end, { desc = "Créer une variation d'un concept existant" })

  vim.api.nvim_create_user_command("LLearnVault", function()
    M.show_vault()
  end, { desc = "Afficher votre coffre de connaissances" })

  vim.api.nvim_create_user_command("LLearnCreateCollection", function()
    M.create_collection()
  end, { desc = "Créer une nouvelle collection" })

  vim.api.nvim_create_user_command("LLearnAddToCollection", function()
    M.add_to_collection()
  end, { desc = "Ajouter un concept à une collection" })

  vim.api.nvim_create_user_command("LLearnCollections", function()
    M.show_collections()
  end, { desc = "Afficher vos collections" })

  vim.api.nvim_create_user_command("LLearnCustomize", function()
    M.customize_concept()
  end, { desc = "Personnaliser un concept" })

  vim.api.nvim_create_user_command("LLearnFavorites", function()
    M.show_favorites()
  end, { desc = "Afficher vos concepts favoris" })

  vim.api.nvim_create_user_command("LLearnLeaderboard", function()
    M.show_leaderboard()
  end, { desc = "Afficher le classement global" })

  vim.api.nvim_create_user_command("LLearnCompare", function()
    M.show_comparison()
  end, { desc = "Comparer vos stats avec la communauté" })

  vim.api.nvim_create_user_command("LLearnTrending", function()
    M.show_trending()
  end, { desc = "Afficher les concepts populaires" })

  vim.api.nvim_create_user_command("LLearnCreateGroup", function()
    M.create_study_group()
  end, { desc = "Créer un groupe d'étude" })

  vim.api.nvim_create_user_command("LLearnGroups", function()
    M.show_groups()
  end, { desc = "Afficher vos groupes d'étude" })

  vim.api.nvim_create_user_command("LLearnFollowMentor", function()
    M.follow_mentor()
  end, { desc = "Suivre un mentor" })

  vim.api.nvim_create_user_command("LLearnFollowing", function()
    M.show_following()
  end, { desc = "Afficher vos mentors suivis" })

  vim.api.nvim_create_user_command("LLearnDaily", function()
    M.show_daily_challenges()
  end, { desc = "Afficher les challenges quotidiens" })

  vim.api.nvim_create_user_command("LLearnWeekly", function()
    M.show_weekly_challenges()
  end, { desc = "Afficher les challenges hebdomadaires" })

  vim.api.nvim_create_user_command("LLearnExclusive", function()
    M.show_exclusive_content()
  end, { desc = "Afficher le contenu exclusif" })

  vim.api.nvim_create_user_command("LLearnUnlock", function(opts)
    if opts.args and opts.args ~= "" then
      scarcity.unlock_exclusive(opts.args)
    else
      M.unlock_exclusive_menu()
    end
  end, { nargs = "?", desc = "Débloquer du contenu exclusif" })

  vim.api.nvim_create_user_command("LLearnMystery", function()
    M.claim_mystery_reward()
  end, { desc = "Récupérer la récompense mystère quotidienne" })

  vim.api.nvim_create_user_command("LLearnDiscover", function()
    M.discover_random_concept()
  end, { desc = "Découvrir un concept aléatoire" })

  vim.api.nvim_create_user_command("LLearnDiscovered", function()
    M.show_discovered_concepts()
  end, { desc = "Afficher les concepts découverts" })

  vim.api.nvim_create_user_command("LLearnMysteryPrompt", function()
    M.use_mystery_prompt()
  end, { desc = "Utiliser un prompt mystère" })

  vim.api.nvim_create_user_command("LLearnSurprises", function()
    M.show_surprise_stats()
  end, { desc = "Afficher les statistiques de surprises" })

  vim.api.nvim_create_user_command("LLearnDecay", function()
    M.show_decaying_concepts()
  end, { desc = "Afficher les concepts en déclin" })

  vim.api.nvim_create_user_command("LLearnStreak", function()
    M.show_streak_status()
  end, { desc = "Afficher l'état du streak" })

  vim.api.nvim_create_user_command("LLearnBuyProtection", function()
    M.buy_streak_protection()
  end, { desc = "Acheter une protection de streak" })

  vim.api.nvim_create_user_command("LLearnProtectStreak", function()
    M.use_streak_protection()
  end, { desc = "Utiliser une protection de streak" })

  vim.api.nvim_create_user_command("LLearnLosses", function()
    M.show_potential_losses()
  end, { desc = "Afficher les pertes potentielles" })

  vim.api.nvim_create_user_command("LLearnInvestment", function()
    M.show_sunk_cost()
  end, { desc = "Afficher votre investissement d'apprentissage" })

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

  -- Initialiser le profil communautaire et afficher l'impact
  if config.options.community.enabled and community then
    vim.defer_fn(function()
      community.init_user_profile()

      -- Afficher l'impact au démarrage si activé
      if config.options.community.show_impact_on_startup then
        local data = community.load_community_data()
        if data.impact_stats.total_helped > 0 then
          ui.info("🌟 Votre apprentissage a aidé " .. data.impact_stats.total_helped .. " développeur(s) ! Utilisez :LLearnCommunity pour plus de détails.")
        end
      end
    end, 3000)
  end

  -- Afficher les avertissements de perte au démarrage
  if config.options.loss.enabled and config.options.loss.show_warnings_on_startup and loss then
    vim.defer_fn(function()
      loss.show_fomo_notifications()
    end, 4000)
  end

  M.is_setup = true
end

return M
