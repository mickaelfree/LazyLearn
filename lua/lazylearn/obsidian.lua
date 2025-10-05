-- LazyLearn.nvim - Obsidian Integration Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")

-- Générer un slug pour le nom de fichier
local function slugify(text)
  text = text:lower()
  text = text:gsub("[àáâãäå]", "a")
  text = text:gsub("[èéêë]", "e")
  text = text:gsub("[ìíîï]", "i")
  text = text:gsub("[òóôõö]", "o")
  text = text:gsub("[ùúûü]", "u")
  text = text:gsub("[ýÿ]", "y")
  text = text:gsub("[ç]", "c")
  text = text:gsub("[^%w%s%-]", "")
  text = text:gsub("%s+", "-")
  text = text:gsub("%-+", "-")
  text = text:gsub("^%-", "")
  text = text:gsub("%-$", "")
  return text
end

-- Extraire les mots-clés importants du texte
local function extract_keywords(text, max_keywords)
  max_keywords = max_keywords or 5

  -- Mots à ignorer
  local stop_words = {
    "le", "la", "les", "un", "une", "des", "de", "du", "et", "ou", "mais",
    "pour", "avec", "sans", "sur", "dans", "par", "est", "sont", "ce", "cette",
    "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of",
    "is", "are", "was", "were", "be", "been", "being", "have", "has", "had",
  }

  local words = {}
  for word in text:lower():gmatch("%w+") do
    if #word > 3 and not vim.tbl_contains(stop_words, word) then
      words[word] = (words[word] or 0) + 1
    end
  end

  -- Trier par fréquence
  local sorted = {}
  for word, count in pairs(words) do
    table.insert(sorted, {word = word, count = count})
  end
  table.sort(sorted, function(a, b) return a.count > b.count end)

  -- Retourner les N premiers
  local keywords = {}
  for i = 1, math.min(max_keywords, #sorted) do
    table.insert(keywords, sorted[i].word)
  end

  return keywords
end

-- Détecter le langage de programmation
local function detect_language(text)
  local patterns = {
    {lang = "javascript", patterns = {"function%s", "const%s", "let%s", "var%s", "=>", "async"}},
    {lang = "python", patterns = {"def%s", "import%s", "class%s", "print%(", "self%."}},
    {lang = "lua", patterns = {"local%s", "function%s", "end%s", "require%(", "%.%."}},
    {lang = "rust", patterns = {"fn%s", "let%s", "mut%s", "impl%s", "struct%s"}},
    {lang = "go", patterns = {"func%s", "package%s", "import%s", "type%s", "struct%s"}},
    {lang = "c", patterns = {"#include", "int%s", "void%s", "struct%s", "printf%("}},
    {lang = "cpp", patterns = {"#include", "std::", "class%s", "namespace%s", "template%s"}},
    {lang = "java", patterns = {"public%s", "private%s", "class%s", "void%s", "System%."}},
    {lang = "typescript", patterns = {"interface%s", "type%s", "const%s", "async%s", "export%s"}},
    {lang = "bash", patterns = {"#!/bin/", "echo%s", "if%s%[", "function%s", "export%s"}},
  }

  for _, item in ipairs(patterns) do
    local matches = 0
    for _, pattern in ipairs(item.patterns) do
      if text:match(pattern) then
        matches = matches + 1
      end
    end
    if matches >= 2 then
      return item.lang
    end
  end

  return "code"
end

-- Générer les frontmatter (métadonnées YAML)
local function generate_frontmatter(concept_data)
  local lines = {"---"}

  -- Métadonnées de base
  table.insert(lines, "title: " .. concept_data.name)
  table.insert(lines, "created: " .. os.date("%Y-%m-%d %H:%M:%S"))
  table.insert(lines, "updated: " .. os.date("%Y-%m-%d %H:%M:%S"))

  -- Tags
  local tags = {"lazylearn"}

  -- Ajouter le langage comme tag
  if concept_data.language then
    table.insert(tags, concept_data.language)
  end

  -- Ajouter la technique comme tag
  if concept_data.technique then
    local technique_tag = concept_data.technique:lower():gsub("%s+", "-")
    table.insert(tags, technique_tag)
  end

  -- Ajouter les mots-clés comme tags
  if concept_data.keywords then
    for _, keyword in ipairs(concept_data.keywords) do
      table.insert(tags, keyword)
    end
  end

  table.insert(lines, "tags:")
  for _, tag in ipairs(tags) do
    table.insert(lines, "  - " .. tag)
  end

  -- Métadonnées de révision
  if concept_data.review_count then
    table.insert(lines, "review_count: " .. concept_data.review_count)
  end

  if concept_data.next_review then
    table.insert(lines, "next_review: " .. os.date("%Y-%m-%d", concept_data.next_review))
  end

  if concept_data.difficulty then
    table.insert(lines, "difficulty: " .. concept_data.difficulty)
  end

  -- Technique d'apprentissage
  if concept_data.technique then
    table.insert(lines, "technique: " .. concept_data.technique)
  end

  table.insert(lines, "---")
  table.insert(lines, "")

  return table.concat(lines, "\n")
end

-- Générer le contenu Markdown
local function generate_markdown(concept_data)
  local lines = {}

  -- Titre principal
  table.insert(lines, "# " .. concept_data.name)
  table.insert(lines, "")

  -- Résumé rapide (si disponible)
  if concept_data.summary then
    table.insert(lines, "> " .. concept_data.summary)
    table.insert(lines, "")
  end

  -- Section: Code Original
  table.insert(lines, "## 📝 Code Original")
  table.insert(lines, "")
  table.insert(lines, "```" .. (concept_data.language or ""))
  table.insert(lines, concept_data.text)
  table.insert(lines, "```")
  table.insert(lines, "")

  -- Section: Explication
  table.insert(lines, "## 🧠 Explication")
  table.insert(lines, "")
  table.insert(lines, concept_data.response)
  table.insert(lines, "")

  -- Section: Concepts Liés (liens Obsidian)
  if concept_data.related_concepts and #concept_data.related_concepts > 0 then
    table.insert(lines, "## 🔗 Concepts Liés")
    table.insert(lines, "")
    for _, related in ipairs(concept_data.related_concepts) do
      table.insert(lines, "- [[" .. related .. "]]")
    end
    table.insert(lines, "")
  end

  -- Section: Mots-clés
  if concept_data.keywords and #concept_data.keywords > 0 then
    table.insert(lines, "## 🏷️ Mots-clés")
    table.insert(lines, "")
    for _, keyword in ipairs(concept_data.keywords) do
      table.insert(lines, "- #" .. keyword)
    end
    table.insert(lines, "")
  end

  -- Section: Métadonnées de Révision
  if concept_data.next_review then
    table.insert(lines, "## 📅 Révision")
    table.insert(lines, "")
    table.insert(lines, "- **Prochaine révision**: " .. os.date("%Y-%m-%d", concept_data.next_review))
    if concept_data.review_count then
      table.insert(lines, "- **Nombre de révisions**: " .. concept_data.review_count)
    end
    if concept_data.difficulty then
      local difficulty_labels = {"Très difficile", "Difficile", "Moyen", "Facile", "Très facile"}
      table.insert(lines, "- **Dernière difficulté**: " .. difficulty_labels[concept_data.difficulty])
    end
    table.insert(lines, "")
  end

  -- Section: Technique d'Apprentissage
  if concept_data.technique then
    table.insert(lines, "## 🎯 Technique Utilisée")
    table.insert(lines, "")
    table.insert(lines, "**" .. concept_data.technique .. "**")
    table.insert(lines, "")
  end

  -- Footer avec timestamp
  table.insert(lines, "---")
  table.insert(lines, "")
  table.insert(lines, "*Créé avec [LazyLearn.nvim](https://github.com/mickaelfree/LazyLearn) le " ..
    os.date("%d/%m/%Y à %H:%M") .. "*")

  return table.concat(lines, "\n")
end

-- Sauvegarder un concept en format Obsidian
function M.save_concept(name, text, response, technique_name)
  local obsidian_config = config.options.obsidian

  if not obsidian_config.enabled then
    ui.error("Obsidian integration désactivée")
    return false
  end

  -- Créer le répertoire vault si nécessaire
  local vault_path = vim.fn.expand(obsidian_config.vault_path)
  local concepts_dir = vault_path .. "/" .. obsidian_config.concepts_folder

  if vim.fn.isdirectory(concepts_dir) == 0 then
    vim.fn.mkdir(concepts_dir, "p")
  end

  -- Détecter le langage et extraire les mots-clés
  local language = detect_language(text)
  local keywords = extract_keywords(text .. " " .. response, 5)

  -- Préparer les données du concept
  local concept_data = {
    name = name,
    text = text,
    response = response,
    language = language,
    keywords = keywords,
    technique = technique_name,
    review_count = 0,
    next_review = os.time() + (24 * 60 * 60), -- 1 jour
    related_concepts = {}, -- À remplir plus tard avec analyse
  }

  -- Générer le nom de fichier
  local filename = slugify(name) .. ".md"
  local filepath = concepts_dir .. "/" .. filename

  -- Vérifier si le fichier existe déjà
  if vim.fn.filereadable(filepath) == 1 then
    -- Mettre à jour le timestamp
    concept_data.updated = os.date("%Y-%m-%d %H:%M:%S")
  end

  -- Générer le contenu complet
  local frontmatter = generate_frontmatter(concept_data)
  local markdown = generate_markdown(concept_data)
  local full_content = frontmatter .. markdown

  -- Sauvegarder le fichier
  local file = io.open(filepath, "w")
  if file then
    file:write(full_content)
    file:close()
    ui.info("Concept sauvegardé dans Obsidian: " .. filename)

    -- Ouvrir dans Obsidian si configuré
    if obsidian_config.open_after_save then
      M.open_in_obsidian(filepath)
    end

    return true, filepath
  else
    ui.error("Impossible de sauvegarder le concept")
    return false
  end
end

-- Ouvrir un fichier dans Obsidian
function M.open_in_obsidian(filepath)
  -- Construire l'URL obsidian://
  local vault_name = config.options.obsidian.vault_name
  local relative_path = filepath:match(".*/(.+%.md)$")

  if vault_name and relative_path then
    local url = string.format("obsidian://open?vault=%s&file=%s",
      vim.fn.shellescape(vault_name),
      vim.fn.shellescape(relative_path))

    -- Ouvrir l'URL selon l'OS
    local open_cmd
    if vim.fn.has("mac") == 1 then
      open_cmd = "open"
    elseif vim.fn.has("unix") == 1 then
      open_cmd = "xdg-open"
    elseif vim.fn.has("win32") == 1 then
      open_cmd = "start"
    end

    if open_cmd then
      vim.fn.system(open_cmd .. " " .. url)
    end
  end
end

-- Lister tous les concepts Obsidian
function M.list_concepts()
  local obsidian_config = config.options.obsidian
  local concepts_dir = vim.fn.expand(obsidian_config.vault_path .. "/" .. obsidian_config.concepts_folder)

  if vim.fn.isdirectory(concepts_dir) == 0 then
    return {}
  end

  local files = vim.fn.glob(concepts_dir .. "/*.md", false, true)
  local concepts = {}

  for _, file in ipairs(files) do
    local name = file:match("([^/]+)%.md$")
    table.insert(concepts, {
      name = name,
      path = file,
    })
  end

  return concepts
end

-- Rechercher des concepts par tag
function M.search_by_tag(tag)
  local concepts = M.list_concepts()
  local results = {}

  for _, concept in ipairs(concepts) do
    local content = table.concat(vim.fn.readfile(concept.path), "\n")
    if content:match("- " .. tag) or content:match("#" .. tag) then
      table.insert(results, concept)
    end
  end

  return results
end

-- Créer un index des concepts (MOC - Map of Content)
function M.create_index()
  local obsidian_config = config.options.obsidian
  local vault_path = vim.fn.expand(obsidian_config.vault_path)
  local index_path = vault_path .. "/LazyLearn Index.md"

  local concepts = M.list_concepts()

  -- Grouper par tags/langages
  local by_language = {}
  local by_technique = {}

  for _, concept in ipairs(concepts) do
    local content = table.concat(vim.fn.readfile(concept.path), "\n")

    -- Extraire le langage
    local lang = content:match("tags:%s*- ([%w]+)")
    if lang then
      by_language[lang] = by_language[lang] or {}
      table.insert(by_language[lang], concept)
    end

    -- Extraire la technique
    local tech = content:match("technique: ([^\n]+)")
    if tech then
      by_technique[tech] = by_technique[tech] or {}
      table.insert(by_technique[tech], concept)
    end
  end

  -- Générer l'index
  local lines = {
    "---",
    "title: LazyLearn - Index des Concepts",
    "created: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "tags:",
    "  - moc",
    "  - lazylearn",
    "  - index",
    "---",
    "",
    "# 📚 LazyLearn - Index des Concepts",
    "",
    "> Index automatique de tous les concepts appris avec LazyLearn.nvim",
    "",
  }

  -- Par langage
  table.insert(lines, "## 💻 Par Langage")
  table.insert(lines, "")
  for lang, concepts_list in pairs(by_language) do
    table.insert(lines, "### " .. lang:upper())
    table.insert(lines, "")
    for _, concept in ipairs(concepts_list) do
      table.insert(lines, "- [[" .. concept.name .. "]]")
    end
    table.insert(lines, "")
  end

  -- Par technique
  table.insert(lines, "## 🎯 Par Technique d'Apprentissage")
  table.insert(lines, "")
  for tech, concepts_list in pairs(by_technique) do
    table.insert(lines, "### " .. tech)
    table.insert(lines, "")
    for _, concept in ipairs(concepts_list) do
      table.insert(lines, "- [[" .. concept.name .. "]]")
    end
    table.insert(lines, "")
  end

  -- Stats
  table.insert(lines, "## 📊 Statistiques")
  table.insert(lines, "")
  table.insert(lines, "- **Total de concepts**: " .. #concepts)
  table.insert(lines, "- **Langages**: " .. vim.tbl_count(by_language))
  table.insert(lines, "- **Techniques**: " .. vim.tbl_count(by_technique))
  table.insert(lines, "")

  -- Footer
  table.insert(lines, "---")
  table.insert(lines, "")
  table.insert(lines, "*Généré automatiquement par [LazyLearn.nvim](https://github.com/mickaelfree/LazyLearn)*")

  -- Sauvegarder
  local file = io.open(index_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
    ui.info("Index créé: LazyLearn Index.md")
    return true, index_path
  end

  return false
end

return M
