# 🤖 Nommage Automatique - LazyLearn.nvim

LazyLearn génère automatiquement des noms intelligents pour vos concepts afin d'**éliminer toute friction** lors de la sauvegarde.

## ✨ Fonctionnalités

- 🧠 **Détection intelligente** du concept principal dans le code
- 📝 **Extraction automatique** de mots-clés pertinents
- 🎯 **Noms descriptifs** basés sur le contenu réel
- 🔄 **Plusieurs stratégies** de nommage disponibles
- ✅ **Zéro friction** : appuyez juste sur Entrée

## 🚀 Modes de Sauvegarde

### Mode 1 : Automatique complet (zéro friction)

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,
    auto_save = true,  -- ✅ Sauvegarde automatique sans demander
  },
})
```

**Workflow** :
1. Sélectionner code → `<leader>h`
2. Choisir technique
3. ✅ **Sauvegardé automatiquement !** (pas d'input)

### Mode 2 : Confirmation avec suggestion (recommandé)

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,
    auto_save = false,  -- Demande confirmation
  },
})
```

**Workflow** :
1. Sélectionner code → `<leader>h`
2. Choisir technique
3. **Nom suggéré** : `fibonacci-recursion`
4. Appuyer sur **Entrée** pour accepter (ou modifier)

## 🎯 Stratégies de Nommage

### 1. Détection de concept dans le code

Le système détecte automatiquement :

#### Fonctions
```javascript
function fibonacci(n) { ... }
```
→ Nom généré : **`fibonacci`**

```python
def quick_sort(arr): ...
```
→ Nom généré : **`quick-sort`**

#### Classes
```javascript
class UserManager { ... }
```
→ Nom généré : **`usermanager`** ou **`class-usermanager`**

```rust
struct BinaryTree { ... }
```
→ Nom généré : **`binarytree`** ou **`struct-binarytree`**

#### Variables importantes
```javascript
const debounce = (fn, delay) => { ... }
```
→ Nom généré : **`debounce`**

### 2. Extraction de mots-clés

Si aucun concept évident n'est détecté, le système extrait les mots-clés les plus importants :

```javascript
// Code sans nom de fonction évident
arr.reduce((acc, val) => acc + val, 0)
```
→ Analyse du code + réponse IA
→ Nom généré : **`reduce-accumulator`** ou **`array-reduce-sum`**

### 3. Scoring intelligent

Les mots sont scorés selon :
- **Fréquence** dans le code et la réponse
- **CamelCase/PascalCase** (bonus de pertinence)
- **Longueur** (min 4 caractères)
- **Filtrage** des stop words

### 4. Stratégies multiples

Le système propose plusieurs variantes :

```javascript
function factorial(n) {
  return n <= 1 ? 1 : n * factorial(n - 1);
}
```

Noms possibles :
1. **`factorial`** (simple)
2. **`recursion-factorial`** (avec contexte)
3. **`factorial-20250115`** (avec date)
4. **`principes-fondamentaux-factorial`** (avec technique)

## 📝 Exemples Réels

### JavaScript

```javascript
const memoize = (fn) => {
  const cache = {};
  return (...args) => {
    const key = JSON.stringify(args);
    return cache[key] ?? (cache[key] = fn(...args));
  };
}
```

**Noms générés** :
- Mode simple : **`memoize`**
- Mode contexte : **`memoize-cache`**
- Mode technique : **`optimisation-memoize`**

### Python

```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
```

**Nom généré** : **`binary-search`**

### Rust

```rust
impl<T> BinaryTree<T> {
    fn insert(&mut self, value: T) {
        // ...
    }
}
```

**Noms générés** :
- **`binarytree-insert`**
- **`method-insert`**
- **`struct-binarytree`**

## ⚙️ Configuration Avancée

### Option 1 : Auto-save total (zéro friction)

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,
    auto_save = true,           -- Pas de prompt, sauvegarde directe
    vault_path = "~/Obsidian",
    concepts_folder = "Code",
  },
})
```

### Option 2 : Confirmation avec nom intelligent

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,
    auto_save = false,          -- Demande avec nom pré-rempli
  },
})
```

Prompt affiché :
```
Nom du concept (Entrée pour accepter 'fibonacci-recursion'): _
```

Appuyez sur **Entrée** → sauvegarde avec le nom suggéré
Ou tapez un nouveau nom → sauvegarde avec votre nom

### Option 3 : JSON classique

```lua
require("lazylearn.init").setup({
  storage = {
    enabled = true,
    auto_save = true,  -- Auto-save en JSON
  },
  obsidian = {
    enabled = false,
  },
})
```

## 🎨 Personnalisation

### Modifier les patterns de détection

Éditez `lua/lazylearn/naming.lua` :

```lua
local CODE_PATTERNS = {
  -- Ajouter vos patterns
  {pattern = "hook%s+(%w+)", prefix = "hook"},
  {pattern = "component%s+(%w+)", prefix = "component"},
}
```

### Modifier les stop words

```lua
local STOP_WORDS = {
  -- Ajouter vos mots à ignorer
  "todo", "temp", "test",
}
```

## 📊 Algorithme de Nommage

```
1. Analyser le code
   ├─ Détecter fonction/classe/struct → Utiliser ce nom
   ├─ Sinon, extraire 2-3 mots-clés du code
   └─ Sinon, extraire des mots de la réponse IA

2. Scorer les mots
   ├─ Fréquence dans code/réponse
   ├─ Présence de CamelCase/PascalCase
   └─ Filtrer stop words

3. Construire le nom
   ├─ Joindre avec des tirets
   ├─ Convertir en lowercase
   └─ Limiter à 50 caractères

4. Assurer unicité
   └─ Ajouter suffixe -1, -2... si existe déjà
```

## 💡 Cas d'Usage

### Apprentissage rapide (zéro friction)

Configuration recommandée :
```lua
obsidian = {
  enabled = true,
  auto_save = true,        -- ✅ Sauvegarde auto
  open_after_save = false, -- ❌ Ne pas ouvrir Obsidian
}
```

**Avantage** : Focus total sur l'apprentissage, pas d'interruption

### Apprentissage avec organisation

Configuration recommandée :
```lua
obsidian = {
  enabled = true,
  auto_save = false,       -- Voir le nom suggéré
  open_after_save = true,  -- Ouvrir pour annoter
}
```

**Avantage** : Contrôle du nommage + organisation immédiate

### Apprentissage offline

Configuration recommandée :
```lua
storage = {
  enabled = true,
  auto_save = true,        -- Sauvegarde JSON auto
}
obsidian = {
  enabled = false,
}
```

**Avantage** : Pas besoin d'Obsidian, sauvegarde rapide

## 🔍 Debug du Nommage

Pour voir le nom qui serait généré :

```lua
-- Dans Neovim
:lua local naming = require("lazylearn.naming")
:lua print(naming.generate_name("function test() {}", "Technique", "Explication..."))
```

## ✅ Recommandations

### Pour éliminer toute friction

```lua
require("lazylearn.init").setup({
  obsidian = {
    enabled = true,
    auto_save = true,           -- ✅ Zéro prompt
    vault_path = "~/Obsidian",
    concepts_folder = "LazyLearn",
  },
})
```

**Workflow** :
1. Code → `<leader>h` → Technique
2. ✅ **C'est tout !** Sauvegarde auto avec nom intelligent

### Pour garder le contrôle

```lua
require("lazylearn.init").setup({
  obsidian = {
    auto_save = false,  -- Voir et valider le nom
  },
})
```

**Workflow** :
1. Code → `<leader>h` → Technique
2. Voir : `Nom du concept (Entrée pour accepter 'fibonacci'):`
3. **Entrée** (accepter) ou **modifier**

## 🎯 Résultat

**Avant** :
```
💭 "Comment je vais appeler ce concept?"
⌨️  "fibonacci... non fibonacci-recursion... non..."
😫 "Bon, fibonacci-concept-2024..."
```

**Après** :
```
✨ Nom suggéré : fibonacci-recursion
⏎  [Entrée]
✅ Sauvegardé !
```

---

**Zéro friction = Plus de temps pour apprendre !** 🚀
