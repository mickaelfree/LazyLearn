-- LazyLearn.nvim - Community Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de contribution et partage de concepts avec la communauté

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local storage = require("lazylearn.storage")

-- Charger les données communautaires depuis le fichier JSON
function M.load_community_data()
  local path = config.options.community.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      shared_concepts = {},
      contributions = {},
      impact_stats = {
        total_shared = 0,
        total_helped = 0,
        total_downloads = 0,
        total_likes = 0,
      },
      user_profile = {
        username = "",
        joined_date = os.time(),
        contributor_level = "Novice",
        badges = {},
      },
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return M.load_community_data() -- Retourner structure vide
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    ui.error("Impossible de charger les données communautaires")
    return M.load_community_data() -- Retourner structure vide
  end

  return data
end

-- Sauvegarder les données communautaires
function M.save_community_data(data)
  local path = config.options.community.data_path

  -- Créer le répertoire parent si nécessaire
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success, error = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  if not success then
    ui.error("Impossible de sauvegarder les données communautaires: " .. tostring(error))
    return false
  end

  return true
end

-- Générer un hash anonyme pour un concept
local function generate_concept_hash(concept)
  -- Hash simple basé sur le contenu (pour éviter les doublons)
  local content = concept.name .. concept.text .. concept.response
  local hash = 0
  for i = 1, #content do
    hash = (hash * 31 + string.byte(content, i)) % 1000000
  end
  return "concept_" .. hash
end

-- Anonymiser un concept pour le partage
local function anonymize_concept(concept)
  return {
    hash = generate_concept_hash(concept),
    name = concept.name,
    text = concept.text,
    response = concept.response,
    technique = concept.technique or "Unknown",
    language = M.detect_language(concept.text),
    tags = concept.tags or {},
    shared_date = os.time(),
    downloads = 0,
    likes = 0,
    helpful_count = 0,
  }
end

-- Détecter le langage de programmation
function M.detect_language(code)
  -- Détection simple par patterns
  local patterns = {
    { pattern = "function%s+%w+%s*%(", lang = "javascript" },
    { pattern = "const%s+%w+%s*=", lang = "javascript" },
    { pattern = "def%s+%w+%s*%(", lang = "python" },
    { pattern = "class%s+%w+%s*:", lang = "python" },
    { pattern = "fn%s+%w+%s*%(", lang = "rust" },
    { pattern = "impl%s+", lang = "rust" },
    { pattern = "func%s+%w+%s*%(", lang = "go" },
    { pattern = "package%s+", lang = "go" },
    { pattern = "public%s+class%s+", lang = "java" },
    { pattern = "#include%s*<", lang = "cpp" },
  }

  for _, p in ipairs(patterns) do
    if code:match(p.pattern) then
      return p.lang
    end
  end

  return "unknown"
end

-- Partager un concept avec la communauté
function M.share_concept(concept_index)
  if not config.options.community.enabled then
    ui.error("Le système communautaire n'est pas activé")
    return false
  end

  -- Charger le concept depuis le storage
  local concepts = storage.load_concepts()
  local concept = concepts[concept_index]

  if not concept then
    ui.error("Concept introuvable")
    return false
  end

  -- Charger les données communautaires
  local data = M.load_community_data()

  -- Vérifier si déjà partagé
  local hash = generate_concept_hash(concept)
  for _, shared in ipairs(data.shared_concepts) do
    if shared.hash == hash then
      ui.warn("Ce concept a déjà été partagé")
      return false
    end
  end

  -- Anonymiser et ajouter
  local shared_concept = anonymize_concept(concept)
  table.insert(data.shared_concepts, shared_concept)

  -- Mettre à jour les stats
  data.impact_stats.total_shared = data.impact_stats.total_shared + 1

  -- Ajouter aux contributions
  table.insert(data.contributions, {
    concept_hash = hash,
    date = os.time(),
    type = "share",
  })

  -- Calculer le niveau de contributeur
  M.update_contributor_level(data)

  -- Sauvegarder
  if M.save_community_data(data) then
    ui.info("✨ Concept partagé avec la communauté ! Vous avez maintenant " .. data.impact_stats.total_shared .. " concept(s) partagé(s)")
    return true
  end

  return false
end

-- Mettre à jour le niveau de contributeur
function M.update_contributor_level(data)
  local total = data.impact_stats.total_shared
  local helped = data.impact_stats.total_helped

  -- Niveaux de contributeur
  if total >= 50 or helped >= 100 then
    data.user_profile.contributor_level = "Legend"
    M.unlock_badge(data, "legend_contributor")
  elseif total >= 20 or helped >= 50 then
    data.user_profile.contributor_level = "Master"
    M.unlock_badge(data, "master_contributor")
  elseif total >= 10 or helped >= 20 then
    data.user_profile.contributor_level = "Expert"
    M.unlock_badge(data, "expert_contributor")
  elseif total >= 5 or helped >= 10 then
    data.user_profile.contributor_level = "Contributor"
    M.unlock_badge(data, "active_contributor")
  elseif total >= 1 then
    data.user_profile.contributor_level = "Apprentice"
    M.unlock_badge(data, "first_share")
  else
    data.user_profile.contributor_level = "Novice"
  end
end

-- Débloquer un badge
function M.unlock_badge(data, badge_id)
  -- Vérifier si déjà débloqué
  for _, badge in ipairs(data.user_profile.badges) do
    if badge.id == badge_id then
      return false
    end
  end

  -- Badges disponibles
  local badges = {
    first_share = {
      id = "first_share",
      name = "🌱 Premier Pas",
      description = "Partagé votre premier concept",
    },
    active_contributor = {
      id = "active_contributor",
      name = "🔥 Contributeur Actif",
      description = "Partagé 5+ concepts",
    },
    expert_contributor = {
      id = "expert_contributor",
      name = "⭐ Expert Communautaire",
      description = "Partagé 10+ concepts",
    },
    master_contributor = {
      id = "master_contributor",
      name = "🏆 Maître Contributeur",
      description = "Partagé 20+ concepts",
    },
    legend_contributor = {
      id = "legend_contributor",
      name = "👑 Légende Vivante",
      description = "Partagé 50+ concepts",
    },
    helpful_hero = {
      id = "helpful_hero",
      name = "💝 Héros Serviable",
      description = "Aidé 10+ développeurs",
    },
    impact_maker = {
      id = "impact_maker",
      name = "🚀 Créateur d'Impact",
      description = "Aidé 50+ développeurs",
    },
  }

  local badge = badges[badge_id]
  if badge then
    badge.unlocked_date = os.time()
    table.insert(data.user_profile.badges, badge)
    ui.info("🎉 Nouveau badge débloqué : " .. badge.name)
    return true
  end

  return false
end

-- Simuler l'impact (dans un vrai système, ce serait un backend)
function M.simulate_impact()
  local data = M.load_community_data()

  -- Simuler des downloads/likes aléatoires
  for _, concept in ipairs(data.shared_concepts) do
    -- Simuler entre 0 et 3 nouvelles personnes aidées par jour
    local new_helped = math.random(0, 3)
    concept.helpful_count = concept.helpful_count + new_helped
    data.impact_stats.total_helped = data.impact_stats.total_helped + new_helped

    -- Simuler des likes
    if math.random() > 0.7 then
      concept.likes = concept.likes + math.random(1, 2)
      data.impact_stats.total_likes = data.impact_stats.total_likes + math.random(1, 2)
    end
  end

  -- Mettre à jour le niveau
  M.update_contributor_level(data)

  -- Débloquer badges basés sur l'aide
  if data.impact_stats.total_helped >= 50 then
    M.unlock_badge(data, "impact_maker")
  elseif data.impact_stats.total_helped >= 10 then
    M.unlock_badge(data, "helpful_hero")
  end

  M.save_community_data(data)
end

-- Afficher les stats d'impact communautaire
function M.show_impact_stats()
  if not config.options.community.enabled then
    ui.error("Le système communautaire n'est pas activé")
    return
  end

  -- Simuler l'impact avant d'afficher
  if config.options.community.simulate_impact then
    M.simulate_impact()
  end

  local data = M.load_community_data()
  local stats = data.impact_stats
  local profile = data.user_profile

  local display_text = "# 🌟 Votre Impact Communautaire\n\n"

  -- Profil
  display_text = display_text .. "## 👤 Profil\n\n"
  display_text = display_text .. "**Niveau:** " .. profile.contributor_level .. "\n"
  display_text = display_text .. "**Membre depuis:** " .. os.date("%Y-%m-%d", profile.joined_date) .. "\n\n"

  -- Stats globales
  display_text = display_text .. "## 📊 Statistiques Globales\n\n"
  display_text = display_text .. "🎁 **Concepts partagés:** " .. stats.total_shared .. "\n"
  display_text = display_text .. "👥 **Développeurs aidés:** " .. stats.total_helped .. "\n"
  display_text = display_text .. "❤️  **Total de likes:** " .. stats.total_likes .. "\n\n"

  -- Epic meaning message
  if stats.total_helped > 0 then
    display_text = display_text .. "---\n\n"
    display_text = display_text .. "✨ **Votre apprentissage a aidé " .. stats.total_helped .. " développeur(s) !**\n"
    display_text = display_text .. "*Vous contribuez à rendre la communauté plus forte.*\n\n"
  end

  -- Badges
  if #profile.badges > 0 then
    display_text = display_text .. "## 🏅 Badges Débloqués (" .. #profile.badges .. ")\n\n"
    for _, badge in ipairs(profile.badges) do
      display_text = display_text .. "- " .. badge.name .. " - *" .. badge.description .. "*\n"
    end
    display_text = display_text .. "\n"
  end

  -- Concepts les plus utiles
  if #data.shared_concepts > 0 then
    display_text = display_text .. "## 🔥 Vos Concepts les Plus Utiles\n\n"

    -- Trier par helpful_count
    local sorted = {}
    for _, concept in ipairs(data.shared_concepts) do
      table.insert(sorted, concept)
    end
    table.sort(sorted, function(a, b)
      return a.helpful_count > b.helpful_count
    end)

    -- Afficher top 5
    for i = 1, math.min(5, #sorted) do
      local concept = sorted[i]
      display_text = display_text .. i .. ". **" .. concept.name .. "**\n"
      display_text = display_text .. "   - 👥 Aidé " .. concept.helpful_count .. " personne(s)\n"
      display_text = display_text .. "   - ❤️  " .. concept.likes .. " likes\n"
      display_text = display_text .. "   - 🏷️  " .. concept.language .. "\n\n"
    end
  end

  -- Prochains objectifs
  display_text = display_text .. "## 🎯 Prochains Objectifs\n\n"
  local next_level_shares = M.get_next_level_requirement(stats.total_shared)
  if next_level_shares then
    display_text = display_text .. "- Partager " .. next_level_shares - stats.total_shared .. " concept(s) de plus pour passer au niveau supérieur\n"
  end

  ui.show_response(display_text, { title = " 🌟 Impact Communautaire " })
end

-- Obtenir le nombre de shares nécessaires pour le prochain niveau
function M.get_next_level_requirement(current_shares)
  local levels = { 1, 5, 10, 20, 50 }
  for _, level in ipairs(levels) do
    if current_shares < level then
      return level
    end
  end
  return nil -- Max level atteint
end

-- Afficher le menu de partage
function M.show_share_menu()
  local concepts = storage.load_concepts()

  if #concepts == 0 then
    ui.info("Aucun concept à partager. Créez d'abord des concepts avec LazyLearn!")
    return
  end

  -- Créer une liste de sélection
  local items = {}
  for i, concept in ipairs(concepts) do
    table.insert(items, {
      index = i,
      name = concept.name,
      icon = "📚",
      description = "Créé le " .. os.date("%Y-%m-%d", concept.timestamp),
    })
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    -- Demander confirmation
    ui.input("Partager '" .. selected.name .. "' avec la communauté ? (oui/non): ", function(input)
      if input and input:lower() == "oui" then
        M.share_concept(selected.index)
      end
    end, { default = "oui" })
  end)
end

-- Initialiser le profil utilisateur
function M.init_user_profile()
  local data = M.load_community_data()

  if data.user_profile.username == "" then
    ui.input("Choisissez un nom d'utilisateur (anonyme): ", function(username)
      if username and username ~= "" then
        data.user_profile.username = username
        data.user_profile.joined_date = os.time()
        M.save_community_data(data)
        ui.info("✨ Bienvenue dans la communauté LazyLearn, " .. username .. " !")
      end
    end, { default = "dev_" .. math.random(1000, 9999) })
  end
end

return M
