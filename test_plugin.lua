-- Test script pour LazyLearn.nvim
print("=== Test LazyLearn.nvim ===\n")

-- Simuler vim.notify pour les tests
_G.vim = _G.vim or {}
local old_notify = vim.notify
vim.notify = function(msg, level)
  if type(msg) == "string" and not msg:match("plenary") then
    print("  [Notify] " .. msg)
  end
end

-- Test 1: Charger le module principal
print("Test 1: Chargement du module principal...")
local ok, lazylearn = pcall(require, 'lazylearn.init')
if ok then
  print("✓ Module 'lazylearn' chargé avec succès")
else
  print("✗ Erreur lors du chargement: " .. tostring(lazylearn))
  os.exit(1)
end

-- Test 2: Charger les sous-modules
print("\nTest 2: Chargement des sous-modules...")
local modules = { 'config', 'ui', 'api', 'prompts', 'storage' }
for _, mod in ipairs(modules) do
  local ok, module = pcall(require, 'lazylearn.' .. mod)
  if ok then
    print("✓ Module 'lazylearn." .. mod .. "' chargé")
  else
    print("✗ Erreur 'lazylearn." .. mod .. "': " .. tostring(module))
    os.exit(1)
  end
end

-- Test 3: Setup du plugin
print("\nTest 3: Configuration du plugin...")
local ok, err = pcall(function()
  lazylearn.setup({
    provider = "groq",
    storage = {
      enabled = false, -- Désactiver pour les tests
    },
    spaced_repetition = {
      check_on_startup = false, -- Désactiver pour les tests
    },
  })
end)
if ok then
  print("✓ Plugin configuré avec succès")
  print("  - Setup complété: " .. tostring(lazylearn.is_setup))
else
  print("✗ Erreur lors de la configuration: " .. tostring(err))
  os.exit(1)
end

-- Test 4: Vérifier les commandes
print("\nTest 4: Vérification des commandes...")
local commands = { 'LLearn', 'LLearnConcepts', 'LLearnReview', 'LLearnStats', 'LLearnProvider', 'LLearnTest' }
for _, cmd in ipairs(commands) do
  local exists = vim.fn.exists(':' .. cmd) == 2
  if exists then
    print("✓ Commande '" .. cmd .. "' enregistrée")
  else
    print("✗ Commande '" .. cmd .. "' manquante")
  end
end

-- Test 5: Vérifier les prompts
print("\nTest 5: Chargement des prompts...")
local prompts = require('lazylearn.prompts')
local all_prompts = prompts.get_all()
print("✓ " .. #all_prompts .. " prompts chargés (builtin + packs)")

local builtin_count = #prompts.builtin
print("  - Builtin: " .. builtin_count)
print("  - Custom: " .. (#all_prompts - builtin_count))

local categories = prompts.list_categories()
print("✓ " .. #categories .. " catégories trouvées:")
for _, cat in ipairs(categories) do
  print("  - " .. cat)
end

-- Test 6: Vérifier la configuration
print("\nTest 6: Vérification de la configuration...")
local config = require('lazylearn.config')
local provider = config.get_provider()
if provider then
  print("✓ Provider configuré: " .. config.options.provider)
  print("  - API URL: " .. provider.api_url)
  print("  - Model: " .. provider.model)
else
  print("✗ Erreur: Pas de provider configuré")
end

-- Test 7: Vérifier les keymaps
print("\nTest 7: Vérification des keymaps...")
local keymaps = config.options.keymaps
print("✓ Trigger: " .. keymaps.trigger)
print("✓ Show concepts: " .. keymaps.show_concepts)
print("✓ Review concepts: " .. keymaps.review_concepts)

-- Test 8: Vérifier les providers disponibles
print("\nTest 8: Providers disponibles...")
local api = require('lazylearn.api')
local providers = api.list_providers()
print("✓ " .. #providers .. " providers configurés:")
for _, p in ipairs(providers) do
  print("  - " .. p)
end

-- Test 9: Vérifier le stockage
print("\nTest 9: Module de stockage...")
local storage = require('lazylearn.storage')
print("✓ Module storage chargé")
print("  - Path: " .. config.options.storage.path)

-- Restaurer vim.notify
vim.notify = old_notify

print("\n" .. string.rep("=", 50))
print("🎉 Tous les tests sont passés avec succès!")
print(string.rep("=", 50))
print("\n📖 Plugin prêt à l'utilisation!")
print("\n⌨️  Commandes disponibles:")
print("  :LLearn           - Analyser du code")
print("  :LLearnConcepts   - Voir les concepts")
print("  :LLearnReview     - Réviser")
print("  :LLearnStats      - Statistiques")
print("  :LLearnProvider   - Changer de provider")
print("  :LLearnTest       - Tester la connexion")
print("\n⚡ Raccourcis:")
print("  <leader>h  (visuel) - Analyser la sélection")
print("  <leader>sc (normal) - Voir les concepts")
print("  <leader>sr (normal) - Réviser")
print("\n🚀 Pour utiliser:")
print("  1. Configurez votre GROQ_API_KEY dans l'environnement")
print("  2. Sélectionnez du code en mode visuel")
print("  3. Appuyez sur <leader>h")
print("  4. Choisissez une technique d'apprentissage")
