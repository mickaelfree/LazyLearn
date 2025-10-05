-- LazyLearn.nvim - API Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")

-- Vérifier si plenary est disponible
local has_plenary, curl = pcall(require, "plenary.curl")
if not has_plenary then
  vim.notify("LazyLearn: plenary.nvim est requis. Installez-le via votre gestionnaire de plugins.", vim.log.levels.ERROR)
end

-- Provider Groq/OpenAI (compatible OpenAI API)
local function query_openai_compatible(provider, messages, callback)
  local api_key = vim.env[provider.api_key_env]

  if not api_key and provider.api_key_env then
    ui.error("Variable d'environnement " .. provider.api_key_env .. " non définie")
    return
  end

  local headers = {
    ["Content-Type"] = "application/json",
  }

  if api_key then
    headers["Authorization"] = "Bearer " .. api_key
  end

  local body = {
    model = provider.model,
    messages = messages,
  }

  -- Requête asynchrone
  curl.post(provider.api_url, {
    headers = headers,
    body = vim.fn.json_encode(body),
    callback = vim.schedule_wrap(function(response)
      if response.status == 200 then
        local result = vim.fn.json_decode(response.body)
        local content = result.choices[1].message.content
        callback(content, nil)
      else
        local error_msg = "Erreur API (" .. response.status .. "): " .. (response.body or "Pas de détails")
        callback(nil, error_msg)
      end
    end),
  })
end

-- Provider Ollama
local function query_ollama(provider, messages, callback)
  local body = {
    model = provider.model,
    messages = messages,
    stream = false,
  }

  -- Requête asynchrone
  curl.post(provider.api_url, {
    headers = {
      ["Content-Type"] = "application/json",
    },
    body = vim.fn.json_encode(body),
    callback = vim.schedule_wrap(function(response)
      if response.status == 200 then
        local result = vim.fn.json_decode(response.body)
        local content = result.message.content
        callback(content, nil)
      else
        local error_msg = "Erreur Ollama (" .. response.status .. "): " .. (response.body or "Pas de détails")
        callback(nil, error_msg)
      end
    end),
  })
end

-- Provider LM Studio (compatible OpenAI)
local function query_lmstudio(provider, messages, callback)
  query_openai_compatible(provider, messages, callback)
end

-- Router vers le bon provider
local function route_to_provider(provider_name, messages, callback)
  local provider = config.options.providers[provider_name]

  if not provider then
    ui.error("Provider inconnu: " .. provider_name)
    return
  end

  if provider_name == "groq" or provider_name == "openai" or provider_name == "custom" then
    query_openai_compatible(provider, messages, callback)
  elseif provider_name == "ollama" then
    query_ollama(provider, messages, callback)
  elseif provider_name == "lmstudio" then
    query_lmstudio(provider, messages, callback)
  else
    ui.error("Provider non supporté: " .. provider_name)
  end
end

-- Fonction principale pour interroger l'IA
function M.query(prompt, text, callback)
  if not has_plenary then
    ui.error("plenary.nvim n'est pas installé")
    return
  end

  local provider_name = config.options.provider
  local provider = config.get_provider()

  -- Construire les messages
  local messages = {
    {
      role = "system",
      content = provider.system_prompt,
    },
    {
      role = "user",
      content = prompt .. "\n\n" .. text,
    },
  }

  -- Afficher un indicateur de chargement
  ui.info("Interrogation de l'IA en cours...")

  -- Appeler le provider
  route_to_provider(provider_name, messages, function(content, error)
    if error then
      ui.error(error)
      if callback then
        callback(nil, error)
      end
    else
      if callback then
        callback(content, nil)
      end
    end
  end)
end

-- Fonction pour tester la connexion au provider
function M.test_connection(provider_name, callback)
  provider_name = provider_name or config.options.provider
  local provider = config.options.providers[provider_name]

  if not provider then
    ui.error("Provider inconnu: " .. provider_name)
    return
  end

  local messages = {
    {
      role = "user",
      content = "Réponds juste 'OK' si tu me reçois.",
    },
  }

  ui.info("Test de connexion à " .. provider_name .. "...")

  route_to_provider(provider_name, messages, function(content, error)
    if error then
      ui.error("Échec de connexion: " .. error)
      if callback then
        callback(false, error)
      end
    else
      ui.info("Connexion réussie à " .. provider_name)
      if callback then
        callback(true, content)
      end
    end
  end)
end

-- Lister les providers disponibles
function M.list_providers()
  local providers = {}
  for name, _ in pairs(config.options.providers) do
    table.insert(providers, name)
  end
  return providers
end

-- Changer de provider interactivement
function M.select_provider()
  local providers = M.list_providers()

  vim.ui.select(providers, {
    prompt = "Sélectionner un provider IA:",
    format_item = function(item)
      local current = config.options.provider == item and " (actuel)" or ""
      return item .. current
    end,
  }, function(choice)
    if choice then
      config.set_provider(choice)
    end
  end)
end

return M
