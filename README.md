# 🧠 LazyLearn.nvim

Un plugin Neovim open-source qui permet d'apprendre à coder directement dans Neovim grâce à une IA.

## ✨ Fonctionnalités

- 🎯 **Apprentissage interactif** : Sélectionnez du code et obtenez des explications instantanées
- 🤖 **Multi-providers IA** : Support de Groq, OpenAI, Ollama, LM Studio et APIs personnalisées
- 🧩 **40+ techniques d'apprentissage** : Méthodes mnémoniques, modèles mentaux, analyses de principes
- 💾 **Système de révision espacée** : Sauvegardez et révisez vos concepts selon la méthode SRS
- 🎨 **Interface moderne** : Fenêtres flottantes élégantes avec support Markdown
- 📦 **Extensible** : Créez et partagez vos propres packs de prompts communautaires
- ⚡ **Léger et rapide** : Architecture modulaire optimisée

## 📦 Installation

### Avec [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "mickaelfree/LazyLearn",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("lazylearn").setup({
      -- Configuration par défaut
      provider = "groq", -- "openai", "ollama", "lmstudio", "custom"

      -- UI
      ui = {
        border = "rounded",
        width_ratio = 0.8,
        height_ratio = 0.8,
      },

      -- Stockage
      storage = {
        enabled = true,
        auto_save = false, -- Demander confirmation avant de sauvegarder
      },

      -- Révision espacée
      spaced_repetition = {
        enabled = true,
        check_on_startup = true,
        intervals = { 1, 3, 7, 14, 30 }, -- Jours selon difficulté (1-5)
      },

      -- Raccourcis clavier
      keymaps = {
        trigger = "<leader>h",        -- Mode visuel
        show_concepts = "<leader>sc",  -- Mode normal
        review_concepts = "<leader>sr", -- Mode normal
      },
    })
  end,
}
```

### Avec [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "mickaelfree/LazyLearn",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("lazylearn").setup()
  end,
}
```

## ⚙️ Configuration

### Variables d'environnement

Configurez votre clé API dans votre shell (`.bashrc`, `.zshrc`, etc.) :

```bash
# Pour Groq
export GROQ_API_KEY="votre_clé_api"

# Pour OpenAI
export OPENAI_API_KEY="votre_clé_api"
```

### Providers IA supportés

1. **Groq** (par défaut)
   - Modèle: `llama-3.3-70b-versatile`
   - Rapide et gratuit
   - Requiert: `GROQ_API_KEY`

2. **OpenAI**
   - Modèle: `gpt-4`
   - Haute qualité
   - Requiert: `OPENAI_API_KEY`

3. **Ollama**
   - Modèle local: `llama3`
   - Gratuit et privé
   - Requiert: Ollama installé localement

4. **LM Studio**
   - Modèle local personnalisé
   - Interface graphique
   - Requiert: LM Studio en cours d'exécution

5. **Custom**
   - Configurez votre propre API
   - Maximum de flexibilité

### Configuration personnalisée des providers

```lua
require("lazylearn").setup({
  provider = "ollama",

  providers = {
    ollama = {
      api_url = "http://localhost:11434/api/chat",
      model = "codellama",
      system_prompt = "Tu es un expert en programmation...",
    },

    custom = {
      api_url = "http://votre-api.com/v1/chat",
      model = "votre-modele",
      api_key_env = "VOTRE_API_KEY",
      system_prompt = "Votre prompt système...",
    },
  },
})
```

## 🚀 Utilisation

### Workflow de base

1. **Sélectionnez du code** en mode visuel (`V`, `v`, ou `Ctrl-v`)
2. **Appuyez sur `<leader>h`** (par défaut)
3. **Choisissez une technique d'apprentissage** dans le menu
4. **Lisez l'explication** dans la fenêtre flottante
5. **Sauvegardez** le concept pour révision ultérieure (optionnel)

### Commandes disponibles

| Commande | Description |
|----------|-------------|
| `:LLearn` | Lancer l'analyse du code sélectionné |
| `:LLearnConcepts` | Afficher tous les concepts sauvegardés |
| `:LLearnReview` | Démarrer une session de révision |
| `:LLearnStats` | Afficher les statistiques d'apprentissage |
| `:LLearnProvider` | Changer de provider IA |
| `:LLearnTest` | Tester la connexion au provider |

### Raccourcis clavier

| Mode | Raccourci | Action |
|------|-----------|--------|
| Visuel | `<leader>h` | Analyser la sélection |
| Normal | `<leader>sc` | Afficher les concepts |
| Normal | `<leader>sr` | Réviser les concepts |
| Float | `q` ou `Esc` | Fermer la fenêtre |
| Révision | `1-5` | Évaluer la difficulté |
| Révision | `s` | Passer le concept |
| Révision | `d` | Supprimer le concept |

## 📚 Techniques d'apprentissage

LazyLearn.nvim inclut 40+ techniques d'apprentissage organisées en catégories :

### 🧩 Techniques Mnémoniques (9)
- **Chunking** : Découpage mémoriel optimisé
- **Palais de Mémoire** : Mémorisation spatiale
- **Double Encodage** : Encodage visuel et verbal
- **Interrogation Élaborative** : Comprendre par les pourquoi
- **Difficulté Désirable** : Apprentissage par effort
- **Feynman Inversé** : Du simple au complexe
- **Interleaving** : Connexions inter-domaines
- **Récupération Temporisée** : Révision programmée
- **Multi-Sensoriel** : Encodage par tous les sens

### 🎯 Analyse de Principes (3)
- **20/80 Analyse** : Points critiques et impact maximal
- **Principes Fondamentaux** : Bases essentielles
- **Carte Conceptuelle** : Visualiser les relations

### 🔬 Modèles Mentaux (3)
- **Méta-Modèles** : Modèles mentaux fondamentaux
- **Modèles de Débogage** : Résolution de problèmes
- **Modèles d'Architecture** : Pensée architecturale

### 📈 Apprentissage Progressif (4)
- **Analogies Quotidiennes** : Comprendre par comparaison
- **Questions Socratiques** : Comprendre par questionnement
- **Chemin d'Apprentissage** : Progression structurée
- **Correction Misconceptions** : Éviter les erreurs

### ⚡ Applications Pratiques (4)
- **Debug Rapide** : Debugging efficace
- **Optimisation Rapide** : Gains rapides
- **Revue Rapide** : Revue de code efficace
- **Optimisation** : Performance et efficacité

### 👨‍🔬 Perspectives Avancées (3)
- **Vision Expert** : Perspective avancée
- **Contexte et Applications** : Vue d'ensemble
- **Approches Alternatives** : Différentes solutions

### ✨ Styles et Pratiques (4)
- **Bonnes Pratiques** : Standards et conventions
- **Style de Code** : Lisibilité et maintenance
- **Style Carmack** : Approche John Carmack
- **Style 5 Étoiles** : Solution élégante

### 🔍 Techniques Spécifiques (2)
- **Full Pointeurs** : Solution pointeurs
- **Opérations Binaires** : Manipulation bits

## 🎨 Packs Communautaires

Créez et partagez vos propres techniques d'apprentissage !

### Créer un pack

Créez un fichier JSON dans `~/.local/share/nvim/lazylearn/packs/` ou `~/.config/nvim/lazylearn/packs/` :

```json
{
  "name": "Mon Pack Perso",
  "version": "1.0.0",
  "author": "Votre Nom",
  "description": "Mes techniques d'apprentissage personnalisées",
  "prompts": [
    {
      "id": "mon_prompt",
      "name": "Ma Technique",
      "icon": "🎯",
      "category": "custom",
      "description": "Description courte",
      "prompt": "Votre prompt détaillé ici...\n\nLe concept à analyser est : "
    }
  ]
}
```

### Exemple de pack

Voir `packs/community/example.json` pour un exemple complet.

## 📊 Système de Révision Espacée

LazyLearn utilise un algorithme de répétition espacée (SRS) pour optimiser la mémorisation :

| Difficulté | Intervalle | Description |
|------------|-----------|-------------|
| 1 | 1 jour | Très difficile |
| 2 | 3 jours | Difficile |
| 3 | 7 jours | Moyen |
| 4 | 14 jours | Facile |
| 5 | 30 jours | Très facile |

Le plugin vous rappelle automatiquement les concepts à réviser au démarrage.

## 🔧 Développement

### Structure du projet

```
LazyLearn.nvim/
├── lua/
│   ├── lazylearn/
│   │   ├── init.lua       # Point d'entrée principal
│   │   ├── config.lua     # Gestion de la configuration
│   │   ├── ui.lua         # Interface utilisateur
│   │   ├── api.lua        # Communication avec les APIs IA
│   │   ├── prompts.lua    # Gestion des prompts
│   │   └── storage.lua    # Stockage et révision
│   └── lazylearn.lua      # Wrapper pour lazy.nvim
├── packs/
│   └── community/         # Packs communautaires
├── doc/
│   └── lazylearn.txt      # Documentation Vim
└── README.md
```

### Contribuer

1. Fork le projet
2. Créez une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. Pushez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrez une Pull Request

## 📝 FAQ

### Comment changer de provider IA ?

```vim
:LLearnProvider
```

Ou en configuration :

```lua
require("lazylearn").setup({
  provider = "ollama", -- ou "openai", "lmstudio", etc.
})
```

### Les concepts sont-ils sauvegardés automatiquement ?

Par défaut, non. Le plugin demande confirmation. Pour activer la sauvegarde automatique :

```lua
require("lazylearn").setup({
  storage = {
    auto_save = true,
  },
})
```

### Comment désactiver la vérification des révisions au démarrage ?

```lua
require("lazylearn").setup({
  spaced_repetition = {
    check_on_startup = false,
  },
})
```

### Où sont stockés les concepts ?

Par défaut dans `~/.local/share/nvim/lazylearn_concepts.json`

Personnalisable via :

```lua
require("lazylearn").setup({
  storage = {
    path = vim.fn.expand("~/mes_concepts.json"),
  },
})
```

## 🙏 Remerciements

- Inspiré par les techniques d'apprentissage cognitif modernes
- Basé sur le travail original de [votre nom]
- Utilise [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) pour les requêtes HTTP

## 📄 Licence

MIT License - Voir [LICENSE](LICENSE) pour plus de détails

## 🌟 Supportez le projet

Si LazyLearn.nvim vous aide à apprendre plus efficacement :

- ⭐ Donnez une étoile au projet
- 🐛 Signalez les bugs
- 💡 Proposez des fonctionnalités
- 🎨 Partagez vos packs communautaires
- 📢 Parlez-en autour de vous

---

**Fait avec ❤️ pour la communauté Neovim**
