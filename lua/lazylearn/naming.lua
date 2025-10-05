-- LazyLearn.nvim - Automatic Naming Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}

-- Mots à ignorer pour le nommage
local STOP_WORDS = {
  "le", "la", "les", "un", "une", "des", "de", "du", "et", "ou", "mais",
  "pour", "avec", "sans", "sur", "dans", "par", "est", "sont", "ce", "cette",
  "the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of",
  "is", "are", "was", "were", "be", "been", "being", "have", "has", "had",
  "this", "that", "these", "those", "it", "its", "can", "will", "would",
}

-- Patterns pour détecter les concepts importants dans le code
local CODE_PATTERNS = {
  -- Fonctions
  {pattern = "function%s+(%w+)", prefix = "function"},
  {pattern = "def%s+(%w+)", prefix = "function"},
  {pattern = "fn%s+(%w+)", prefix = "function"},
  {pattern = "func%s+(%w+)", prefix = "function"},

  -- Classes
  {pattern = "class%s+(%w+)", prefix = "class"},
  {pattern = "struct%s+(%w+)", prefix = "struct"},
  {pattern = "interface%s+(%w+)", prefix = "interface"},
  {pattern = "type%s+(%w+)", prefix = "type"},

  -- Variables importantes
  {pattern = "const%s+(%w+)", prefix = "const"},
  {pattern = "let%s+(%w+)", prefix = "var"},
  {pattern = "var%s+(%w+)", prefix = "var"},

  -- Méthodes
  {pattern = "%.(%w+)%s*=%s*function", prefix = "method"},
  {pattern = "%.(%w+)%s*%(", prefix = "method"},
}

-- Extraire les mots importants du texte
local function extract_important_words(text, max_words)
  max_words = max_words or 3

  local words = {}
  local word_scores = {}

  -- Extraire tous les mots alphanumériques
  for word in text:lower():gmatch("%w+") do
    if #word > 3 and not vim.tbl_contains(STOP_WORDS, word) then
      -- Scorer le mot selon certains critères
      local score = 1

      -- Bonus si le mot est en camelCase ou PascalCase dans l'original
      if text:match(word:sub(1,1):upper() .. word:sub(2)) then
        score = score + 2
      end

      -- Bonus si le mot apparaît plusieurs fois
      local count = 0
      for _ in text:lower():gmatch(word) do
        count = count + 1
      end
      score = score + count

      word_scores[word] = (word_scores[word] or 0) + score
    end
  end

  -- Trier par score
  local sorted_words = {}
  for word, score in pairs(word_scores) do
    table.insert(sorted_words, {word = word, score = score})
  end
  table.sort(sorted_words, function(a, b) return a.score > b.score end)

  -- Prendre les N meilleurs
  for i = 1, math.min(max_words, #sorted_words) do
    table.insert(words, sorted_words[i].word)
  end

  return words
end

-- Détecter le concept principal dans le code
local function detect_code_concept(code)
  for _, pattern_info in ipairs(CODE_PATTERNS) do
    local match = code:match(pattern_info.pattern)
    if match then
      return {
        name = match,
        type = pattern_info.prefix
      }
    end
  end
  return nil
end

-- Générer un nom automatique à partir du code et de la technique
function M.generate_name(text, technique_name, response)
  local parts = {}

  -- 1. Essayer de détecter un concept dans le code
  local concept = detect_code_concept(text)
  if concept then
    table.insert(parts, concept.name)
  else
    -- Sinon, extraire les mots importants du code
    local code_words = extract_important_words(text, 2)
    for _, word in ipairs(code_words) do
      table.insert(parts, word)
    end
  end

  -- 2. Si pas assez de mots du code, ajouter des mots de la réponse
  if #parts < 2 then
    local response_words = extract_important_words(response, 3 - #parts)
    for _, word in ipairs(response_words) do
      if not vim.tbl_contains(parts, word) then
        table.insert(parts, word)
      end
    end
  end

  -- 3. Si toujours vide, utiliser la technique
  if #parts == 0 then
    return technique_name:lower():gsub("%s+", "-") .. "-" .. os.date("%Y%m%d-%H%M")
  end

  -- Construire le nom final
  local name = table.concat(parts, "-"):lower()

  -- Nettoyer le nom
  name = name:gsub("[^%w%-]", "")
  name = name:gsub("%-+", "-")
  name = name:gsub("^%-", "")
  name = name:gsub("%-$", "")

  -- Limiter la longueur
  if #name > 50 then
    name = name:sub(1, 50):gsub("%-[^%-]*$", "")
  end

  return name
end

-- Générer un nom avec préfixe de technique
function M.generate_name_with_technique(text, technique_name, response)
  local base_name = M.generate_name(text, technique_name, response)

  -- Ajouter un préfixe court de la technique
  local technique_prefix = technique_name:lower():gsub("%s+", "-"):sub(1, 15)

  return technique_prefix .. "-" .. base_name
end

-- Générer un nom avec timestamp
function M.generate_name_with_date(text, technique_name, response)
  local base_name = M.generate_name(text, technique_name, response)
  local date = os.date("%Y%m%d")

  return base_name .. "-" .. date
end

-- Générer un nom simple et court
function M.generate_short_name(text, technique_name, response)
  local concept = detect_code_concept(text)

  if concept then
    return concept.name:lower()
  end

  local words = extract_important_words(text, 1)
  if #words > 0 then
    return words[1]
  end

  return "concept-" .. os.date("%H%M%S")
end

-- Générer plusieurs suggestions de noms
function M.generate_suggestions(text, technique_name, response)
  return {
    M.generate_name(text, technique_name, response),
    M.generate_name_with_technique(text, technique_name, response),
    M.generate_name_with_date(text, technique_name, response),
    M.generate_short_name(text, technique_name, response),
  }
end

-- Vérifier si un nom existe déjà et ajouter un suffixe si nécessaire
function M.ensure_unique_name(base_name, existing_names)
  if not vim.tbl_contains(existing_names, base_name) then
    return base_name
  end

  local counter = 1
  local unique_name = base_name .. "-" .. counter

  while vim.tbl_contains(existing_names, unique_name) do
    counter = counter + 1
    unique_name = base_name .. "-" .. counter
  end

  return unique_name
end

return M
