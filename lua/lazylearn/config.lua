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

-- Initialiser la configuration
function M.setup(opts)
  opts = opts or {}
  M.options = merge_tables(M.defaults, opts)

  -- Créer les répertoires nécessaires si absents
  local storage_dir = vim.fn.fnamemodify(M.options.storage.path, ":h")
  if vim.fn.isdirectory(storage_dir) == 0 then
    vim.fn.mkdir(storage_dir, "p")
  end

  -- Créer les répertoires pour les packs
  if M.options.packs.enabled then
    for _, pack_path in ipairs(M.options.packs.paths) do
      if vim.fn.isdirectory(pack_path) == 0 then
        vim.fn.mkdir(pack_path, "p")
      end
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
