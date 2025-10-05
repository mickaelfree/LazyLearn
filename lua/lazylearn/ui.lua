-- LazyLearn.nvim - UI Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}
local api = vim.api
local config = require("lazylearn.config")

-- Cache pour stocker les buffers/fenêtres actifs
M.active_windows = {}

-- Obtenir la sélection visuelle
function M.get_visual_selection()
  -- Sauvegarde le registre original
  local a_orig = vim.fn.getreg("a")
  local mode_orig = vim.fn.getregtype("a")

  -- Copie la sélection dans le registre 'a'
  vim.cmd('noau normal! "ay')
  local text = vim.fn.getreg("a")

  -- Restaure le registre original
  vim.fn.setreg("a", a_orig, mode_orig)

  return text
end

-- Obtenir le buffer entier
function M.get_buffer_content()
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(lines, "\n")
end

-- Calculer les dimensions de la fenêtre flottante
local function calculate_window_size()
  local opts = config.options.ui
  local columns = vim.o.columns
  local lines = vim.o.lines

  local width = math.min(
    math.floor(columns * opts.width_ratio),
    opts.max_width
  )
  local height = math.min(
    math.floor(lines * opts.height_ratio),
    opts.max_height
  )

  return width, height
end

-- Calculer la position de la fenêtre
local function calculate_window_position(width, height)
  local opts = config.options.ui
  local columns = vim.o.columns
  local lines = vim.o.lines

  local row, col

  if opts.position == "center" then
    row = math.floor((lines - height) / 2)
    col = math.floor((columns - width) / 2)
  elseif opts.position == "top" then
    row = 1
    col = math.floor((columns - width) / 2)
  elseif opts.position == "bottom" then
    row = lines - height - 2
    col = math.floor((columns - width) / 2)
  elseif opts.position == "left" then
    row = math.floor((lines - height) / 2)
    col = 0
  elseif opts.position == "right" then
    row = math.floor((lines - height) / 2)
    col = columns - width
  else
    -- Par défaut: center
    row = math.floor((lines - height) / 2)
    col = math.floor((columns - width) / 2)
  end

  return row, col
end

-- Créer une fenêtre flottante
function M.create_float(content, opts)
  opts = opts or {}

  -- Créer un nouveau buffer
  local buf = api.nvim_create_buf(false, true)

  -- Préparer le contenu
  local lines = vim.split(content, "\n")
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Calculer les dimensions
  local width, height = calculate_window_size()
  local row, col = calculate_window_position(width, height)

  -- Options de la fenêtre
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = config.options.ui.border,
    title = opts.title or " LazyLearn ",
    title_pos = "center",
  }

  -- Créer la fenêtre
  local win = api.nvim_open_win(buf, true, win_opts)

  -- Configuration du buffer
  api.nvim_buf_set_option(buf, "modifiable", false)
  api.nvim_buf_set_option(buf, "buftype", "nofile")
  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "filetype", "markdown")
  api.nvim_buf_set_option(buf, "syntax", "markdown")

  -- Configuration de la fenêtre
  if config.options.ui.transparency > 0 then
    api.nvim_win_set_option(win, "winblend", config.options.ui.transparency)
  end

  -- Raccourcis pour fermer
  for _, key in ipairs(config.options.keymaps.close) do
    vim.keymap.set("n", key, function()
      M.close_window(win)
    end, { buffer = buf, silent = true })
  end

  -- Stocker la fenêtre active
  M.active_windows[win] = buf

  -- Auto-nettoyage quand la fenêtre se ferme
  api.nvim_create_autocmd({ "WinClosed", "BufWipeout" }, {
    buffer = buf,
    callback = function()
      M.active_windows[win] = nil
    end,
    once = true,
  })

  return win, buf
end

-- Fermer une fenêtre
function M.close_window(win)
  if win and api.nvim_win_is_valid(win) then
    api.nvim_win_close(win, true)
    M.active_windows[win] = nil
  end
end

-- Fermer toutes les fenêtres LazyLearn actives
function M.close_all_windows()
  for win, _ in pairs(M.active_windows) do
    M.close_window(win)
  end
end

-- Afficher une réponse dans une fenêtre flottante
function M.show_response(content, opts)
  opts = opts or {}
  return M.create_float(content, opts)
end

-- Afficher un message de chargement
function M.show_loading(message)
  message = message or "Réflexion en cours..."
  local content = string.format([[
# %s

```
  ╔════════════════════════════╗
  ║   ⏳ Traitement...         ║
  ║                            ║
  ║   Interrogation de l'IA    ║
  ║   Veuillez patienter       ║
  ╚════════════════════════════╝
```
]], message)

  return M.create_float(content, { title = " LazyLearn - Chargement " })
end

-- Mettre à jour le contenu d'une fenêtre existante
function M.update_window(win, content)
  local buf = M.active_windows[win]
  if not buf or not api.nvim_buf_is_valid(buf) then
    return false
  end

  -- Rendre le buffer modifiable temporairement
  api.nvim_buf_set_option(buf, "modifiable", true)

  -- Mettre à jour le contenu
  local lines = vim.split(content, "\n")
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Remettre en lecture seule
  api.nvim_buf_set_option(buf, "modifiable", false)

  return true
end

-- Menu de sélection pour les prompts
function M.select_prompt(prompts, on_select)
  local choices = {}

  for _, prompt_info in ipairs(prompts) do
    table.insert(choices, prompt_info)
  end

  vim.ui.select(choices, {
    prompt = "Quelle technique d'apprentissage voulez-vous utiliser?",
    format_item = function(item)
      return string.format("%s - %s", item.icon or "•", item.name)
    end,
  }, function(choice)
    if choice and on_select then
      on_select(choice)
    end
  end)
end

-- Demander un input à l'utilisateur
function M.input(prompt, on_submit, opts)
  opts = opts or {}
  vim.ui.input({
    prompt = prompt,
    default = opts.default or "",
  }, function(input)
    if input and on_submit then
      on_submit(input)
    end
  end)
end

-- Afficher une notification
function M.notify(message, level)
  level = level or vim.log.levels.INFO
  vim.notify(message, level, { title = "LazyLearn" })
end

-- Afficher une erreur
function M.error(message)
  M.notify(message, vim.log.levels.ERROR)
end

-- Afficher un avertissement
function M.warn(message)
  M.notify(message, vim.log.levels.WARN)
end

-- Afficher une info
function M.info(message)
  M.notify(message, vim.log.levels.INFO)
end

return M
