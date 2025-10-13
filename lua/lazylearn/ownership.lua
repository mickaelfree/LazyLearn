-- LazyLearn.nvim - Ownership Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de possession et collections (Core Drive 4)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local storage = require("lazylearn.storage")
local progression = require("lazylearn.progression")

-- Raretés des concepts
M.RARITIES = {
  common = { name = "Common", icon = "⚪", min_reviews = 0 },
  uncommon = { name = "Uncommon", icon = "🟢", min_reviews = 3 },
  rare = { name = "Rare", icon = "🔵", min_reviews = 7 },
  epic = { name = "Epic", icon = "🟣", min_reviews = 15 },
  legendary = { name = "Legendary", icon = "🟡", min_reviews = 25 },
}

-- Charger les données de possession
function M.load_ownership_data()
  local path = config.options.ownership.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      collections = {},
      concept_stats = {},
      vault_value = 0,
      achievements = {},
      customizations = {},
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      collections = {},
      concept_stats = {},
      vault_value = 0,
      achievements = {},
      customizations = {},
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    ui.error("Impossible de charger les données de possession")
    return {
      collections = {},
      concept_stats = {},
      vault_value = 0,
      achievements = {},
      customizations = {},
    }
  end

  return data
end

-- Sauvegarder les données de possession
function M.save_ownership_data(data)
  local path = config.options.ownership.data_path

  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local success, error = pcall(function()
    vim.fn.writefile({ vim.fn.json_encode(data) }, path)
  end)

  if not success then
    ui.error("Impossible de sauvegarder: " .. tostring(error))
    return false
  end

  return true
end

-- Calculer la rareté d'un concept
function M.calculate_rarity(review_count)
  if review_count >= 25 then
    return "legendary"
  elseif review_count >= 15 then
    return "epic"
  elseif review_count >= 7 then
    return "rare"
  elseif review_count >= 3 then
    return "uncommon"
  else
    return "common"
  end
end

-- Obtenir les stats d'un concept
function M.get_concept_stats(concept_name)
  local data = M.load_ownership_data()

  if not data.concept_stats[concept_name] then
    data.concept_stats[concept_name] = {
      views = 0,
      time_spent = 0,
      last_viewed = nil,
      notes = "",
      custom_tags = {},
      favorite = false,
    }
    M.save_ownership_data(data)
  end

  return data.concept_stats[concept_name]
end

-- Incrémenter les vues d'un concept
function M.increment_views(concept_name)
  local data = M.load_ownership_data()

  if not data.concept_stats[concept_name] then
    data.concept_stats[concept_name] = {
      views = 0,
      time_spent = 0,
      last_viewed = nil,
      notes = "",
      custom_tags = {},
      favorite = false,
    }
  end

  data.concept_stats[concept_name].views = data.concept_stats[concept_name].views + 1
  data.concept_stats[concept_name].last_viewed = os.time()

  M.save_ownership_data(data)
end

-- Afficher le vault (coffre de connaissances)
function M.show_vault()
  local concepts = storage.load_concepts()
  local data = M.load_ownership_data()
  local prog_data = progression.load_progression_data()

  local display_text = "# 💎 Votre Coffre de Connaissances\n\n"

  -- Stats globales
  local total_concepts = #concepts
  local total_reviews = 0
  local total_xp = prog_data.total_xp or 0

  for _, concept in ipairs(concepts) do
    total_reviews = total_reviews + (concept.review_count or 0)
  end

  display_text = display_text .. "## 📊 Valeur de votre Bibliothèque\n\n"
  display_text = display_text .. "💎 **Concepts possédés:** " .. total_concepts .. "\n"
  display_text = display_text .. "📈 **Total XP accumulé:** " .. total_xp .. "\n"
  display_text = display_text .. "✅ **Révisions effectuées:** " .. total_reviews .. "\n"
  display_text = display_text .. "🏆 **Valeur estimée:** " .. (total_concepts * 10 + total_xp) .. " points\n\n"

  -- Répartition par rareté
  local rarity_counts = {
    common = 0,
    uncommon = 0,
    rare = 0,
    epic = 0,
    legendary = 0,
  }

  for _, concept in ipairs(concepts) do
    local rarity = M.calculate_rarity(concept.review_count or 0)
    rarity_counts[rarity] = rarity_counts[rarity] + 1
  end

  display_text = display_text .. "## 🎴 Répartition par Rareté\n\n"
  for rarity, count in pairs(rarity_counts) do
    if count > 0 then
      local r = M.RARITIES[rarity]
      display_text = display_text .. r.icon .. " **" .. r.name .. ":** " .. count .. "\n"
    end
  end
  display_text = display_text .. "\n"

  -- Collections
  if next(data.collections) then
    display_text = display_text .. "## 📚 Vos Collections\n\n"
    for name, collection in pairs(data.collections) do
      local progress = #collection.concepts .. "/" .. (collection.target or "∞")
      display_text = display_text .. "- **" .. name .. "** (" .. progress .. ")\n"
    end
    display_text = display_text .. "\n"
  end

  -- Top 5 concepts les plus précieux
  display_text = display_text .. "## ⭐ Top 5 Concepts Précieux\n\n"

  local valued_concepts = {}
  for _, concept in ipairs(concepts) do
    local stats = M.get_concept_stats(concept.name)
    local value = (concept.review_count or 0) * 10 + stats.views * 2
    table.insert(valued_concepts, {
      name = concept.name,
      value = value,
      reviews = concept.review_count or 0,
      views = stats.views,
      rarity = M.calculate_rarity(concept.review_count or 0),
    })
  end

  table.sort(valued_concepts, function(a, b) return a.value > b.value end)

  for i = 1, math.min(5, #valued_concepts) do
    local c = valued_concepts[i]
    local r = M.RARITIES[c.rarity]
    display_text = display_text .. i .. ". " .. r.icon .. " **" .. c.name .. "**\n"
    display_text = display_text .. "   - Valeur: " .. c.value .. " pts | "
    display_text = display_text .. "Révisions: " .. c.reviews .. " | "
    display_text = display_text .. "Vues: " .. c.views .. "\n\n"
  end

  ui.show_response(display_text, { title = " 💎 Coffre de Connaissances " })
end

-- Créer une collection
function M.create_collection()
  ui.input("Nom de la collection: ", function(name)
    if not name or name == "" then
      return
    end

    ui.input("Nombre de concepts cible (optionnel): ", function(target)
      local data = M.load_ownership_data()

      data.collections[name] = {
        concepts = {},
        created = os.time(),
        target = tonumber(target) or nil,
        description = "",
      }

      M.save_ownership_data(data)
      ui.info("📚 Collection '" .. name .. "' créée !")
    end)
  end)
end

-- Ajouter un concept à une collection
function M.add_to_collection()
  local data = M.load_ownership_data()

  if not next(data.collections) then
    ui.info("Créez d'abord une collection avec :LLearnCreateCollection")
    return
  end

  -- Sélectionner la collection
  local collections = {}
  for name, coll in pairs(data.collections) do
    table.insert(collections, {
      name = name,
      icon = "📚",
      description = #coll.concepts .. " concept(s)",
    })
  end

  ui.select_prompt(collections, function(selected_coll)
    if not selected_coll then
      return
    end

    -- Sélectionner le concept
    local concepts = storage.load_concepts()
    local items = {}
    for i, concept in ipairs(concepts) do
      table.insert(items, {
        index = i,
        name = concept.name,
        icon = "📝",
      })
    end

    ui.select_prompt(items, function(selected_concept)
      if not selected_concept then
        return
      end

      local concept = concepts[selected_concept.index]

      -- Vérifier si déjà dans la collection
      for _, c in ipairs(data.collections[selected_coll.name].concepts) do
        if c == concept.name then
          ui.warn("Ce concept est déjà dans la collection")
          return
        end
      end

      table.insert(data.collections[selected_coll.name].concepts, concept.name)
      M.save_ownership_data(data)

      ui.info("✨ '" .. concept.name .. "' ajouté à '" .. selected_coll.name .. "'")
    end)
  end)
end

-- Afficher les collections
function M.show_collections()
  local data = M.load_ownership_data()

  if not next(data.collections) then
    ui.info("Aucune collection. Créez-en une avec :LLearnCreateCollection")
    return
  end

  local display_text = "# 📚 Vos Collections\n\n"

  for name, collection in pairs(data.collections) do
    local progress = #collection.concepts
    local target = collection.target or "∞"
    local percent = collection.target and math.floor((progress / collection.target) * 100) or 0

    display_text = display_text .. "## " .. name .. "\n\n"
    display_text = display_text .. "**Progression:** " .. progress .. "/" .. target

    if collection.target then
      display_text = display_text .. " (" .. percent .. "%)\n\n"

      -- Barre de progression
      local bar_width = 20
      local filled = math.floor((progress / collection.target) * bar_width)
      local bar = "[" .. string.rep("█", filled) .. string.rep("░", bar_width - filled) .. "]"
      display_text = display_text .. bar .. "\n\n"
    else
      display_text = display_text .. "\n\n"
    end

    if #collection.concepts > 0 then
      display_text = display_text .. "**Concepts:**\n"
      for i, concept_name in ipairs(collection.concepts) do
        display_text = display_text .. i .. ". " .. concept_name .. "\n"
      end
      display_text = display_text .. "\n"
    end

    display_text = display_text .. "*Créée le " .. os.date("%Y-%m-%d", collection.created) .. "*\n\n"
    display_text = display_text .. "---\n\n"
  end

  ui.show_response(display_text, { title = " 📚 Collections " })
end

-- Afficher un concept en format carte
function M.show_concept_card(concept_index)
  local concepts = storage.load_concepts()
  local concept = concepts[concept_index]

  if not concept then
    ui.error("Concept introuvable")
    return
  end

  local stats = M.get_concept_stats(concept.name)
  local rarity = M.calculate_rarity(concept.review_count or 0)
  local rarity_info = M.RARITIES[rarity]
  local prog_data = progression.load_progression_data()
  local mastery = prog_data.mastery_levels[concept.name]

  local mastery_names = { "Novice", "Competent", "Proficient", "Expert", "Master" }
  local mastery_level = mastery and mastery_names[mastery.level] or "Novice"

  local display_text = "# 🎴 Concept Card\n\n"
  display_text = display_text .. "```\n"
  display_text = display_text .. "╔════════════════════════════════════════╗\n"
  display_text = display_text .. "║  " .. rarity_info.icon .. " " .. concept.name .. string.rep(" ", math.max(0, 35 - #concept.name)) .. "║\n"
  display_text = display_text .. "║                                        ║\n"
  display_text = display_text .. "║  Rareté: " .. rarity_info.name .. string.rep(" ", math.max(0, 28 - #rarity_info.name)) .. "║\n"
  display_text = display_text .. "║  Maîtrise: " .. mastery_level .. string.rep(" ", math.max(0, 26 - #mastery_level)) .. "║\n"
  display_text = display_text .. "║                                        ║\n"
  display_text = display_text .. "║  📊 Stats:                             ║\n"
  display_text = display_text .. "║    • Révisions: " .. string.format("%-23s", (concept.review_count or 0)) .. "║\n"
  display_text = display_text .. "║    • Vues: " .. string.format("%-29s", stats.views) .. "║\n"
  display_text = display_text .. "║    • XP gagné: " .. string.format("%-25s", (concept.review_count or 0) * 10) .. "║\n"
  display_text = display_text .. "║                                        ║\n"
  display_text = display_text .. "║  Obtenue le: " .. os.date("%Y-%m-%d", concept.timestamp) .. "             ║\n"
  display_text = display_text .. "╚════════════════════════════════════════╝\n"
  display_text = display_text .. "```\n\n"

  if stats.notes and stats.notes ~= "" then
    display_text = display_text .. "## 📝 Notes Personnelles\n\n"
    display_text = display_text .. stats.notes .. "\n\n"
  end

  if #stats.custom_tags > 0 then
    display_text = display_text .. "## 🏷️ Tags Personnalisés\n\n"
    display_text = display_text .. table.concat(stats.custom_tags, ", ") .. "\n\n"
  end

  ui.show_response(display_text, { title = " 🎴 " .. concept.name .. " " })

  -- Incrémenter les vues
  M.increment_views(concept.name)
end

-- Personnaliser un concept
function M.customize_concept()
  local concepts = storage.load_concepts()
  local items = {}

  for i, concept in ipairs(concepts) do
    table.insert(items, {
      index = i,
      name = concept.name,
      icon = "🎴",
    })
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    local concept = concepts[selected.index]
    local stats = M.get_concept_stats(concept.name)

    -- Menu de personnalisation
    local options = {
      { name = "Ajouter une note", action = "note" },
      { name = "Ajouter un tag personnalisé", action = "tag" },
      { name = "Marquer comme favori", action = "favorite" },
      { name = "Voir la carte", action = "card" },
    }

    local opt_items = {}
    for i, opt in ipairs(options) do
      table.insert(opt_items, {
        index = i,
        name = opt.name,
        icon = "✨",
        action = opt.action,
      })
    end

    ui.select_prompt(opt_items, function(opt_selected)
      if not opt_selected then
        return
      end

      if opt_selected.action == "note" then
        ui.input("Note personnelle: ", function(note)
          if note and note ~= "" then
            local data = M.load_ownership_data()
            data.concept_stats[concept.name].notes = note
            M.save_ownership_data(data)
            ui.info("📝 Note ajoutée !")
          end
        end, { default = stats.notes })

      elseif opt_selected.action == "tag" then
        ui.input("Tag personnalisé: ", function(tag)
          if tag and tag ~= "" then
            local data = M.load_ownership_data()
            table.insert(data.concept_stats[concept.name].custom_tags, tag)
            M.save_ownership_data(data)
            ui.info("🏷️ Tag ajouté !")
          end
        end)

      elseif opt_selected.action == "favorite" then
        local data = M.load_ownership_data()
        data.concept_stats[concept.name].favorite = not data.concept_stats[concept.name].favorite
        M.save_ownership_data(data)

        if data.concept_stats[concept.name].favorite then
          ui.info("⭐ Ajouté aux favoris !")
        else
          ui.info("Retiré des favoris")
        end

      elseif opt_selected.action == "card" then
        M.show_concept_card(selected.index)
      end
    end)
  end)
end

-- Afficher les favoris
function M.show_favorites()
  local concepts = storage.load_concepts()
  local data = M.load_ownership_data()

  local favorites = {}
  for _, concept in ipairs(concepts) do
    local stats = data.concept_stats[concept.name]
    if stats and stats.favorite then
      table.insert(favorites, concept.name)
    end
  end

  if #favorites == 0 then
    ui.info("Aucun favori. Marquez des concepts avec :LLearnCustomize")
    return
  end

  local display_text = "# ⭐ Vos Concepts Favoris\n\n"
  display_text = display_text .. "Vous avez " .. #favorites .. " concept(s) favori(s):\n\n"

  for i, name in ipairs(favorites) do
    display_text = display_text .. i .. ". ⭐ **" .. name .. "**\n"
  end

  ui.show_response(display_text, { title = " ⭐ Favoris " })
end

-- Débloquer des achievements de collection
function M.check_collection_achievements()
  local concepts = storage.load_concepts()
  local data = M.load_ownership_data()
  local prog_data = progression.load_progression_data()

  local achievements = {
    {
      id = "collector_100",
      name = "📚 Bibliothécaire",
      description = "Posséder 100 concepts",
      condition = #concepts >= 100,
    },
    {
      id = "collector_rare",
      name = "🔵 Chasseur de Raretés",
      description = "Posséder 10 concepts Rare ou plus",
      condition = function()
        local count = 0
        for _, concept in ipairs(concepts) do
          local rarity = M.calculate_rarity(concept.review_count or 0)
          if rarity == "rare" or rarity == "epic" or rarity == "legendary" then
            count = count + 1
          end
        end
        return count >= 10
      end,
    },
    {
      id = "collector_legendary",
      name = "🟡 Maître Collectionneur",
      description = "Posséder 5 concepts Legendary",
      condition = function()
        local count = 0
        for _, concept in ipairs(concepts) do
          if M.calculate_rarity(concept.review_count or 0) == "legendary" then
            count = count + 1
          end
        end
        return count >= 5
      end,
    },
    {
      id = "collection_complete",
      name = "✅ Collection Complète",
      description = "Compléter une collection avec target",
      condition = function()
        for _, collection in pairs(data.collections) do
          if collection.target and #collection.concepts >= collection.target then
            return true
          end
        end
        return false
      end,
    },
  }

  for _, achievement in ipairs(achievements) do
    -- Vérifier si déjà débloqué
    local already_unlocked = false
    for _, unlocked in ipairs(data.achievements) do
      if unlocked.id == achievement.id then
        already_unlocked = true
        break
      end
    end

    if not already_unlocked then
      local condition_met = type(achievement.condition) == "function" and achievement.condition() or achievement.condition

      if condition_met then
        table.insert(data.achievements, {
          id = achievement.id,
          name = achievement.name,
          unlocked_date = os.time(),
        })
        M.save_ownership_data(data)
        ui.info("🏆 Achievement débloqué : " .. achievement.name)
      end
    end
  end
end

return M
