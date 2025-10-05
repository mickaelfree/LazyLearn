-- Exemple de configuration pour LazyLearn.nvim
-- Copiez ce fichier dans ~/.config/nvim/lua/plugins/lazylearn.lua

return {
  -- Version GitHub (recommandée)
  "mickaelfree/LazyLearn",

  -- Pour test local, décommentez :
  -- dir = vim.fn.expand("~/.config/nvim/lua/LazyLearn.nvim"),

  -- Dépendance requise
  dependencies = { "nvim-lua/plenary.nvim" },

  -- Configuration
  config = function()
    require("lazylearn.init").setup({

      -- ============================================
      -- CONFIGURATION DU PROVIDER IA
      -- ============================================

      -- Provider par défaut
      provider = "groq", -- Options: "groq", "openai", "ollama", "lmstudio", "custom"

      -- Configuration détaillée des providers
      providers = {
        -- Groq (gratuit, rapide, recommandé pour débuter)
        groq = {
          api_url = "https://api.groq.com/openai/v1/chat/completions",
          model = "llama-3.3-70b-versatile", -- ou "mixtral-8x7b-32768"
          api_key_env = "GROQ_API_KEY",
          system_prompt = "Tu es John Carmack, mon mentor en programmation. Fournis des explications claires avec des exemples de code concrets et fonctionnels.",
        },

        -- OpenAI (payant, haute qualité)
        openai = {
          api_url = "https://api.openai.com/v1/chat/completions",
          model = "gpt-4", -- ou "gpt-3.5-turbo" pour moins cher
          api_key_env = "OPENAI_API_KEY",
          system_prompt = "Tu es un expert en programmation qui fournit des explications détaillées avec du code.",
        },

        -- Ollama (local, gratuit, privé)
        ollama = {
          api_url = "http://localhost:11434/api/chat",
          model = "codellama", -- ou "llama3", "mistral", etc.
          system_prompt = "Tu es un mentor expert qui aide à comprendre le code.",
        },

        -- LM Studio (local avec interface graphique)
        lmstudio = {
          api_url = "http://localhost:1234/v1/chat/completions",
          model = "local-model",
          system_prompt = "Tu es un mentor expert qui aide à comprendre le code.",
        },

        -- Custom (votre propre API)
        custom = {
          api_url = "https://votre-api.com/v1/chat",
          model = "votre-modele",
          api_key_env = "VOTRE_API_KEY",
          system_prompt = "Votre prompt personnalisé...",
        },
      },

      -- ============================================
      -- CONFIGURATION DE L'INTERFACE
      -- ============================================

      ui = {
        -- Style de bordure
        border = "rounded", -- Options: "none", "single", "double", "rounded", "solid", "shadow"

        -- Taille de la fenêtre (ratio de l'écran)
        width_ratio = 0.8,  -- 80% de la largeur
        height_ratio = 0.8, -- 80% de la hauteur

        -- Taille maximale
        max_width = 120,
        max_height = 40,

        -- Position
        position = "center", -- Options: "center", "top", "bottom", "left", "right"

        -- Transparence (0-100, 0 = opaque)
        transparency = 0,
      },

      -- ============================================
      -- CONFIGURATION DU STOCKAGE
      -- ============================================

      storage = {
        -- Activer la sauvegarde des concepts
        enabled = true,

        -- Chemin du fichier de stockage
        path = vim.fn.stdpath("data") .. "/lazylearn_concepts.json",

        -- Sauvegarde automatique (sans demander confirmation)
        auto_save = false, -- Mettre à true pour auto-save
      },

      -- ============================================
      -- RÉVISION ESPACÉE (Spaced Repetition)
      -- ============================================

      spaced_repetition = {
        -- Activer le système de révision
        enabled = true,

        -- Vérifier les révisions au démarrage de Neovim
        check_on_startup = true,

        -- Intervalles de révision en jours selon la difficulté (1-5)
        intervals = {
          1,  -- Difficulté 1 (très difficile) : 1 jour
          3,  -- Difficulté 2 (difficile)      : 3 jours
          7,  -- Difficulté 3 (moyen)          : 7 jours
          14, -- Difficulté 4 (facile)         : 14 jours
          30, -- Difficulté 5 (très facile)    : 30 jours
        },
      },

      -- ============================================
      -- PACKS COMMUNAUTAIRES
      -- ============================================

      packs = {
        -- Activer le chargement des packs
        enabled = true,

        -- Chemins où chercher les packs (fichiers .json)
        paths = {
          vim.fn.stdpath("data") .. "/lazylearn/packs",
          vim.fn.stdpath("config") .. "/lazylearn/packs",
        },
      },

      -- ============================================
      -- RACCOURCIS CLAVIER
      -- ============================================

      keymaps = {
        -- En mode visuel
        trigger = "<leader>h",       -- Analyser la sélection

        -- En mode normal
        show_concepts = "<leader>sc",   -- Afficher les concepts
        review_concepts = "<leader>sr", -- Réviser les concepts

        -- Dans la fenêtre flottante (automatiques)
        close = { "q", "<Esc>" },
      },
    })
  end,
}

-- ============================================
-- EXEMPLES D'UTILISATION
-- ============================================

--[[

1. ANALYSER DU CODE
   - Sélectionnez du code en mode visuel (V, v, ou Ctrl-v)
   - Appuyez sur <leader>h
   - Choisissez une technique d'apprentissage
   - Lisez l'explication

2. SAUVEGARDER UN CONCEPT
   - Après avoir reçu une explication
   - Le plugin vous demande si vous voulez sauvegarder
   - Donnez un nom au concept
   - Il sera sauvegardé pour révision ultérieure

3. RÉVISER LES CONCEPTS
   - :LLearnReview ou <leader>sr
   - Répondez 1-5 selon la difficulté
   - Le concept sera programmé pour la prochaine révision

4. VOIR LES STATISTIQUES
   - :LLearnStats
   - Nombre de concepts, révisions, etc.

5. CHANGER DE PROVIDER
   - :LLearnProvider
   - Sélectionnez un nouveau provider

6. TESTER LA CONNEXION
   - :LLearnTest
   - Vérifie que votre API fonctionne

]]

-- ============================================
-- CONFIGURATION SHELL REQUISE
-- ============================================

--[[

Ajoutez à votre ~/.bashrc ou ~/.zshrc :

# Pour Groq (recommandé pour débuter)
export GROQ_API_KEY="votre_clé_groq"

# Pour OpenAI (optionnel)
export OPENAI_API_KEY="votre_clé_openai"

Puis rechargez :
source ~/.bashrc

]]
