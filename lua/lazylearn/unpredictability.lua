-- LazyLearn.nvim - Unpredictability Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système d'imprévisibilité et curiosité (Core Drive 7)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local progression = require("lazylearn.progression")
local storage = require("lazylearn.storage")

-- Seed le générateur de nombres aléatoires une seule fois au chargement du module
math.randomseed(os.time() + (vim.loop.hrtime() % 100000))

-- Easter eggs (surprises rares)
M.EASTER_EGGS = {
  {
    id = "carmack_quote",
    name = "💬 Citation de Carmack",
    rarity = 0.02, -- 2% chance
    message = "John Carmack dit : 'Focused, hard work is the real key to success.'",
    reward_xp = 100,
  },
  {
    id = "lucky_streak",
    name = "🍀 Streak Chanceux",
    rarity = 0.05, -- 5% chance
    message = "Jour de chance ! Votre prochain gain d'XP est doublé !",
    effect = "double_xp_next",
  },
  {
    id = "mystery_mentor",
    name = "🎭 Mentor Mystère",
    rarity = 0.03, -- 3% chance
    message = "Un mentor mystère vous observe... +50 XP bonus !",
    reward_xp = 50,
  },
  {
    id = "code_archaeologist",
    name = "🏺 Archéologue du Code",
    rarity = 0.01, -- 1% chance (très rare)
    message = "Vous avez découvert un artefact ancien ! +200 XP !",
    reward_xp = 200,
  },
}

-- Récompenses mystères quotidiennes
M.MYSTERY_REWARDS = {
  { name = "🎁 Petit Bonus", xp_min = 10, xp_max = 30, weight = 40 },
  { name = "🎁 Bonus Moyen", xp_min = 30, xp_max = 70, weight = 30 },
  { name = "🎁 Gros Bonus", xp_min = 70, xp_max = 150, weight = 20 },
  { name = "🎁 JACKPOT", xp_min = 150, xp_max = 300, weight = 5 },
  { name = "🎁 MEGA JACKPOT", xp_min = 300, xp_max = 500, weight = 3 },
  { name = "💎 Token Bonus", tokens = 2, weight = 2 },
}

-- Prompts mystères qui se révèlent progressivement
M.MYSTERY_PROMPTS = {
  {
    id = "mystery_optimization",
    revealed_name = "🔍 Optimisation Secrète",
    hidden_name = "❓ Prompt Mystère #1",
    description = "Un prompt d'optimisation avancé...",
    unlock_uses = 5, -- Se révèle après 5 utilisations
    prompt = "Analyse ce code avec un focus extrême sur l'optimisation de performance. Identifie les goulots d'étranglement et propose des solutions concrètes avec benchmarks.",
  },
  {
    id = "mystery_security",
    revealed_name = "🛡️ Audit de Sécurité",
    hidden_name = "❓ Prompt Mystère #2",
    description = "Un prompt de sécurité avancé...",
    unlock_uses = 5,
    prompt = "Effectue un audit de sécurité complet de ce code. Identifie toutes les vulnérabilités potentielles (injection, XSS, buffer overflow, etc.) et propose des corrections.",
  },
  {
    id = "mystery_architecture",
    revealed_name = "🏛️ Revue d'Architecture",
    hidden_name = "❓ Prompt Mystère #3",
    description = "Un prompt d'architecture avancé...",
    unlock_uses = 5,
    prompt = "Analyse l'architecture de ce code. Évalue les design patterns utilisés, identifie les problèmes de couplage et propose une architecture améliorée avec diagrammes.",
  },
}

-- Concepts aléatoires à découvrir
M.RANDOM_CONCEPTS = {
  { language = "javascript", topic = "Event Loop", difficulty = "intermediate" },
  { language = "javascript", topic = "Prototypal Inheritance", difficulty = "advanced" },
  { language = "rust", topic = "Lifetimes", difficulty = "advanced" },
  { language = "rust", topic = "Traits", difficulty = "intermediate" },
  { language = "python", topic = "Decorators", difficulty = "intermediate" },
  { language = "python", topic = "Metaclasses", difficulty = "advanced" },
  { language = "go", topic = "Goroutines", difficulty = "intermediate" },
  { language = "go", topic = "Channels", difficulty = "intermediate" },
  { language = "cpp", topic = "Move Semantics", difficulty = "advanced" },
  { language = "cpp", topic = "RAII", difficulty = "intermediate" },
}

-- Charger les données d'imprévisibilité
function M.load_unpredictability_data()
  local path = config.options.unpredictability.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      mystery_reward_claimed_date = nil,
      easter_eggs_found = {},
      mystery_prompts_uses = {},
      discovered_concepts = {},
      loot_boxes_opened = 0,
      double_xp_next_active = false,
      total_surprises = 0,
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      mystery_reward_claimed_date = nil,
      easter_eggs_found = {},
      mystery_prompts_uses = {},
      discovered_concepts = {},
      loot_boxes_opened = 0,
      double_xp_next_active = false,
      total_surprises = 0,
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    return {
      mystery_reward_claimed_date = nil,
      easter_eggs_found = {},
      mystery_prompts_uses = {},
      discovered_concepts = {},
      loot_boxes_opened = 0,
      double_xp_next_active = false,
      total_surprises = 0,
    }
  end

  return data
end

-- Sauvegarder les données d'imprévisibilité
function M.save_unpredictability_data(data)
  local path = config.options.unpredictability.data_path
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  return success
end

-- Générer un nombre aléatoire (le seed est initialisé une fois au chargement du module)
function M.random()
  return math.random()
end

-- Vérifier un easter egg aléatoire
function M.check_easter_egg()
  if not config.options.unpredictability.enable_easter_eggs then
    return
  end

  local data = M.load_unpredictability_data()
  local roll = M.random()

  -- Utiliser une probabilité cumulative pour éviter les chevauchements
  local cumulative = 0
  for _, egg in ipairs(M.EASTER_EGGS) do
    cumulative = cumulative + egg.rarity
    if roll <= cumulative then
      -- Easter egg trouvé !
      local already_found = false
      for _, found_id in ipairs(data.easter_eggs_found) do
        if found_id == egg.id then
          already_found = true
          break
        end
      end

      if not already_found then
        table.insert(data.easter_eggs_found, egg.id)
      end

      data.total_surprises = data.total_surprises + 1

      -- Appliquer l'effet
      if egg.reward_xp and config.options.progression.enabled then
        progression.add_xp(egg.reward_xp, "Easter Egg: " .. egg.name)
      end

      if egg.effect == "double_xp_next" then
        data.double_xp_next_active = true
      end

      M.save_unpredictability_data(data)

      ui.info("🎉 SURPRISE ! " .. egg.name .. "\n" .. egg.message)
      return true
    end
  end

  return false
end

-- Appliquer le double XP si actif
function M.apply_double_xp_if_active(xp_amount)
  local data = M.load_unpredictability_data()

  if data.double_xp_next_active then
    data.double_xp_next_active = false
    M.save_unpredictability_data(data)
    ui.info("✨ Double XP activé ! " .. xp_amount .. " → " .. (xp_amount * 2) .. " XP")
    return xp_amount * 2
  end

  return xp_amount
end

-- Récupérer la récompense mystère quotidienne
function M.claim_mystery_reward()
  local data = M.load_unpredictability_data()
  local today = os.date("%Y-%m-%d")

  if data.mystery_reward_claimed_date == today then
    ui.warn("Récompense mystère déjà réclamée aujourd'hui ! Revenez demain.")
    return
  end

  -- Calculer la récompense selon les poids
  local total_weight = 0
  for _, reward in ipairs(M.MYSTERY_REWARDS) do
    total_weight = total_weight + reward.weight
  end

  local roll = M.random() * total_weight
  local current = 0

  for _, reward in ipairs(M.MYSTERY_REWARDS) do
    current = current + reward.weight
    if roll <= current then
      -- Cette récompense est sélectionnée !
      data.mystery_reward_claimed_date = today
      data.total_surprises = data.total_surprises + 1
      M.save_unpredictability_data(data)

      local message = "🎁 Récompense Mystère Quotidienne !\n\n"
      message = message .. "Vous avez obtenu : " .. reward.name .. "\n\n"

      if reward.xp_min then
        local xp = math.random(reward.xp_min, reward.xp_max)
        message = message .. "+" .. xp .. " XP !"

        if config.options.progression.enabled then
          progression.add_xp(xp, "Récompense Mystère")
        end
      elseif reward.tokens then
        message = message .. "+" .. reward.tokens .. " 🎫 !"

        if config.options.scarcity and config.options.scarcity.enabled then
          local scarcity = require("lazylearn.scarcity")
          local scarcity_data = scarcity.load_scarcity_data()
          scarcity_data.tokens = scarcity_data.tokens + reward.tokens
          scarcity.save_scarcity_data(scarcity_data)
        end
      end

      ui.show_response(message, { title = " 🎁 Mystère ! " })
      return
    end
  end
end

-- Découvrir un concept aléatoire
function M.discover_random_concept()
  if #M.RANDOM_CONCEPTS == 0 then
    ui.info("Aucun concept à découvrir pour l'instant")
    return
  end

  local data = M.load_unpredictability_data()

  -- Filtrer les concepts déjà découverts
  local available = {}
  for _, concept in ipairs(M.RANDOM_CONCEPTS) do
    local already_discovered = false
    for _, discovered in ipairs(data.discovered_concepts) do
      if discovered.topic == concept.topic then
        already_discovered = true
        break
      end
    end
    if not already_discovered then
      table.insert(available, concept)
    end
  end

  if #available == 0 then
    ui.info("Vous avez découvert tous les concepts disponibles !")
    return
  end

  -- Choisir un concept aléatoire
  local index = math.random(1, #available)
  local concept = available[index]

  table.insert(data.discovered_concepts, {
    topic = concept.topic,
    language = concept.language,
    difficulty = concept.difficulty,
    discovered_date = os.time(),
  })

  data.total_surprises = data.total_surprises + 1
  M.save_unpredictability_data(data)

  local difficulty_icons = {
    beginner = "🌱",
    intermediate = "🌿",
    advanced = "🌳",
  }

  local message = "# 🔍 Concept Mystère Découvert !\n\n"
  message = message .. "**Langage:** " .. concept.language:upper() .. "\n"
  message = message .. "**Topic:** " .. concept.topic .. "\n"
  message = message .. "**Difficulté:** " .. (difficulty_icons[concept.difficulty] or "❓") .. " " .. concept.difficulty .. "\n\n"
  message = message .. "---\n\n"
  message = message .. "💡 Utilisez `:LLearn` pour apprendre ce concept avec l'IA !\n"

  if config.options.progression.enabled then
    local discovery_xp = 25
    progression.add_xp(discovery_xp, "Découverte de concept")
    message = message .. "\n+" .. discovery_xp .. " XP (Découverte)\n"
  end

  ui.show_response(message, { title = " 🔍 Découverte ! " })
end

-- Afficher les concepts découverts
function M.show_discovered_concepts()
  local data = M.load_unpredictability_data()

  if #data.discovered_concepts == 0 then
    ui.info("Aucun concept découvert. Utilisez :LLearnDiscover pour en découvrir !")
    return
  end

  local display_text = "# 🔍 Concepts Découverts\n\n"
  display_text = display_text .. "**Total découvert:** " .. #data.discovered_concepts .. " / " .. #M.RANDOM_CONCEPTS .. "\n\n"
  display_text = display_text .. "---\n\n"

  for i, concept in ipairs(data.discovered_concepts) do
    local date_str = os.date("%Y-%m-%d", concept.discovered_date)
    local difficulty_icons = {
      beginner = "🌱",
      intermediate = "🌿",
      advanced = "🌳",
    }

    display_text = display_text .. i .. ". **" .. concept.topic .. "**\n"
    display_text = display_text .. "   Langage: " .. concept.language:upper() .. " | "
    display_text = display_text .. "Difficulté: " .. (difficulty_icons[concept.difficulty] or "❓") .. " " .. concept.difficulty .. "\n"
    display_text = display_text .. "   Découvert le: " .. date_str .. "\n\n"
  end

  ui.show_response(display_text, { title = " 🔍 Découvertes " })
end

-- Utiliser un prompt mystère
function M.use_mystery_prompt()
  local data = M.load_unpredictability_data()

  local items = {}
  for _, prompt in ipairs(M.MYSTERY_PROMPTS) do
    local uses = data.mystery_prompts_uses[prompt.id] or 0
    local is_revealed = uses >= prompt.unlock_uses

    local name = is_revealed and prompt.revealed_name or prompt.hidden_name
    local description = is_revealed and prompt.description or ("❓ ??? (Utilisations: " .. uses .. "/" .. prompt.unlock_uses .. ")")

    table.insert(items, {
      name = name,
      icon = is_revealed and "🔓" or "🔒",
      description = description,
      id = prompt.id,
      is_revealed = is_revealed,
      uses = uses,
    })
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    -- Incrémenter les utilisations
    data.mystery_prompts_uses[selected.id] = (data.mystery_prompts_uses[selected.id] or 0) + 1
    local new_uses = data.mystery_prompts_uses[selected.id]

    -- Trouver le prompt
    local prompt_obj = nil
    for _, p in ipairs(M.MYSTERY_PROMPTS) do
      if p.id == selected.id then
        prompt_obj = p
        break
      end
    end

    -- Vérifier si c'est la première fois qu'il est révélé
    if new_uses == prompt_obj.unlock_uses then
      data.total_surprises = data.total_surprises + 1
      M.save_unpredictability_data(data)
      ui.info("🎉 Prompt mystère révélé : " .. prompt_obj.revealed_name .. " !")
    else
      M.save_unpredictability_data(data)
    end

    -- Afficher le prompt
    local message = "# " .. (selected.is_revealed and prompt_obj.revealed_name or prompt_obj.hidden_name) .. "\n\n"

    if selected.is_revealed then
      message = message .. "**Prompt:**\n\n" .. prompt_obj.prompt .. "\n\n"
      message = message .. "---\n\n"
      message = message .. "💡 Copiez ce prompt et utilisez-le avec `:LLearn` !\n"
    else
      message = message .. "🔒 Prompt encore mystérieux...\n\n"
      message = message .. "**Utilisations:** " .. new_uses .. "/" .. prompt_obj.unlock_uses .. "\n\n"
      message = message .. "Continuez à utiliser ce prompt pour le révéler complètement !\n"
    end

    ui.show_response(message, { title = " 🎭 Prompt Mystère " })
  end)
end

-- Afficher les statistiques de surprises
function M.show_stats()
  local data = M.load_unpredictability_data()

  local display_text = "# 🎲 Statistiques de Surprises\n\n"

  display_text = display_text .. "🎉 **Total de surprises:** " .. data.total_surprises .. "\n\n"

  -- Easter eggs
  display_text = display_text .. "## 🥚 Easter Eggs Trouvés\n\n"
  if #data.easter_eggs_found == 0 then
    display_text = display_text .. "Aucun easter egg trouvé pour l'instant...\n\n"
  else
    for _, egg_id in ipairs(data.easter_eggs_found) do
      for _, egg in ipairs(M.EASTER_EGGS) do
        if egg.id == egg_id then
          display_text = display_text .. "- " .. egg.name .. "\n"
          break
        end
      end
    end
    display_text = display_text .. "\n**Total:** " .. #data.easter_eggs_found .. " / " .. #M.EASTER_EGGS .. "\n\n"
  end

  -- Concepts découverts
  display_text = display_text .. "## 🔍 Concepts Découverts\n\n"
  display_text = display_text .. "**Total:** " .. #data.discovered_concepts .. " / " .. #M.RANDOM_CONCEPTS .. "\n\n"

  -- Prompts mystères
  display_text = display_text .. "## 🎭 Prompts Mystères\n\n"
  local revealed_count = 0
  for _, prompt in ipairs(M.MYSTERY_PROMPTS) do
    local uses = data.mystery_prompts_uses[prompt.id] or 0
    local is_revealed = uses >= prompt.unlock_uses
    if is_revealed then
      revealed_count = revealed_count + 1
    end

    local status = is_revealed and "✅" or "🔒"
    local name = is_revealed and prompt.revealed_name or prompt.hidden_name
    display_text = display_text .. status .. " " .. name .. " (" .. uses .. "/" .. prompt.unlock_uses .. ")\n"
  end
  display_text = display_text .. "\n**Révélés:** " .. revealed_count .. " / " .. #M.MYSTERY_PROMPTS .. "\n\n"

  -- Récompense mystère
  display_text = display_text .. "## 🎁 Récompense Mystère\n\n"
  if data.mystery_reward_claimed_date == os.date("%Y-%m-%d") then
    display_text = display_text .. "✅ Réclamée aujourd'hui\n"
  else
    display_text = display_text .. "⏰ Disponible ! Utilisez :LLearnMystery\n"
  end

  ui.show_response(display_text, { title = " 🎲 Surprises " })
end

return M
