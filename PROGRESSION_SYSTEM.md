# 📈 Système de Progression - LazyLearn.nvim

**Development & Accomplishment** : Progressez, maîtrisez et surmontez des défis !

## 🎯 Vision

Le système de progression transforme votre apprentissage en une expérience mesurable et gratifiante. Chaque concept appris, chaque révision complétée vous rapproche de la maîtrise.

> "La progression visible est la clé de la motivation durable."

## ✨ Fonctionnalités

### 📊 Système XP & Niveaux
- **Gagnez de l'XP** à chaque action d'apprentissage
- **20 niveaux** de progression globale
- **Barre de progression visuelle** jusqu'au prochain niveau
- **Notifications de level up** avec débloquages

### 🌳 Skill Trees (Arbres de Compétences)
- **Un arbre par langage** (JavaScript, Rust, Python, etc.)
- **Progression séparée** pour chaque technologie
- **Niveaux de maîtrise** : Débutant → Intermédiaire → Avancé → Expert → Master
- **Visualisation ASCII** de l'arbre

### 🎓 Mastery Levels
- **5 niveaux par concept** : Novice → Competent → Proficient → Expert → Master
- **Progression basée sur les révisions** : Plus vous révisez, plus vous maîtrisez
- **Affichage groupé** par niveau de maîtrise

### 🏆 Challenges & Achievements
- **7 challenges disponibles** avec récompenses XP
- **Premiers Pas** : Apprendre 5 concepts (50 XP)
- **Apprenant Dévoué** : Apprendre 25 concepts (200 XP)
- **Champion du Streak** : 7 jours consécutifs (100 XP)
- **Polyglotte** : 5 langages différents (250 XP)
- Et plus...

### 🔥 Daily Streak
- **Streak quotidien** : Compteur de jours consécutifs
- **Bonus XP croissant** : +5 XP × nombre de jours de streak
- **Rappel au cassage** : Notification si le streak est perdu

### 📈 Perfect Review Streak
- **Streak de révisions parfaites** : Évaluer 5+ d'affilée
- **Bonus massif** : 20 XP au lieu de 5 XP
- **Récompense la maîtrise** : Encourage l'excellence

## 📦 Configuration

### Activation du système de progression

```lua
require("lazylearn").setup({
  progression = {
    enabled = true,                         -- ✅ Activer le système de progression
    data_path = "~/.local/share/nvim/lazylearn_progression.json",
    show_xp_notifications = true,           -- Afficher les gains d'XP
    show_level_up_animation = true,         -- Animation au level up
    track_daily_streak = true,              -- Suivre le streak quotidien
    auto_track = true,                      -- Tracker automatiquement
  },
})
```

### Configuration complète

```lua
require("lazylearn").setup({
  -- Standard
  provider = "groq",
  storage = { enabled = true },

  -- Communauté (Core Drive 1)
  community = { enabled = true },

  -- Progression (Core Drive 2)
  progression = {
    enabled = true,
    auto_track = true,               -- Tracker automatiquement les actions
    show_xp_notifications = true,    -- "+10 XP (Concept appris)"
    track_daily_streak = true,       -- Compteur de jours consécutifs
  },
})
```

## 🚀 Utilisation

### 1. Voir votre progression globale

```vim
:LLearnProgress
```

**Affiche** :
- Niveau actuel et XP total
- Barre de progression vers le prochain niveau
- Statistiques (concepts appris, maîtrisés, révisions)
- Streak quotidien
- Skill trees par langage
- Challenges complétés et disponibles

#### Exemple d'affichage

```markdown
# 📈 Votre Progression

## ⭐ Niveau Global

**Niveau:** 7
**XP Total:** 1950
**Prochain niveau:** 600 / 1000 XP (60%)

[████████████░░░░░░░░] 60%

## 📊 Statistiques

📚 **Concepts appris:** 42
🏆 **Concepts maîtrisés:** 12
✅ **Révisions complétées:** 87
🔥 **Streak actuel:** 5 jour(s)

## 🌳 Skill Trees (Par Langage)

### JAVASCRIPT
- **Niveau:** 2
- **XP:** 180
- **Concepts:** 18

### RUST
- **Niveau:** 2
- **XP:** 120
- **Concepts:** 12

### PYTHON
- **Niveau:** 1
- **XP:** 70
- **Concepts:** 7

## 🏆 Challenges Complétés (4/7)

- ✅ **Premiers Pas** (2025-01-10)
- ✅ **Apprenant Dévoué** (2025-01-14)
- ✅ **Guerrier des Révisions** (2025-01-15)
- ✅ **Polyglotte** (2025-01-16)

## 🎯 Challenges Disponibles

- [ ] **Maître du Savoir**
  - Apprendre 100 concepts
  - Récompense: 500 XP

- [ ] **Champion du Streak**
  - Maintenir un streak de 7 jours
  - Récompense: 100 XP

- [ ] **Artisan Maître**
  - Atteindre le niveau Master sur 5 concepts
  - Récompense: 300 XP
```

### 2. Voir votre Skill Tree

```vim
:LLearnSkillTree
```

**Affiche** :
- Arbre de compétences pour chaque langage
- Visualisation ASCII des niveaux débloqués
- Progression vers les techniques avancées

#### Exemple d'affichage

```markdown
# 🌳 Skill Tree

Arbre de compétences par langage de programmation

## JAVASCRIPT - Niveau 2

✅     🌱 Débutant
🔒     🌿 Intermédiaire (niveau 5 requis)
🔒     🌳 Avancé (niveau 10 requis)
🔒     🏆 Expert (niveau 15 requis)
🔒     👑 Master (niveau 20 requis)

**Stats:**
- Concepts appris: 18
- XP: 180

## RUST - Niveau 2

✅     🌱 Débutant
🔒     🌿 Intermédiaire (niveau 5 requis)
🔒     🌳 Avancé (niveau 10 requis)
🔒     🏆 Expert (niveau 15 requis)
🔒     👑 Master (niveau 20 requis)

**Stats:**
- Concepts appris: 12
- XP: 120
```

### 3. Voir les Mastery Levels de vos concepts

```vim
:LLearnMastery
```

**Affiche** :
- Tous vos concepts groupés par niveau de maîtrise
- Nombre de révisions pour chaque concept

#### Exemple d'affichage

```markdown
# 🎓 Mastery Levels

## 👑 Master (3)

- **fibonacci-recursion** (23 révisions)
- **rust-ownership** (21 révisions)
- **react-hooks-useeffect** (20 révisions)

## 📙 Expert (5)

- **binary-search** (15 révisions)
- **quicksort-algorithm** (12 révisions)
- **python-decorators** (11 révisions)
- **javascript-closures** (10 révisions)
- **sql-joins** (10 révisions)

## 📗 Proficient (8)

- **git-rebase** (7 révisions)
- **docker-compose** (6 révisions)
...

## 📘 Competent (15)

- **regex-basics** (3 révisions)
- **css-flexbox** (2 révisions)
...

## 🌱 Novice (11)

- **webpack-config** (1 révision)
- **typescript-generics** (0 révisions)
...
```

## 💰 Système XP

### Gains d'XP par action

| Action | XP | Notes |
|--------|----|----|
| **Apprendre un concept** | +10 XP | À chaque sauvegarde |
| **Révision facile** (4-5) | +5 XP | Concept bien maîtrisé |
| **Révision moyenne** (3) | +8 XP | Effort modéré |
| **Révision difficile** (1-2) | +12 XP | Plus de récompense pour l'effort |
| **Perfect Review Streak** | +20 XP | 5 révisions parfaites (4-5) d'affilée |
| **Daily Streak Bonus** | +5 XP × jours | Bonus croissant par jour |
| **Partager un concept** | +15 XP | Contribution communautaire |
| **Challenges** | +50 à 500 XP | Selon la difficulté |

### Niveaux et seuils XP

| Niveau | XP Requis | Total XP | Déblocages |
|--------|-----------|----------|------------|
| 1 | 0 | 0 | - |
| 2 | 100 | 100 | - |
| 3 | 250 | 250 | - |
| 4 | 500 | 500 | - |
| 5 | 850 | 850 | Techniques avancées |
| 10 | 4100 | 4100 | Mode Expert |
| 15 | 11300 | 11300 | Techniques de Master |
| 20 | 20000 | 20000 | Statut de Légende |

### Exemple de progression

```
Jour 1: Apprendre 5 concepts
→ 5 × 10 XP = 50 XP
→ Niveau 1 → toujours

Jour 2: Apprendre 3 concepts + réviser 5 concepts (moyenne)
→ (3 × 10) + (5 × 8) = 70 XP
→ Daily streak bonus: +10 XP (jour 2)
→ Total: 80 XP (130 total)
→ Niveau 1 → Niveau 2 (100 XP atteint)
→ Challenge "Premiers Pas" complété: +50 XP
→ Total: 180 XP

Jour 3: Réviser 10 concepts (5 parfaites d'affilée)
→ 5 révisions parfaites: 5 × 20 XP = 100 XP (perfect streak)
→ 5 autres révisions: 5 × 8 XP = 40 XP
→ Daily streak bonus: +15 XP (jour 3)
→ Total: 155 XP (335 total)
→ Niveau 2 → Niveau 3 (250 XP atteint)
```

## 🎓 Mastery Levels par Concept

### Progression de la maîtrise

| Niveau | Nom | Révisions requises | Icon |
|--------|-----|-------------------|------|
| 1 | Novice | 0-1 | 🌱 |
| 2 | Competent | 2-4 | 📘 |
| 3 | Proficient | 5-9 | 📗 |
| 4 | Expert | 10-19 | 📙 |
| 5 | Master | 20+ | 👑 |

### Comment ça fonctionne ?

1. **Nouveau concept** : Automatiquement niveau 1 (Novice)
2. **Première révision** : Toujours Novice
3. **2e révision** : → Competent (notification)
4. **5e révision** : → Proficient (notification)
5. **10e révision** : → Expert (notification)
6. **20e révision** : → Master (notification)

### Exemple de progression

```
fibonacci-recursion:
- Jour 1: Appris → Novice (0 révisions)
- Jour 2: 1ère révision → Novice (1 révision)
- Jour 5: 2e révision → Competent 📘 (2 révisions)
- Jour 12: 3e, 4e révisions → Competent (4 révisions)
- Jour 19: 5e révision → Proficient 📗 (5 révisions)
- Jour 33: 10e révision → Expert 📙 (10 révisions)
- Jour 63: 20e révision → Master 👑 (20 révisions)
```

## 🌳 Skill Trees par Langage

### Progression par langage

Chaque langage a son propre arbre de compétences :
- **XP séparée** : Apprendre du JavaScript donne de l'XP JavaScript
- **Niveaux séparés** : Niveau 5 en Rust, niveau 10 en JavaScript
- **Visualisation claire** : Voir sa progression par techno

### Niveaux de skill tree

| Niveau | Titre | XP requis | Symbole |
|--------|-------|-----------|---------|
| 1-4 | Débutant | 0-400 | 🌱 |
| 5-9 | Intermédiaire | 500-900 | 🌿 |
| 10-14 | Avancé | 1000-1400 | 🌳 |
| 15-19 | Expert | 1500-1900 | 🏆 |
| 20+ | Master | 2000+ | 👑 |

### Calcul XP par langage

**Important** : Seuls les concepts appris ajoutent de l'XP au skill tree. Les révisions n'ajoutent PAS d'XP au langage (elles ajoutent seulement de l'XP globale).

```lua
-- À chaque concept appris dans un langage
skill_tree[language].xp += 10  -- XP par concept appris uniquement
skill_tree[language].level = floor(skill_tree[language].xp / 100) + 1
```

**Formule complète** :
```
XP_langage = nombre_concepts_appris × 10
Niveau_langage = floor(XP_langage / 100) + 1
```

**Exemple** :
- 18 concepts JavaScript appris = 18 × 10 = 180 XP JavaScript
- Niveau JavaScript = floor(180 / 100) + 1 = 2 (Débutant)

**Note** : Les révisions augmentent votre XP globale et vos mastery levels, mais pas l'XP du langage.

## 🏆 Challenges Disponibles

### Liste complète

| Challenge | Description | Condition | Récompense |
|-----------|-------------|-----------|------------|
| 🌱 **Premiers Pas** | Apprendre 5 concepts | 5+ concepts | 50 XP |
| 📚 **Apprenant Dévoué** | Apprendre 25 concepts | 25+ concepts | 200 XP |
| 🎓 **Maître du Savoir** | Apprendre 100 concepts | 100+ concepts | 500 XP |
| ⚔️ **Guerrier des Révisions** | Compléter 50 révisions | 50+ révisions | 150 XP |
| 🔥 **Champion du Streak** | Streak de 7 jours | 7+ jours consécutifs | 100 XP |
| 🌍 **Polyglotte** | 5 langages différents | 5+ langages dans skill trees | 250 XP |
| 👑 **Artisan Maître** | 5 concepts au niveau Master | 5+ concepts maîtrisés | 300 XP |

### Débloquage automatique

Les challenges sont **automatiquement vérifiés** :
- Après chaque concept appris
- Après chaque révision
- Le système notifie : "🏆 Challenge complété : Premiers Pas (+50 XP)"
- XP ajoutée automatiquement

## 🔥 Daily Streak

### Fonctionnement

- **Compteur de jours consécutifs** où vous apprenez ou révisez
- **Bonus XP croissant** : +5 XP × nombre de jours
- **Réinitialisation si manqué** : Retour à 1 si vous sautez un jour

### Calcul du streak

```
Aujourd'hui: 2025-01-15
Dernière activité: 2025-01-14
→ Consécutif! streak = streak + 1

Aujourd'hui: 2025-01-15
Dernière activité: 2025-01-13
→ Manqué! streak = 1 (reset)
```

### Bonus XP

| Streak | Bonus par action |
|--------|-----------------|
| Jour 1 | +5 XP |
| Jour 2 | +10 XP |
| Jour 3 | +15 XP |
| Jour 7 | +35 XP |
| Jour 30 | +150 XP |

**Exemple** :
```
Streak de 7 jours:
- Apprendre un concept: 10 XP + 35 XP (bonus) = 45 XP !
- Réviser un concept: 8 XP + 35 XP (bonus) = 43 XP !
```

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnProgress` | Afficher progression, XP, niveaux, challenges |
| `:LLearnSkillTree` | Afficher l'arbre de compétences par langage |
| `:LLearnMastery` | Afficher les mastery levels des concepts |

## 💡 Pourquoi Development & Accomplishment fonctionne ?

### Psychologie de la Progression

Le **Core Drive 2: Development & Accomplishment** du framework Octalysis crée une motivation forte grâce à :

1. **Progression visible** : Barres de progression, niveaux, XP
2. **Sentiment de compétence** : "Je deviens meilleur"
3. **Défis équilibrés** : Ni trop faciles, ni trop difficiles
4. **Feedback immédiat** : "+10 XP" après chaque action
5. **Maîtrise progressive** : Novice → Master

### Exemples de messages motivants

```
+10 XP (Concept appris)

🎉 LEVEL UP ! Niveau 5 atteint !
🔓 Accès aux techniques avancées débloqué !

+20 XP (Perfect Review Streak x5) 🔥

🏆 Challenge complété : Polyglotte (+250 XP)

📈 Mastery: fibonacci-recursion → Expert 📙

🔥 Streak de 7 jours ! +35 XP bonus par action !
```

## 🎯 Workflow Recommandé

### Pour maximiser l'XP

```lua
progression = {
  enabled = true,
  auto_track = true,            -- Tracker automatiquement
  show_xp_notifications = true, -- Voir chaque gain d'XP
  track_daily_streak = true,    -- Activer les bonus de streak
}
```

**Workflow** :
1. **Apprendre quotidiennement** → Maintenir le streak
2. **Réviser intelligemment** → Chercher les perfect streaks (5× 4-5 d'affilée)
3. **Diversifier les langages** → Débloquer "Polyglotte"
4. **Viser les challenges** → Regarder `:LLearnProgress` pour les objectifs

### Pour la maîtrise profonde

```lua
progression = {
  enabled = true,
  auto_track = true,
}
```

**Workflow** :
1. **Focus sur quelques concepts** → Les réviser jusqu'à Master (20+)
2. **Consulter `:LLearnMastery`** → Voir progression vers Master
3. **Viser "Artisan Maître"** → 5 concepts Master = 300 XP

## 📊 Structure des Données

Les données de progression sont stockées dans `~/.local/share/nvim/lazylearn_progression.json` :

```json
{
  "total_xp": 1950,
  "level": 7,
  "xp_in_level": 600,
  "concepts_learned": 42,
  "concepts_mastered": 12,
  "reviews_completed": 87,
  "perfect_reviews_streak": 0,
  "daily_streak": 5,
  "last_activity_date": "2025-01-15",
  "skill_trees": {
    "javascript": {
      "xp": 180,
      "level": 2,
      "concepts": 18
    },
    "rust": {
      "xp": 120,
      "level": 2,
      "concepts": 12
    }
  },
  "challenges": [
    {
      "id": "first_steps",
      "name": "Premiers Pas",
      "completed_date": 1705334400
    }
  ],
  "mastery_levels": {
    "fibonacci-recursion": {
      "level": 5,
      "reviews": 23,
      "last_review": 1705334400
    }
  }
}
```

## 🚀 Exemples d'Utilisation

### Scenario 1 : Première semaine

**Jour 1** :
```vim
" Apprendre 5 concepts JavaScript
V<leader>h  " 5 fois

+10 XP (Concept appris)
+10 XP (Concept appris)
...
🏆 Challenge complété : Premiers Pas (+50 XP)
Total: 100 XP
🎉 LEVEL UP ! Niveau 2 atteint !
```

**Jour 2** :
```vim
" Apprendre 3 concepts + réviser 5
:LLearnReview

+10 XP (Concept appris)
...
+8 XP (Révision)
...
Daily streak bonus: +10 XP
```

**Jour 7** :
```vim
:LLearnProgress

🔥 Streak actuel: 7 jour(s)
🏆 Challenge complété : Champion du Streak (+100 XP)
```

### Scenario 2 : Polyglotte

```vim
" Apprendre des concepts dans différents langages
" JavaScript, Rust, Python, Go, TypeScript

:LLearnSkillTree
" Voir progression dans chaque langage

🏆 Challenge complété : Polyglotte (+250 XP)
🎉 LEVEL UP ! Niveau 10 atteint !
🔓 Mode Expert débloqué !
```

### Scenario 3 : Maîtrise profonde

```vim
" Réviser fibonacci-recursion 20 fois sur plusieurs semaines

📈 Mastery: fibonacci-recursion → Competent 📘
📈 Mastery: fibonacci-recursion → Proficient 📗
📈 Mastery: fibonacci-recursion → Expert 📙
📈 Mastery: fibonacci-recursion → Master 👑

:LLearnMastery
" Voir dans la section Master
```

## ❓ FAQ

### Comment gagner de l'XP rapidement ?

- **Apprendre de nouveaux concepts** : 10 XP chacun
- **Maintenir un long streak** : +5 XP × jours
- **Perfect Review Streak** : 20 XP au lieu de 5
- **Compléter des challenges** : 50-500 XP

### Les niveaux sont-ils infinis ?

Non, maximum niveau 20. Au-delà de 20000 XP, vous restez niveau 20 (statut de Légende).

### Puis-je perdre de l'XP ?

Non, l'XP est toujours gagné, jamais perdu. Seul le streak peut se réinitialiser.

### Comment atteindre Master sur un concept ?

Réviser le concept 20+ fois. Utilisez le système de révision espacée pour optimiser.

### Les skill trees sont-ils bloquants ?

Non, c'est purement informatif et motivant. Vous pouvez apprendre n'importe quel concept à tout moment.

### Puis-je modifier les valeurs d'XP ?

Oui, éditez `lua/lazylearn/progression.lua` et modifiez la table `M.XP_VALUES`.

## 🎨 Personnalisation

### Changer les valeurs d'XP

```lua
-- Dans lua/lazylearn/progression.lua
M.XP_VALUES = {
  learn_concept = 20,  -- Au lieu de 10
  review_easy = 10,    -- Au lieu de 5
  perfect_review = 50, -- Au lieu de 20
  daily_streak = 10,   -- Au lieu de 5
}
```

### Ajouter des challenges custom

```lua
-- Dans lua/lazylearn/progression.lua
table.insert(M.CHALLENGES, {
  id = "my_challenge",
  name = "Mon Challenge",
  description = "Faire quelque chose",
  condition = function(data)
    return data.concepts_learned >= 42
  end,
  reward_xp = 1000,
})
```

### Désactiver certaines notifications

```lua
progression = {
  enabled = true,
  show_xp_notifications = false,  -- Pas de "+10 XP"
  auto_track = true,
}
```

## 🔮 Idées Futures

### Leaderboards
- Comparer sa progression avec d'autres utilisateurs
- Top 10 par langage

### Badges visuels
- Icônes spéciales pour chaque niveau
- Avatars débloquables

### Quests
- Mini-quêtes quotidiennes
- "Apprendre 3 concepts Rust aujourd'hui"

### Prestige System
- Reset au niveau 1 avec bonus permanent
- Étoiles de prestige

## 🌟 Conclusion

Le système de progression de LazyLearn transforme l'apprentissage en une expérience **gamifiée et motivante**. Chaque action compte, chaque révision vous rapproche de la maîtrise.

> **"Level up your skills, one concept at a time"**

---

**Progressez, maîtrisez, devenez légendaire !** 🚀
