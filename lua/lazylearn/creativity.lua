-- LazyLearn.nvim - Creativity Module
-- Author: LazyLearn Contributors
-- License: MIT
-- Description: Système de créativité et feedback (Core Drive 3)

local M = {}
local config = require("lazylearn.config")
local ui = require("lazylearn.ui")
local api = require("lazylearn.api")
local storage = require("lazylearn.storage")

-- Charger les données de créativité
function M.load_creativity_data()
  local path = config.options.creativity.data_path

  if vim.fn.filereadable(path) ~= 1 then
    return {
      custom_prompts = {},
      templates = {},
      learning_styles = {},
      remixes = {},
      favorites = {},
    }
  end

  local content = vim.fn.readfile(path)
  if #content == 0 then
    return {
      custom_prompts = {},
      templates = {},
      learning_styles = {},
      remixes = {},
      favorites = {},
    }
  end

  local success, data = pcall(function()
    return vim.fn.json_decode(table.concat(content, "\n"))
  end)

  if not success then
    ui.error("Impossible de charger les données de créativité")
    return {
      custom_prompts = {},
      templates = {},
      learning_styles = {},
      remixes = {},
      favorites = {},
    }
  end

  return data
end

-- Sauvegarder les données de créativité
function M.save_creativity_data(data)
  local path = config.options.creativity.data_path

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

-- Templates de base pour faciliter la création
M.BASE_TEMPLATES = {
  {
    id = "simple_explanation",
    name = "Explication Simple",
    description = "Explique de manière claire et concise",
    prompt = "Explique ce code de manière simple et claire :\n\n{{code}}\n\nFocus sur :\n- Ce que fait le code\n- Pourquoi c'est utile\n- Des exemples concrets",
    variables = { "code" },
  },
  {
    id = "eli5",
    name = "Explique-moi comme si j'avais 5 ans",
    description = "Explication ultra-simple avec analogies",
    prompt = "Explique ce code comme si j'avais 5 ans, avec des analogies simples :\n\n{{code}}\n\nUtilise des comparaisons du quotidien.",
    variables = { "code" },
  },
  {
    id = "carmack_style",
    name = "Style John Carmack",
    description = "Approche pragmatique et orientée performance",
    prompt = "Analyse ce code avec l'approche de John Carmack (pragmatique, performance, simplicité) :\n\n{{code}}\n\nFocus sur :\n- Optimisations possibles\n- Simplicité du code\n- Performance runtime",
    variables = { "code" },
  },
  {
    id = "feynman_style",
    name = "Style Richard Feynman",
    description = "Décomposition depuis les premiers principes",
    prompt = "Explique ce code en utilisant la technique Feynman (premiers principes, étape par étape) :\n\n{{code}}\n\nCommence par les bases absolues et construis progressivement.",
    variables = { "code" },
  },
  {
    id = "visual_learner",
    name = "Apprenant Visuel",
    description = "Avec diagrammes ASCII et visualisations",
    prompt = "Explique ce code avec des diagrammes ASCII et visualisations :\n\n{{code}}\n\nUtilise :\n- Diagrammes de flux\n- Schémas ASCII\n- Visualisations de structures de données",
    variables = { "code" },
  },
  {
    id = "compare_contrast",
    name = "Comparaison & Contraste",
    description = "Compare avec des approches alternatives",
    prompt = "Analyse ce code et compare-le avec des approches alternatives :\n\n{{code}}\n\nMontre :\n- Cette approche\n- 2-3 alternatives\n- Avantages/inconvénients de chaque",
    variables = { "code" },
  },
}

-- Créer un nouveau prompt personnalisé
function M.create_custom_prompt()
  ui.input("Nom de votre technique d'apprentissage: ", function(name)
    if not name or name == "" then
      return
    end

    ui.input("Description courte: ", function(description)
      if not description or description == "" then
        description = "Technique personnalisée"
      end

      -- Ouvrir un buffer temporaire pour éditer le prompt
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "-- Écrivez votre prompt personnalisé ci-dessous",
        "-- Utilisez {{code}} pour insérer le code sélectionné",
        "-- Utilisez {{language}} pour le langage détecté",
        "",
        "Explique ce code :",
        "",
        "{{code}}",
        "",
        "Focus sur...",
      })

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        col = math.floor(vim.o.columns * 0.1),
        row = math.floor(vim.o.lines * 0.1),
        border = "rounded",
        title = " Créer un Prompt Personnalisé ",
        title_pos = "center",
      })

      vim.bo[buf].filetype = "markdown"

      -- Instructions
      ui.info("Éditez votre prompt. Sauvegardez avec :w puis fermez avec :q")

      -- Auto-commande pour sauvegarder
      vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        once = true,
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

          -- Retirer les lignes de commentaire
          local prompt_lines = {}
          for _, line in ipairs(lines) do
            if not line:match("^%s*%-%-") then
              table.insert(prompt_lines, line)
            end
          end

          local prompt = table.concat(prompt_lines, "\n")

          -- Sauvegarder
          local data = M.load_creativity_data()
          table.insert(data.custom_prompts, {
            id = "custom_" .. os.time(),
            name = name,
            description = description,
            prompt = prompt,
            created = os.time(),
            uses = 0,
          })

          M.save_creativity_data(data)
          ui.info("✨ Prompt personnalisé '" .. name .. "' créé !")

          vim.cmd("set nomodified")
        end,
      })

      -- Fermer la fenêtre après quit
      vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = buf,
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end,
      })
    end)
  end)
end

-- Tester un prompt avec feedback immédiat
function M.test_prompt(prompt_text, test_code)
  if not test_code or test_code == "" then
    -- Utiliser un code d'exemple
    test_code = [[
function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
]]
  end

  -- Remplacer les variables
  local final_prompt = prompt_text:gsub("{{code}}", test_code)
  local language = require("lazylearn.community").detect_language(test_code)
  final_prompt = final_prompt:gsub("{{language}}", language)

  -- Afficher un indicateur de chargement
  local loading_win = ui.show_loading("Test du prompt en cours...")

  -- Interroger l'API
  api.query(final_prompt, "", function(response, error)
    if loading_win then
      ui.close_window(loading_win)
    end

    if error then
      ui.error("Erreur: " .. error)
      return
    end

    -- Afficher le résultat avec le prompt utilisé
    local display_text = "# Test de Prompt\n\n"
    display_text = display_text .. "## Prompt utilisé\n\n```\n" .. final_prompt .. "\n```\n\n"
    display_text = display_text .. "## Résultat\n\n" .. response .. "\n\n"
    display_text = display_text .. "---\n\n"
    display_text = display_text .. "*Satisfait du résultat ? Sauvegardez ce prompt !*\n"

    ui.show_response(display_text, { title = " Test de Prompt " })
  end)
end

-- Remixer des concepts existants
function M.remix_concepts()
  local concepts = storage.load_concepts()

  if #concepts < 2 then
    ui.info("Vous avez besoin d'au moins 2 concepts pour faire un remix")
    return
  end

  -- Sélectionner le premier concept
  local items1 = {}
  for i, concept in ipairs(concepts) do
    table.insert(items1, {
      index = i,
      name = concept.name,
      icon = "📚",
    })
  end

  ui.select_prompt(items1, function(concept1)
    if not concept1 then
      return
    end

    -- Sélectionner le deuxième concept
    local items2 = {}
    for i, concept in ipairs(concepts) do
      if i ~= concept1.index then
        table.insert(items2, {
          index = i,
          name = concept.name,
          icon = "📚",
        })
      end
    end

    ui.select_prompt(items2, function(concept2)
      if not concept2 then
        return
      end

      -- Créer le prompt de remix
      local c1 = concepts[concept1.index]
      local c2 = concepts[concept2.index]

      local remix_prompt = "Je veux combiner ces deux concepts pour créer quelque chose de nouveau :\n\n"
      remix_prompt = remix_prompt .. "## Concept 1: " .. c1.name .. "\n\n```\n" .. c1.text .. "\n```\n\n"
      remix_prompt = remix_prompt .. "## Concept 2: " .. c2.name .. "\n\n```\n" .. c2.text .. "\n```\n\n"
      remix_prompt = remix_prompt .. "Génère:\n"
      remix_prompt = remix_prompt .. "1. Une version qui combine les deux approches\n"
      remix_prompt = remix_prompt .. "2. Des insights sur comment ils se complètent\n"
      remix_prompt = remix_prompt .. "3. Un exemple de code qui utilise les deux concepts ensemble\n"

      -- Interroger l'API
      local loading_win = ui.show_loading("Remix en cours...")

      api.query(remix_prompt, "", function(response, error)
        if loading_win then
          ui.close_window(loading_win)
        end

        if error then
          ui.error("Erreur: " .. error)
          return
        end

        -- Sauvegarder le remix
        local data = M.load_creativity_data()
        table.insert(data.remixes, {
          concept1 = c1.name,
          concept2 = c2.name,
          result = response,
          created = os.time(),
        })
        M.save_creativity_data(data)

        -- Afficher
        local display_text = "# 🎨 Remix Créatif\n\n"
        display_text = display_text .. "**" .. c1.name .. "** × **" .. c2.name .. "**\n\n"
        display_text = display_text .. "---\n\n"
        display_text = display_text .. response .. "\n"

        ui.show_response(display_text, { title = " Remix Créatif " })
      end)
    end)
  end)
end

-- Choisir un style d'apprentissage
function M.select_learning_style()
  local styles = {
    {
      id = "visual",
      name = "👁️  Visuel",
      description = "Diagrammes, schémas, visualisations",
      prompt_modifier = "\n\nUtilise des diagrammes ASCII et des visualisations pour expliquer.",
    },
    {
      id = "auditory",
      name = "👂 Auditif",
      description = "Explications verbales détaillées",
      prompt_modifier = "\n\nExplique de manière verbale détaillée, comme si tu racontais une histoire.",
    },
    {
      id = "kinesthetic",
      name = "✋ Kinesthésique",
      description = "Exemples pratiques, exercices",
      prompt_modifier = "\n\nDonne des exemples pratiques concrets et des exercices à essayer.",
    },
    {
      id = "logical",
      name = "🧠 Logique",
      description = "Analyse étape par étape",
      prompt_modifier = "\n\nAnalyse de manière logique et systématique, étape par étape.",
    },
    {
      id = "social",
      name = "👥 Social",
      description = "Contexte d'utilisation en équipe",
      prompt_modifier = "\n\nExplique dans un contexte de travail en équipe et de collaboration.",
    },
    {
      id = "solitary",
      name = "🧘 Solitaire",
      description = "Réflexion profonde et autonome",
      prompt_modifier = "\n\nEncourage la réflexion profonde et l'apprentissage autonome.",
    },
  }

  local items = {}
  for _, style in ipairs(styles) do
    table.insert(items, {
      id = style.id,
      name = style.name,
      icon = "",
      description = style.description,
      prompt_modifier = style.prompt_modifier,
    })
  end

  ui.select_prompt(items, function(style)
    if not style then
      return
    end

    -- Sauvegarder le style préféré
    local data = M.load_creativity_data()
    data.learning_styles.preferred = style.id
    data.learning_styles.modifier = style.prompt_modifier
    M.save_creativity_data(data)

    ui.info("✨ Style d'apprentissage défini: " .. style.name)
  end)
end

-- Appliquer le style d'apprentissage au prompt
function M.apply_learning_style(prompt)
  local data = M.load_creativity_data()
  if data.learning_styles.modifier then
    return prompt .. data.learning_styles.modifier
  end
  return prompt
end

-- Galerie de templates
function M.show_template_gallery()
  local data = M.load_creativity_data()

  local display_text = "# 🎨 Galerie de Templates\n\n"

  -- Templates de base
  display_text = display_text .. "## 📦 Templates Intégrés (" .. #M.BASE_TEMPLATES .. ")\n\n"
  for i, template in ipairs(M.BASE_TEMPLATES) do
    display_text = display_text .. i .. ". **" .. template.name .. "**\n"
    display_text = display_text .. "   - " .. template.description .. "\n\n"
  end

  -- Templates personnalisés
  if #data.custom_prompts > 0 then
    display_text = display_text .. "## ✨ Vos Templates Personnalisés (" .. #data.custom_prompts .. ")\n\n"
    for i, prompt in ipairs(data.custom_prompts) do
      display_text = display_text .. i .. ". **" .. prompt.name .. "**\n"
      display_text = display_text .. "   - " .. prompt.description .. "\n"
      display_text = display_text .. "   - Utilisé " .. (prompt.uses or 0) .. " fois\n\n"
    end
  end

  -- Remixes
  if #data.remixes > 0 then
    display_text = display_text .. "## 🎭 Vos Remixes (" .. #data.remixes .. ")\n\n"
    for i, remix in ipairs(data.remixes) do
      display_text = display_text .. i .. ". **" .. remix.concept1 .. "** × **" .. remix.concept2 .. "**\n"
      display_text = display_text .. "   - Créé le " .. os.date("%Y-%m-%d", remix.created) .. "\n\n"
    end
  end

  ui.show_response(display_text, { title = " Galerie de Templates " })
end

-- Utiliser un template de la galerie
function M.use_template()
  local data = M.load_creativity_data()
  local all_templates = {}

  -- Ajouter templates de base
  for _, template in ipairs(M.BASE_TEMPLATES) do
    table.insert(all_templates, {
      type = "base",
      name = template.name,
      icon = "📦",
      description = template.description,
      prompt = template.prompt,
    })
  end

  -- Ajouter templates personnalisés
  for _, prompt in ipairs(data.custom_prompts) do
    table.insert(all_templates, {
      type = "custom",
      name = prompt.name,
      icon = "✨",
      description = prompt.description,
      prompt = prompt.prompt,
      id = prompt.id,
    })
  end

  if #all_templates == 0 then
    ui.info("Aucun template disponible. Créez-en un avec :LLearnCreate")
    return
  end

  ui.select_prompt(all_templates, function(template)
    if not template then
      return
    end

    -- Demander le code à analyser
    ui.input("Code à analyser (ou laissez vide pour utiliser la sélection): ", function(code)
      if not code or code == "" then
        -- Utiliser la sélection visuelle
        code = ui.get_visual_selection()
        if not code or code == "" then
          ui.warn("Sélectionnez du code en mode visuel")
          return
        end
      end

      -- Appliquer le template
      local final_prompt = template.prompt:gsub("{{code}}", code)
      local language = require("lazylearn.community").detect_language(code)
      final_prompt = final_prompt:gsub("{{language}}", language)

      -- Appliquer le style d'apprentissage si configuré
      final_prompt = M.apply_learning_style(final_prompt)

      -- Interroger l'API
      local loading_win = ui.show_loading("Application du template...")

      api.query(final_prompt, "", function(response, error)
        if loading_win then
          ui.close_window(loading_win)
        end

        if error then
          ui.error("Erreur: " .. error)
          return
        end

        -- Incrémenter le compteur d'utilisation
        if template.type == "custom" then
          for i, prompt in ipairs(data.custom_prompts) do
            if prompt.id == template.id then
              data.custom_prompts[i].uses = (data.custom_prompts[i].uses or 0) + 1
              M.save_creativity_data(data)
              break
            end
          end
        end

        -- Afficher
        ui.show_response(response, { title = " " .. template.name .. " " })
      end)
    end)
  end)
end

-- Variation sur un concept existant
function M.create_variation()
  local concepts = storage.load_concepts()

  if #concepts == 0 then
    ui.info("Aucun concept sauvegardé")
    return
  end

  local items = {}
  for i, concept in ipairs(concepts) do
    table.insert(items, {
      index = i,
      name = concept.name,
      icon = "📚",
    })
  end

  ui.select_prompt(items, function(selected)
    if not selected then
      return
    end

    local concept = concepts[selected.index]

    -- Menu de variations
    local variations = {
      { name = "Simplifier encore plus", prompt = "Simplifie ce concept encore davantage:" },
      { name = "Approfondir", prompt = "Approfondis ce concept avec plus de détails:" },
      { name = "Comparer avec alternatives", prompt = "Compare ce concept avec des alternatives:" },
      { name = "Cas d'usage réels", prompt = "Donne des cas d'usage réels de ce concept:" },
      { name = "Pièges courants", prompt = "Quels sont les pièges courants avec ce concept:" },
      { name = "Version optimisée", prompt = "Donne une version optimisée de ce code:" },
    }

    local var_items = {}
    for i, var in ipairs(variations) do
      table.insert(var_items, {
        index = i,
        name = var.name,
        icon = "🎨",
      })
    end

    ui.select_prompt(var_items, function(var_selected)
      if not var_selected then
        return
      end

      local variation = variations[var_selected.index]
      local var_prompt = variation.prompt .. "\n\n```\n" .. concept.text .. "\n```\n"

      local loading_win = ui.show_loading("Création de la variation...")

      api.query(var_prompt, "", function(response, error)
        if loading_win then
          ui.close_window(loading_win)
        end

        if error then
          ui.error("Erreur: " .. error)
          return
        end

        local display_text = "# 🎨 Variation: " .. variation.name .. "\n\n"
        display_text = display_text .. "**Concept original:** " .. concept.name .. "\n\n"
        display_text = display_text .. "---\n\n"
        display_text = display_text .. response .. "\n"

        ui.show_response(display_text, { title = " Variation Créative " })
      end)
    end)
  end)
end

return M
