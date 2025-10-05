# 🚀 Quick Start - LazyLearn.nvim

Guide rapide pour tester le plugin comme un utilisateur.

## Étape 1 : Publier sur GitHub

```bash
cd /home/evilryu117/Music/LazyLearn.nvim

# Créer le premier commit
git add .
git commit -m "🎉 Initial release - LazyLearn.nvim v1.0.0"

# Ajouter le remote GitHub
git remote add origin https://github.com/mickaelfree/LazyLearn.nvim.git

# Pousser sur GitHub
git branch -M main
git push -u origin main
```

## Étape 2 : Créer le dépôt sur GitHub

1. Allez sur https://github.com/new
2. **Repository name** : `LazyLearn.nvim`
3. **Description** : `🧠 Un plugin Neovim pour apprendre à coder avec l'IA`
4. **Public** ✅
5. **Ne pas** initialiser avec README, .gitignore ou LICENSE
6. Cliquez sur **Create repository**

## Étape 3 : Configurer votre clé API Groq

```bash
# Obtenir une clé gratuite sur https://console.groq.com
export GROQ_API_KEY="votre_clé_ici"

# Ajouter à votre shell pour permanence
echo 'export GROQ_API_KEY="votre_clé_ici"' >> ~/.bashrc
source ~/.bashrc
```

## Étape 4 : Installer le plugin dans Neovim

### Avec lazy.nvim (recommandé)

Créez le fichier `~/.config/nvim/lua/plugins/lazylearn.lua` :

```lua
return {
  "mickaelfree/LazyLearn.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("lazylearn.init").setup({
      provider = "groq", -- Gratuit et rapide!
    })
  end,
}
```

### Redémarrez Neovim

```bash
nvim
```

lazy.nvim installera automatiquement le plugin.

## Étape 5 : Tester le plugin

### Test 1 : Vérifier l'installation

```vim
:LLearnTest
```

Vous devriez voir : `"Connexion réussie à groq"`

### Test 2 : Analyser du code

1. Créez un fichier de test :
   ```bash
   nvim test.js
   ```

2. Tapez du code :
   ```javascript
   function fibonacci(n) {
       if (n <= 1) return n;
       return fibonacci(n - 1) + fibonacci(n - 2);
   }
   ```

3. Sélectionnez tout le code :
   - Appuyez sur `ggVG` (tout sélectionner)
   - Ou `V` pour sélectionner ligne par ligne

4. Appuyez sur `<leader>h` (par défaut `\h`)

5. Choisissez une technique :
   - Par exemple : "🎯 Principes Fondamentaux"

6. Lisez l'explication dans la fenêtre flottante !

### Test 3 : Sauvegarder un concept

1. Après avoir reçu une explication, le plugin demande :
   ```
   Sauvegarder ce concept? (nom ou vide pour ignorer):
   ```

2. Tapez un nom : `fibonacci-recursion`

3. Le concept est sauvegardé !

### Test 4 : Voir vos concepts

```vim
:LLearnConcepts
```

ou en mode normal : `<leader>sc`

### Test 5 : Réviser

```vim
:LLearnReview
```

ou en mode normal : `<leader>sr`

Évaluez avec 1-5 selon la difficulté.

## 🎯 Workflow typique

```
1. Ouvrir un fichier de code
2. Sélectionner du code (mode visuel)
3. <leader>h
4. Choisir une technique
5. Lire et comprendre
6. Sauvegarder le concept
7. Réviser plus tard avec :LLearnReview
```

## 🔧 Personnalisation

### Changer de provider

```vim
:LLearnProvider
```

Sélectionnez : `ollama` pour local, `openai` pour GPT-4, etc.

### Changer les raccourcis

```lua
require("lazylearn.init").setup({
  keymaps = {
    trigger = "<leader>ll",      -- Au lieu de <leader>h
    show_concepts = "<leader>lc",
    review_concepts = "<leader>lr",
  },
})
```

### Personnaliser l'UI

```lua
require("lazylearn.init").setup({
  ui = {
    border = "double",
    width_ratio = 0.9,
    height_ratio = 0.9,
  },
})
```

## 📊 Commandes disponibles

| Commande | Description |
|----------|-------------|
| `:LLearn` | Analyser code sélectionné |
| `:LLearnConcepts` | Voir concepts sauvegardés |
| `:LLearnReview` | Réviser concepts dus |
| `:LLearnStats` | Statistiques |
| `:LLearnProvider` | Changer de provider |
| `:LLearnTest` | Tester connexion |

## ❓ Dépannage

### Le plugin ne se charge pas

```vim
:Lazy
```

Vérifiez les erreurs dans lazy.nvim.

### Erreur "GROQ_API_KEY manquante"

```bash
# Vérifier la variable
echo $GROQ_API_KEY

# Si vide, l'exporter
export GROQ_API_KEY="votre_clé"
```

### Erreur "plenary.nvim requis"

Le plugin s'installe avec lazy.nvim normalement. Sinon :

```lua
{
  "nvim-lua/plenary.nvim",
  lazy = false,
}
```

## 🎉 Félicitations !

Vous utilisez maintenant LazyLearn.nvim !

**Prochaines étapes** :
- Essayez toutes les 42 techniques
- Créez vos propres packs communautaires
- Partagez vos retours sur GitHub Issues
- Contribuez au projet !

---

**Repo** : https://github.com/mickaelfree/LazyLearn.nvim
**Support** : Ouvrez une issue sur GitHub
