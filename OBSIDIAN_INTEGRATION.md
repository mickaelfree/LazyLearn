# 🔗 Intégration Obsidian - LazyLearn.nvim

LazyLearn.nvim peut maintenant sauvegarder vos concepts directement dans votre vault Obsidian avec des liens, tags et métadonnées automatiques !

## ✨ Fonctionnalités

- 📝 **Sauvegarde en Markdown** : Format compatible Obsidian
- 🏷️ **Tags automatiques** : Langage, technique, mots-clés
- 🔗 **Liens Obsidian** : Concepts liés automatiquement
- 📊 **Métadonnées YAML** : Frontmatter complet
- 🗂️ **Index automatique** : MOC (Map of Content) généré
- 🎯 **Détection intelligente** : Langage et mots-clés auto-détectés

## 📦 Configuration

### Activer l'intégration Obsidian

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,                                    -- ✅ Activer Obsidian
    vault_path = "~/Documents/Obsidian",               -- Chemin vers votre vault
    vault_name = "MyVault",                            -- Nom de votre vault
    concepts_folder = "LazyLearn",                     -- Dossier dans le vault
    open_after_save = true,                            -- Ouvrir dans Obsidian après save
    auto_index = true,                                 -- Index automatique
  },
})
```

### Configuration complète

```lua
require("lazylearn.init").setup({
  -- Désactiver le stockage JSON si vous utilisez Obsidian
  storage = {
    enabled = false,
  },

  -- Activer Obsidian
  obsidian = {
    enabled = true,
    vault_path = vim.fn.expand("~/Documents/ObsidianVault"),
    vault_name = "MyVault",
    concepts_folder = "LazyLearn",
    open_after_save = true,
    auto_index = true,
  },
})
```

## 📝 Format des Fichiers Générés

### Exemple de concept sauvegardé

```markdown
---
title: Fibonacci Recursion
created: 2025-01-15 14:30:00
updated: 2025-01-15 14:30:00
tags:
  - lazylearn
  - javascript
  - principes-fondamentaux
  - fibonacci
  - recursion
  - algorithm
review_count: 0
next_review: 2025-01-16
technique: Principes Fondamentaux
---

# Fibonacci Recursion

## 📝 Code Original

```javascript
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

## 🧠 Explication

[Explication générée par l'IA...]

## 🔗 Concepts Liés

- [[Recursion]]
- [[Dynamic Programming]]
- [[Time Complexity]]

## 🏷️ Mots-clés

- #fibonacci
- #recursion
- #algorithm
- #performance
- #javascript

## 📅 Révision

- **Prochaine révision**: 2025-01-16
- **Nombre de révisions**: 0

## 🎯 Technique Utilisée

**Principes Fondamentaux**

---

*Créé avec [LazyLearn.nvim](https://github.com/mickaelfree/LazyLearn) le 15/01/2025 à 14:30*
```

## 🎯 Utilisation

### 1. Sauvegarder un concept

```vim
" Sélectionner du code en mode visuel
V

" Appuyer sur <leader>h
<leader>h

" Choisir une technique
" L'explication s'affiche

" Donner un nom au concept
fibonacci-recursion

" ✅ Sauvegardé dans Obsidian!
```

### 2. Créer l'index des concepts

```vim
:LLearnIndex
```

Génère un fichier `LazyLearn Index.md` avec :
- Concepts groupés par langage
- Concepts groupés par technique
- Statistiques

### 3. Ouvrir un concept dans Obsidian

```vim
:LLearnObsidian
```

Sélectionnez un concept et il s'ouvrira dans Obsidian.

## 🗂️ Structure du Vault

```
~/Documents/Obsidian/
├── LazyLearn/                      # Dossier des concepts
│   ├── fibonacci-recursion.md
│   ├── quick-sort-algorithm.md
│   ├── react-hooks-useeffect.md
│   └── ...
└── LazyLearn Index.md              # Index automatique (MOC)
```

## 🏷️ Tags Automatiques

LazyLearn génère automatiquement des tags pour :

### Tags de base
- `lazylearn` : Tous les concepts

### Tags de langage (auto-détectés)
- `javascript`, `python`, `rust`, `go`, etc.

### Tags de technique
- Basés sur la technique d'apprentissage utilisée
- Ex: `principes-fondamentaux`, `feynman-inverse`, `chunking`

### Tags de mots-clés (auto-extraits)
- Mots importants extraits du code et de l'explication
- Max 5 mots-clés par concept

## 🔗 Liens Automatiques

Les concepts liés sont détectés et liés automatiquement :

```markdown
## 🔗 Concepts Liés

- [[Recursion]]
- [[Dynamic Programming]]
- [[Memoization]]
```

## 📊 Index Automatique (MOC)

L'index `LazyLearn Index.md` est un Map of Content qui organise tous vos concepts :

### Par Langage
```markdown
### JAVASCRIPT
- [[fibonacci-recursion]]
- [[react-hooks]]
- [[async-await]]

### PYTHON
- [[list-comprehension]]
- [[decorators]]
```

### Par Technique
```markdown
### Principes Fondamentaux
- [[fibonacci-recursion]]
- [[binary-search]]

### Feynman Inversé
- [[react-lifecycle]]
```

### Statistiques
```markdown
- **Total de concepts**: 42
- **Langages**: 5
- **Techniques**: 8
```

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnIndex` | Créer/mettre à jour l'index |
| `:LLearnObsidian` | Ouvrir un concept dans Obsidian |

## 🎨 Template Personnalisé

Vous pouvez créer votre propre template :

1. Créez un fichier template :
```markdown
---
title: {{title}}
created: {{created}}
tags: {{tags}}
---

# {{title}}

## Code
{{code}}

## Explication
{{explanation}}
```

2. Configurez le chemin :
```lua
obsidian = {
  template_path = "~/Documents/Obsidian/Templates/lazylearn.md",
}
```

## 🔍 Recherche par Tags

Dans Obsidian, utilisez :
- `tag:#javascript` : Tous les concepts JavaScript
- `tag:#lazylearn` : Tous les concepts LazyLearn
- `tag:#feynman-inverse` : Concepts avec cette technique

## 💡 Conseils

### 1. Organisation
Créez des sous-dossiers par projet :
```lua
obsidian = {
  concepts_folder = "LazyLearn/MonProjet",
}
```

### 2. Workflow recommandé
1. Apprendre un concept → Sauvegarder dans Obsidian
2. Créer l'index régulièrement → `:LLearnIndex`
3. Réviser dans Obsidian avec les liens
4. Créer des notes connexes manuellement

### 3. Intégration avec Daily Notes
Ajoutez dans votre Daily Note :
```markdown
## 📚 Concepts appris aujourd'hui

![[LazyLearn Index#Statistiques]]
```

## 🚀 Exemples d'Utilisation

### Apprendre et sauvegarder
```vim
" Dans un fichier .js
function debounce(fn, delay) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}

" Sélectionner tout
ggVG

" Analyser
<leader>h

" Choisir "Principes Fondamentaux"
" Nommer: "debounce-pattern"

" ✅ Sauvegardé avec tags: javascript, debounce, timeout, closure
```

### Créer un MOC pour un projet
```vim
:LLearnIndex

" Puis dans Obsidian, créer:
# Mon Projet - Concepts

![[LazyLearn Index#JAVASCRIPT]]
```

## ❓ FAQ

### Les fichiers sont où exactement ?
Dans `~/Documents/Obsidian/LazyLearn/` (configurable)

### Puis-je modifier les fichiers manuellement ?
Oui ! Ce sont des fichiers Markdown standards

### L'index se met à jour automatiquement ?
Lancez `:LLearnIndex` manuellement ou automatiquement avec auto_index

### Puis-je désactiver certains tags ?
Oui, en créant un template personnalisé

## 🔗 Ressources

- [Obsidian](https://obsidian.md)
- [LazyLearn.nvim](https://github.com/mickaelfree/LazyLearn)
- [Documentation Obsidian](https://help.obsidian.md)

---

**Transformez votre apprentissage avec LazyLearn + Obsidian !** 🚀
