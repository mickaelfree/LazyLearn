# 🚀 Installation de LazyLearn.nvim

## Installation rapide avec lazy.nvim

### 1. Ajouter le plugin à votre configuration

Éditez votre fichier de configuration Neovim (`~/.config/nvim/lua/plugins/lazylearn.lua` ou équivalent) :

```lua
return {
  "votre-nom/LazyLearn.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("lazylearn.init").setup({
      -- Configuration par défaut
      provider = "groq", -- "openai", "ollama", "lmstudio", "custom"
    })
  end,
}
```

### 2. Configurer la clé API

Ajoutez votre clé API dans votre fichier shell (`~/.bashrc`, `~/.zshrc`, etc.) :

```bash
# Pour Groq (gratuit et rapide)
export GROQ_API_KEY="votre_clé_api_ici"

# Ou pour OpenAI
export OPENAI_API_KEY="votre_clé_api_ici"
```

**Obtenir une clé API Groq :**
1. Allez sur https://console.groq.com
2. Créez un compte (gratuit)
3. Générez une clé API
4. Copiez-la dans votre configuration shell

### 3. Redémarrer Neovim

```bash
nvim
```

Le plugin se chargera automatiquement avec lazy.nvim.

### 4. Tester le plugin

```vim
:LLearnTest
```

Cette commande teste la connexion à votre provider IA.

## Installation locale pour développement/test

Si vous voulez tester le plugin localement avant de le publier :

### 1. Cloner/Copier le plugin

```bash
# Option 1: Copier dans votre config Neovim
cp -r LazyLearn.nvim ~/.config/nvim/lua/

# Option 2: Créer un lien symbolique
ln -s /chemin/vers/LazyLearn.nvim ~/.local/share/nvim/site/pack/plugins/start/LazyLearn.nvim
```

### 2. Configuration pour lazy.nvim avec chemin local

```lua
return {
  dir = "~/.config/nvim/lua/LazyLearn.nvim", -- ou votre chemin
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("lazylearn.init").setup()
  end,
}
```

### 3. Lancer les tests

```bash
cd LazyLearn.nvim
nvim --headless -u NONE -c "set rtp+=." -c "luafile test_plugin.lua" -c "qa"
```

## Utilisation

### Première utilisation

1. Ouvrez un fichier de code :
   ```bash
   nvim example.js
   ```

2. Sélectionnez du code en mode visuel :
   ```
   V  (mode ligne)
   ou
   v  (mode caractère)
   ```

3. Appuyez sur `<leader>h` (par défaut `\h`)

4. Choisissez une technique d'apprentissage dans le menu

5. Lisez l'explication dans la fenêtre flottante

### Commandes disponibles

| Commande | Description |
|----------|-------------|
| `:LLearn` | Analyser le code sélectionné |
| `:LLearnConcepts` | Afficher les concepts sauvegardés |
| `:LLearnReview` | Réviser les concepts dus |
| `:LLearnStats` | Afficher les statistiques |
| `:LLearnProvider` | Changer de provider IA |
| `:LLearnTest` | Tester la connexion |

### Raccourcis clavier

| Mode | Raccourci | Action |
|------|-----------|--------|
| Visuel | `<leader>h` | Analyser la sélection |
| Normal | `<leader>sc` | Voir les concepts |
| Normal | `<leader>sr` | Réviser |
| Float | `q` ou `Esc` | Fermer |

## Configuration avancée

### Personnaliser le provider

```lua
require("lazylearn.init").setup({
  provider = "ollama",

  providers = {
    ollama = {
      api_url = "http://localhost:11434/api/chat",
      model = "codellama",
    },
  },
})
```

### Personnaliser l'UI

```lua
require("lazylearn.init").setup({
  ui = {
    border = "rounded",      -- "single", "double", "rounded", "solid"
    width_ratio = 0.9,       -- 90% de la largeur
    height_ratio = 0.9,      -- 90% de la hauteur
    max_width = 150,
    max_height = 50,
    position = "center",     -- "center", "top", "bottom"
  },
})
```

### Personnaliser les raccourcis

```lua
require("lazylearn.init").setup({
  keymaps = {
    trigger = "<leader>ll",      -- Au lieu de <leader>h
    show_concepts = "<leader>lc",
    review_concepts = "<leader>lr",
  },
})
```

### Désactiver la sauvegarde

```lua
require("lazylearn.init").setup({
  storage = {
    enabled = false, -- Pas de sauvegarde de concepts
  },
})
```

## Résolution de problèmes

### "plenary.nvim est requis"

Installez plenary.nvim :

```lua
-- Avec lazy.nvim
{
  "nvim-lua/plenary.nvim",
  lazy = false,
}
```

### "Variable d'environnement GROQ_API_KEY non définie"

Vérifiez que votre clé API est bien exportée :

```bash
echo $GROQ_API_KEY
```

Si vide, ajoutez-la à votre `~/.bashrc` ou `~/.zshrc` et rechargez :

```bash
source ~/.bashrc
```

### "Erreur API Groq (401)"

Votre clé API est invalide ou expirée. Générez-en une nouvelle sur https://console.groq.com

### Le plugin ne se charge pas

Vérifiez les logs de lazy.nvim :

```vim
:Lazy
```

Cherchez les erreurs dans la section LazyLearn.nvim

### Les commandes ne sont pas disponibles

Le setup n'a pas été appelé. Vérifiez votre configuration :

```lua
-- ❌ Incorrect
require("lazylearn")

-- ✅ Correct
require("lazylearn.init").setup()
```

## Support et Contribution

- 🐛 Bugs : Ouvrez une issue sur GitHub
- 💡 Suggestions : Proposez une fonctionnalité
- 🤝 Contribuer : Forkez et créez une PR
- 📖 Documentation : Voir README.md

## Mise à jour

Avec lazy.nvim, mettez à jour le plugin :

```vim
:Lazy update LazyLearn.nvim
```

Ou mettez à jour tous les plugins :

```vim
:Lazy update
```
