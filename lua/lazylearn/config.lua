-- LazyLearn.nvim - Configuration Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}

-- Configuration par défaut
M.defaults = {
  -- Provider IA par défaut
  provider = "groq", -- "openai", "ollama", "lmstudio", "custom"

  -- Configuration des providers
  providers = {
    groq = {
      api_url = "https://api.groq.com/openai/v1/chat/completions",
      model = "llama-3.3-70b-versatile",
      api_key_env = "GROQ_API_KEY",
      system_prompt = "Tu es john carmack mon mentor qui fournit toujours des exemples de code concrets et fonctionnels. Utilise des blocs de code avec la syntaxe ``` pour tous les exemples. Explique brièvement mais concentre-toi sur le code.",
    },
    openai = {
      api_url = "https://api.openai.com/v1/chat/completions",
      model = "gpt-4",
      api_key_env = "OPENAI_API_KEY",
      system_prompt = "Tu es un mentor expert en programmation qui fournit des explications claires avec des exemples de code concrets.",
    },
    ollama = {
      api_url = "http://localhost:11434/api/chat",
      model = "llama3",
      system_prompt = "Tu es un mentor expert en programmation qui fournit des explications claires avec des exemples de code concrets.",
    },
    lmstudio = {
      api_url = "http://localhost:1234/v1/chat/completions",
      model = "local-model",
      system_prompt = "Tu es un mentor expert en programmation qui fournit des explications claires avec des exemples de code concrets.",
    },
    custom = {
      api_url = "",
      model = "",
      api_key_env = "",
      system_prompt = "Tu es un mentor expert en programmation qui fournit des explications claires avec des exemples de code concrets.",
    },
  },

  -- Configuration UI
  ui = {
    border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
    width_ratio = 0.8,  -- Ratio de la largeur de l'écran (0.0 - 1.0)
    height_ratio = 0.8, -- Ratio de la hauteur de l'écran (0.0 - 1.0)
    max_width = 120,
    max_height = 40,
    position = "center", -- "center", "top", "bottom", "left", "right"
    transparency = 0,    -- 0-100, 0 = opaque
  },

  -- Configuration du stockage
  storage = {
    enabled = true,
    path = vim.fn.stdpath("data") .. "/lazylearn_concepts.json",
    auto_save = false, -- Demander confirmation avant de sauvegarder
  },

  -- Configuration des révisions espacées
  spaced_repetition = {
    enabled = true,
    check_on_startup = true,
    intervals = { 1, 3, 7, 14, 30 }, -- Intervalles en jours selon la difficulté (1-5)
  },

  -- Packs de prompts communautaires
  packs = {
    enabled = true,
    paths = {
      vim.fn.stdpath("data") .. "/lazylearn/packs",
      vim.fn.stdpath("config") .. "/lazylearn/packs",
    },
  },

  -- Configuration Obsidian
  obsidian = {
    enabled = false,                                      -- Activer l'intégration Obsidian
    vault_path = vim.fn.expand("~/Documents/Obsidian"),  -- Chemin vers votre vault Obsidian
    vault_name = "MyVault",                              -- Nom de votre vault
    concepts_folder = "LazyLearn",                       -- Dossier pour les concepts dans le vault
    open_after_save = false,                             -- Ouvrir dans Obsidian après sauvegarde
    auto_save = false,                                   -- Sauvegarder automatiquement sans demander
    auto_index = true,                                   -- Créer automatiquement l'index
    template_path = nil,                                 -- Chemin vers un template custom (optionnel)
  },

  -- Configuration Communauté (Epic Meaning & Calling)
  community = {
    enabled = true,                                      -- Activer le système communautaire
    data_path = vim.fn.stdpath("data") .. "/lazylearn_community.json", -- Données communautaires
    auto_share_prompt = false,                           -- Demander après chaque concept
    simulate_impact = true,                              -- Simuler l'impact pour la démo (mettre false en prod)
    show_impact_on_startup = true,                       -- Rappeler votre impact au démarrage
  },

  -- Configuration Progression (Development & Accomplishment)
  progression = {
    enabled = true,                                      -- Activer le système de progression
    data_path = vim.fn.stdpath("data") .. "/lazylearn_progression.json", -- Données de progression
    show_xp_notifications = true,                        -- Afficher les gains d'XP
    show_level_up_animation = true,                      -- Animation au level up
    track_daily_streak = true,                           -- Suivre le streak quotidien
    auto_track = true,                                   -- Tracker automatiquement les actions
  },

  -- Configuration Créativité (Empowerment of Creativity & Feedback)
  creativity = {
    enabled = true,                                      -- Activer le système de créativité
    data_path = vim.fn.stdpath("data") .. "/lazylearn_creativity.json", -- Données créatives
    enable_remixing = true,                              -- Activer le remix de concepts
    enable_custom_prompts = true,                        -- Permettre les prompts personnalisés
    enable_variations = true,                            -- Créer des variations de concepts
    auto_apply_learning_style = true,                    -- Appliquer le style d'apprentissage automatiquement
  },

  -- Configuration Possession (Ownership & Possession)
  ownership = {
    enabled = true,                                      -- Activer le système de possession
    data_path = vim.fn.stdpath("data") .. "/lazylearn_ownership.json", -- Données de possession
    enable_collections = true,                           -- Collections thématiques
    enable_concept_cards = true,                         -- Cartes à collectionner
    enable_customization = true,                         -- Personnalisation des concepts
    auto_check_achievements = true,                      -- Vérifier les achievements automatiquement
  },

  -- Configuration Social (Social Influence & Relatedness)
  social = {
    enabled = true,                                      -- Activer le système social
    data_path = vim.fn.stdpath("data") .. "/lazylearn_social.json", -- Données sociales
    enable_leaderboards = true,                          -- Classements et rankings
    enable_peer_comparison = true,                       -- Comparaison avec pairs
    enable_mentorship = true,                            -- Système de mentors
    enable_study_groups = true,                          -- Groupes d'étude
    enable_trending = true,                              -- Concepts populaires
    simulate_community = true,                           -- Simuler la communauté (false en prod)
  },

  -- Configuration Scarcity (Scarcity & Impatience)
  scarcity = {
    enabled = true,                                      -- Activer le système de rareté
    data_path = vim.fn.stdpath("data") .. "/lazylearn_scarcity.json", -- Données de rareté
    enable_daily_challenges = true,                      -- Challenges quotidiens (24h)
    enable_weekly_challenges = true,                     -- Challenges hebdomadaires
    enable_exclusive_content = true,                     -- Contenu exclusif débloquable
    enable_countdown_timers = true,                      -- Timers de compte à rebours
    auto_check_challenges = true,                        -- Vérifier automatiquement
  },

  -- Configuration Unpredictability (Unpredictability & Curiosity)
  unpredictability = {
    enabled = true,                                      -- Activer le système d'imprévisibilité
    data_path = vim.fn.stdpath("data") .. "/lazylearn_unpredictability.json", -- Données d'imprévisibilité
    enable_mystery_rewards = true,                       -- Récompenses mystères quotidiennes
    enable_easter_eggs = true,                           -- Easter eggs aléatoires
    enable_random_discovery = true,                      -- Découverte de concepts aléatoires
    enable_mystery_prompts = true,                       -- Prompts mystères progressifs
    easter_egg_check_frequency = 0.1,                    -- Vérifier 10% du temps
  },

  -- Configuration Loss (Loss & Avoidance)
  loss = {
    enabled = true,                                      -- Activer le système de perte
    data_path = vim.fn.stdpath("data") .. "/lazylearn_loss.json", -- Données de perte/évitement
    enable_decay_warnings = true,                        -- Avertissements de déclin
    enable_streak_protection = true,                     -- Protections de streak achetables
    enable_fomo_notifications = true,                    -- Notifications FOMO
    enable_sunk_cost_display = true,                     -- Affichage investissement
    show_warnings_on_startup = true,                     -- Avertir au démarrage
  },

  -- Raccourcis clavier
  keymaps = {
    -- Mode visuel
    trigger = "<leader>h",       -- Déclencher LazyLearn
    -- Mode normal
    show_concepts = "<leader>sc", -- Afficher les concepts sauvegardés
    review_concepts = "<leader>sr", -- Réviser les concepts dus
    -- Dans la fenêtre flottante
    close = { "q", "<Esc>" },
  },
}

-- Configuration actuelle (sera fusionnée avec les options utilisateur)
M.options = {}

-- Fusionner récursivement deux tables
local function merge_tables(base, override)
  local result = vim.deepcopy(base)
  for k, v in pairs(override) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = merge_tables(result[k], v)
    else
      result[k] = v
    end
  end
  return result
end

-- Fonction helper pour créer un répertoire si nécessaire
local function ensure_dir(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

-- Initialiser la configuration
function M.setup(opts)
  opts = opts or {}
  M.options = merge_tables(M.defaults, opts)

  -- Créer les répertoires nécessaires si absents
  ensure_dir(M.options.storage.path)

  -- Créer les répertoires pour les packs
  if M.options.packs.enabled then
    for _, pack_path in ipairs(M.options.packs.paths) do
      if vim.fn.isdirectory(pack_path) == 0 then
        vim.fn.mkdir(pack_path, "p")
      end
    end
  end

  -- Créer les répertoires pour tous les systèmes de gamification
  local gamification_systems = {
    { name = "community", config = M.options.community },
    { name = "progression", config = M.options.progression },
    { name = "creativity", config = M.options.creativity },
    { name = "ownership", config = M.options.ownership },
    { name = "social", config = M.options.social },
    { name = "scarcity", config = M.options.scarcity },
    { name = "unpredictability", config = M.options.unpredictability },
    { name = "loss", config = M.options.loss },
  }

  for _, system in ipairs(gamification_systems) do
    if system.config.enabled and system.config.data_path then
      ensure_dir(system.config.data_path)
    end
  end

  return M.options
end

-- Obtenir le provider actuel
function M.get_provider()
  local provider_name = M.options.provider
  return M.options.providers[provider_name]
end

-- Changer le provider
function M.set_provider(name)
  if M.options.providers[name] then
    M.options.provider = name
    vim.notify("Provider changé vers: " .. name, vim.log.levels.INFO)
  else
    vim.notify("Provider inconnu: " .. name, vim.log.levels.ERROR)
  end
end

return M
