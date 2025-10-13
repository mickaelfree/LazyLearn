# 🎲 Système d'Imprévisibilité - LazyLearn.nvim

**Unpredictability & Curiosity** : La surprise, l'aléatoire et le désir de découvrir ce qui va se passer !

## 🎯 Vision

Créer de l'engagement par l'**inattendu** et la **curiosité**. Les récompenses aléatoires, les découvertes surprises et les easter eggs créent un sentiment d'"encore une fois pour voir ce qui se passe".

> "On ne sait jamais ce qu'on va trouver. C'est ça qui rend l'apprentissage excitant !"

## ✨ Fonctionnalités

### 🎁 Récompense Mystère Quotidienne
- **1 récompense par jour** avec contenu aléatoire
- **6 niveaux de rareté** : Petit Bonus → MEGA JACKPOT
- **XP ou Tokens** : 10-500 XP ou 2 tokens
- **Système de poids** : Récompenses rares vraiment rares (3% pour MEGA JACKPOT)

### 🥚 Easter Eggs Aléatoires
- **4 easter eggs** avec probabilités variées (1%-5%)
- **Citations de Carmack** : +100 XP bonus
- **Jour de chance** : Prochain gain d'XP doublé !
- **Mentor Mystère** : +50 XP bonus
- **Artefact Ancien** : +200 XP (ultra rare, 1%)

### 🔍 Découverte de Concepts Aléatoires
- **10 concepts** de différents langages
- **Découverte progressive** : 1 concept aléatoire à la fois
- **Difficulté variée** : Beginner, Intermediate, Advanced
- **+25 XP** par découverte

### 🎭 Prompts Mystères Progressifs
- **3 prompts secrets** qui se révèlent avec l'usage
- **Déblocage graduel** : Utilisez 5 fois pour révéler
- **Prompts d'expert** : Optimisation, Sécurité, Architecture
- **Sentiment de progression** : Voir le mystère se dévoiler

### 🎲 Système d'Aléatoire
- **Variable Ratio Reward** : Comme les machines à sous
- **Curiosité maintenue** : "Qu'est-ce que je vais obtenir ?"
- **Dopamine hits** : Récompenses imprévisibles

## 📦 Configuration

```lua
require("lazylearn").setup({
  unpredictability = {
    enabled = true,                       -- ✅ Activer imprévisibilité
    enable_mystery_rewards = true,        -- Récompenses mystères
    enable_easter_eggs = true,            -- Easter eggs aléatoires
    enable_random_discovery = true,       -- Découverte de concepts
    enable_mystery_prompts = true,        -- Prompts mystères
    easter_egg_check_frequency = 0.1,     -- Vérifier 10% du temps
  },
})
```

## 🚀 Utilisation

### 1. Récompense Mystère Quotidienne

```vim
:LLearnMystery
```

**Obtention aléatoire** :
- 40% de chance : 🎁 Petit Bonus (10-30 XP)
- 30% de chance : 🎁 Bonus Moyen (30-70 XP)
- 20% de chance : 🎁 Gros Bonus (70-150 XP)
- 5% de chance : 🎁 JACKPOT (150-300 XP)
- 3% de chance : 🎁 MEGA JACKPOT (300-500 XP)
- 2% de chance : 💎 Token Bonus (+2 🎫)

#### Exemple d'affichage

```markdown
# 🎁 Récompense Mystère Quotidienne !

Vous avez obtenu : 🎁 JACKPOT

+287 XP !
```

### 2. Découvrir un Concept Aléatoire

```vim
:LLearnDiscover
```

**Révèle un concept random** parmi :
- JavaScript: Event Loop, Prototypal Inheritance
- Rust: Lifetimes, Traits
- Python: Decorators, Metaclasses
- Go: Goroutines, Channels
- C++: Move Semantics, RAII

#### Exemple d'affichage

```markdown
# 🔍 Concept Mystère Découvert !

**Langage:** RUST
**Topic:** Lifetimes
**Difficulté:** 🌳 advanced

---

💡 Utilisez `:LLearn` pour apprendre ce concept avec l'IA !

+25 XP (Découverte)
```

### 3. Voir les Concepts Découverts

```vim
:LLearnDiscovered
```

#### Exemple d'affichage

```markdown
# 🔍 Concepts Découverts

**Total découvert:** 5 / 10

---

1. **Lifetimes**
   Langage: RUST | Difficulté: 🌳 advanced
   Découvert le: 2025-01-15

2. **Event Loop**
   Langage: JAVASCRIPT | Difficulté: 🌿 intermediate
   Découvert le: 2025-01-16

...
```

### 4. Utiliser un Prompt Mystère

```vim
:LLearnMysteryPrompt
```

**Menu de sélection** :
- 🔒 ❓ Prompt Mystère #1 (Utilisations: 2/5)
- 🔒 ❓ Prompt Mystère #2 (Utilisations: 0/5)
- 🔓 🔍 Optimisation Secrète (RÉVÉLÉ)

#### Progression d'un prompt mystère

```
Utilisation 1/5: ❓ ??? (Utilisations: 1/5)
Utilisation 2/5: ❓ ??? (Utilisations: 2/5)
...
Utilisation 5/5: 🎉 Prompt mystère révélé : 🔍 Optimisation Secrète !

Prompt complet maintenant visible !
```

### 5. Voir les Statistiques de Surprises

```vim
:LLearnSurprises
```

#### Exemple d'affichage

```markdown
# 🎲 Statistiques de Surprises

🎉 **Total de surprises:** 23

## 🥚 Easter Eggs Trouvés

- 💬 Citation de Carmack
- 🎭 Mentor Mystère

**Total:** 2 / 4

## 🔍 Concepts Découverts

**Total:** 5 / 10

## 🎭 Prompts Mystères

✅ 🔍 Optimisation Secrète (5/5)
🔒 ❓ Prompt Mystère #2 (2/5)
🔒 ❓ Prompt Mystère #3 (0/5)

**Révélés:** 1 / 3

## 🎁 Récompense Mystère

✅ Réclamée aujourd'hui
```

### 6. Easter Eggs (Automatiques)

Les easter eggs se déclenchent **automatiquement** et aléatoirement lors de l'apprentissage :

```vim
" Apprendre un concept normalement
V<leader>h

" 10% de chance de vérifier un easter egg
" Si déclenché :
🎉 SURPRISE ! 💬 Citation de Carmack
John Carmack dit : 'Focused, hard work is the real key to success.'
+100 XP !
```

## 🎁 Récompenses Mystères

### Table de probabilités

| Récompense | XP Min | XP Max | Poids | Probabilité |
|------------|--------|--------|-------|-------------|
| 🎁 Petit Bonus | 10 | 30 | 40 | 40% |
| 🎁 Bonus Moyen | 30 | 70 | 30 | 30% |
| 🎁 Gros Bonus | 70 | 150 | 20 | 20% |
| 🎁 JACKPOT | 150 | 300 | 5 | 5% |
| 🎁 MEGA JACKPOT | 300 | 500 | 3 | 3% |
| 💎 Token Bonus | - | - (2🎫) | 2 | 2% |

### Fonctionnement

**Variable Ratio Schedule** :
- Récompense aléatoire à chaque réclamation
- Impossible de prédire le résultat
- Crée un comportement compulsif ("encore une fois")

**Cooldown** :
- 1 fois par jour (reset à minuit)
- Crée l'anticipation du lendemain

## 🥚 Easter Eggs

### Catalogue complet

| Easter Egg | Rareté | Effet | Récompense |
|------------|--------|-------|------------|
| 💬 **Citation de Carmack** | 2% | Message inspirant | +100 XP |
| 🍀 **Jour de Chance** | 5% | Double XP au prochain gain | Multiplicateur x2 |
| 🎭 **Mentor Mystère** | 3% | Message mystérieux | +50 XP |
| 🏺 **Artefact Ancien** | 1% | Découverte ultra rare | +200 XP |

### Fonctionnement

**Vérification aléatoire** :
- 10% de chance de vérifier à chaque concept appris (configurable)
- Si vérification → roll contre rareté de chaque easter egg
- Probabilités indépendantes (pas de "pity system")

**Effet "Double XP"** :
```
1. Trouver l'easter egg "Jour de Chance"
2. Prochain gain d'XP automatiquement doublé
3. Exemple: +10 XP → +20 XP (avec notification)
4. Effet consommé après 1 utilisation
```

## 🔍 Concepts Aléatoires

### Catalogue complet (10 concepts)

| Langage | Topic | Difficulté |
|---------|-------|------------|
| JavaScript | Event Loop | Intermediate |
| JavaScript | Prototypal Inheritance | Advanced |
| Rust | Lifetimes | Advanced |
| Rust | Traits | Intermediate |
| Python | Decorators | Intermediate |
| Python | Metaclasses | Advanced |
| Go | Goroutines | Intermediate |
| Go | Channels | Intermediate |
| C++ | Move Semantics | Advanced |
| C++ | RAII | Intermediate |

### Progression

**Découverte unique** :
- Chaque concept ne peut être découvert qu'une seule fois
- Liste diminue progressivement
- Complétionistes peuvent tout découvrir (10/10)

**Récompenses** :
- +25 XP par découverte
- Sentiment de collection (tracker 5/10, 7/10, 10/10)

## 🎭 Prompts Mystères

### Catalogue complet (3 prompts)

| ID | Nom Révélé | Déblocage | Description |
|----|------------|-----------|-------------|
| mystery_optimization | 🔍 Optimisation Secrète | 5 utilisations | Analyse performance avancée avec benchmarks |
| mystery_security | 🛡️ Audit de Sécurité | 5 utilisations | Scan de vulnérabilités complet |
| mystery_architecture | 🏛️ Revue d'Architecture | 5 utilisations | Évaluation design patterns et couplage |

### Mécanique de révélation

**Progression graduelle** :
```
Utilisation 0: 🔒 ❓ Prompt Mystère #1 (0/5)
Utilisation 1: 🔒 ❓ Prompt Mystère #1 (1/5) - Toujours mystérieux
Utilisation 2: 🔒 ❓ Prompt Mystère #1 (2/5)
Utilisation 3: 🔒 ❓ Prompt Mystère #1 (3/5)
Utilisation 4: 🔒 ❓ Prompt Mystère #1 (4/5)
Utilisation 5: 🎉 Révélation ! 🔓 🔍 Optimisation Secrète
               Prompt complet maintenant visible !
```

**Utilisable avant révélation** :
- Le prompt fonctionne même mystérieux
- Encourage l'expérimentation
- Récompense la curiosité

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnMystery` | Réclamer la récompense mystère quotidienne |
| `:LLearnDiscover` | Découvrir un concept aléatoire |
| `:LLearnDiscovered` | Voir tous les concepts découverts |
| `:LLearnMysteryPrompt` | Utiliser un prompt mystère |
| `:LLearnSurprises` | Statistiques de toutes les surprises |

## 💡 Pourquoi Unpredictability & Curiosity fonctionne ?

### Psychologie de l'Imprévisibilité

Le **Core Drive 7: Unpredictability & Curiosity** du framework Octalysis crée une motivation forte grâce à :

1. **Variable Ratio Reinforcement** : Le plus puissant type de conditionnement
2. **Curiosité naturelle** : "Qu'est-ce qui va se passer ?"
3. **Dopamine anticipative** : Le cerveau aime l'incertitude
4. **Fear of Missing Out (FOMO)** : "Et si je rate quelque chose ?"
5. **Exploration rewarded** : La découverte est gratifiante

### Mécaniques psychologiques

#### 1. Variable Ratio Schedule (Skinner Box)
```
Ratio fixe (prévisible):
Action → Récompense (toujours) → Ennui rapide

Variable ratio (imprévisible):
Action → Récompense (parfois) → Comportement compulsif
```

**Exemple** : Machines à sous dans les casinos (même principe)

#### 2. Curiosity Gap (Loewenstein)
```
"Je sais qu'il y a 3 prompts mystères..."
"Mais je ne sais PAS ce qu'ils contiennent..."
→ Gap d'information → Curiosité intense → Action pour combler
```

#### 3. Dopamine & Anticipation
```
Récompense prévisible: Dopamine lors de la récompense
Récompense imprévisible: Dopamine AVANT même de savoir !
→ Plus addictif
```

#### 4. The Lottery Effect
```
"Je POURRAIS obtenir un MEGA JACKPOT (500 XP) !"
→ Motivation par la possibilité, pas la garantie
→ Espoir > Certitude pour l'engagement
```

## 🎯 Workflow Recommandé

### Pour maximiser les surprises

```lua
unpredictability = {
  enabled = true,
  enable_easter_eggs = true,
  easter_egg_check_frequency = 0.15,  -- Augmenter à 15%
}
```

**Routine quotidienne** :
1. **Matin** : `:LLearnMystery` pour la récompense quotidienne
2. **Apprendre** : Concepts multiples (plus d'occasions d'easter eggs)
3. **Explorer** : `:LLearnDiscover` régulièrement
4. **Expérimenter** : `:LLearnMysteryPrompt` pour révéler progressivement

**Mindset d'exploration** :
- "Qu'est-ce que je vais trouver aujourd'hui ?"
- Apprécier la surprise, pas le contrôle
- Collection complète = objectif long terme

## 📊 Structure des Données

Les données d'imprévisibilité sont stockées dans `~/.local/share/nvim/lazylearn_unpredictability.json` :

```json
{
  "mystery_reward_claimed_date": "2025-01-15",
  "easter_eggs_found": ["carmack_quote", "mystery_mentor"],
  "mystery_prompts_uses": {
    "mystery_optimization": 5,
    "mystery_security": 2,
    "mystery_architecture": 0
  },
  "discovered_concepts": [
    {
      "topic": "Lifetimes",
      "language": "rust",
      "difficulty": "advanced",
      "discovered_date": 1705334400
    }
  ],
  "double_xp_next_active": false,
  "total_surprises": 23
}
```

## 🔧 IDs des Easter Eggs et Prompts

**Easter Eggs** :
- `carmack_quote` - Citation de Carmack
- `lucky_streak` - Jour de Chance (Double XP)
- `mystery_mentor` - Mentor Mystère
- `code_archaeologist` - Artefact Ancien

**Prompts Mystères** :
- `mystery_optimization` - Optimisation Secrète
- `mystery_security` - Audit de Sécurité
- `mystery_architecture` - Revue d'Architecture

## ❓ FAQ

### Les easter eggs sont-ils vraiment aléatoires ?

Oui, basés sur `math.random()` avec seed du temps système. Les probabilités sont authentiques (1%-5%).

### Puis-je augmenter mes chances d'easter eggs ?

Oui, via `easter_egg_check_frequency` dans la config. Par défaut 10%, vous pouvez monter à 20-30% (mais moins rare = moins spécial).

### Que se passe-t-il si je découvre tous les concepts ?

Vous obtenez le statut "Explorateur Complet" (10/10). Mais l'apprentissage continue avec le système normal !

### Les prompts mystères sont-ils meilleurs que les normaux ?

Oui, ce sont des prompts d'expert conçus pour des analyses avancées. Ils valent la peine d'être révélés.

### La récompense mystère peut-elle donner 500 XP tous les jours ?

Théoriquement oui, mais probabilité de 3% (MEGA JACKPOT). Sur 100 jours, vous l'obtiendrez ~3 fois.

## 🎨 Personnalisation

### Ajouter des easter eggs custom

```lua
-- Dans lua/lazylearn/unpredictability.lua
table.insert(M.EASTER_EGGS, {
  id = "my_surprise",
  name = "🌟 Ma Surprise",
  rarity = 0.04, -- 4% chance
  message = "Un message surprenant !",
  reward_xp = 150,
})
```

### Ajouter des concepts aléatoires

```lua
-- Dans lua/lazylearn/unpredictability.lua
table.insert(M.RANDOM_CONCEPTS, {
  language = "typescript",
  topic = "Type Guards",
  difficulty = "intermediate",
})
```

### Modifier les probabilités des récompenses

```lua
-- Rendre les JACKPOTS plus fréquents
M.MYSTERY_REWARDS = {
  { name = "🎁 Petit Bonus", xp_min = 10, xp_max = 30, weight = 30 }, -- Réduit
  { name = "🎁 JACKPOT", xp_min = 150, xp_max = 300, weight = 15 }, -- Augmenté
  { name = "🎁 MEGA JACKPOT", xp_min = 300, xp_max = 500, weight = 10 }, -- Augmenté
}
```

### Ajouter des prompts mystères

```lua
-- Dans lua/lazylearn/unpredictability.lua
table.insert(M.MYSTERY_PROMPTS, {
  id = "mystery_custom",
  revealed_name = "🔮 Mon Prompt Secret",
  hidden_name = "❓ Prompt Mystère #4",
  description = "Un prompt incroyable...",
  unlock_uses = 3, -- Révélé après 3 utilisations
  prompt = "Ton prompt custom ici...",
})
```

## 🎰 Comparaison avec Jeux Vidéo

LazyLearn Unpredictability s'inspire de mécaniques éprouvées :

| Mécanique | Jeu Vidéo | LazyLearn |
|-----------|-----------|-----------|
| **Loot Boxes** | Overwatch, FIFA | Récompenses Mystères quotidiennes |
| **Random Encounters** | Pokémon | Easter Eggs aléatoires |
| **Discovery Rewards** | Zelda: BOTW | Découverte de concepts |
| **Progressive Reveals** | Destiny exotics | Prompts mystères |
| **Double XP Events** | Call of Duty | Jour de Chance easter egg |

## 🌟 Conclusion

Le système d'imprévisibilité transforme l'apprentissage en **aventure surprenante**. Chaque session peut révéler quelque chose d'inattendu, maintenant l'engagement et la curiosité.

> **"Expect the unexpected"** - La devise de LazyLearn Unpredictability

---

**Qu'allez-vous découvrir aujourd'hui ?** 🎲
