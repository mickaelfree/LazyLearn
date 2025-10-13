# 👥 Système Social - LazyLearn.nvim

**Social Influence & Relatedness** : Comparez-vous, apprenez ensemble et trouvez des mentors !

## 🎯 Vision

Transformez l'apprentissage solitaire en **expérience sociale**. Voyez où vous vous situez, inspirez-vous des meilleurs et apprenez en communauté.

> "Nous sommes motivés par ce que font les autres."

## ✨ Fonctionnalités

### 🏆 Leaderboard Global
- **Classement en temps réel** : Votre rang parmi tous les apprenants
- **Top 10 affiché** : Médailles 🥇🥈🥉 pour le podium
- **Percentile** : Top X% de la communauté
- **Badges spéciaux** : TOP 3, TOP 10, TOP 10%

### 📊 Comparaison avec les Pairs
- **XP Total** : Vous vs moyenne communauté
- **Concepts Appris** : Combien par rapport aux autres ?
- **Streak Quotidien** : Votre régularité vs moyenne
- **Différences visuelles** : ✅ Au-dessus / 📈 En dessous

### 🔥 Trending Concepts (Social Proof)
- **Top 5 concepts** appris cette semaine
- **Nombre d'apprenants** par concept
- **Indicateurs de tendance** : 🔥 Hot, ⬆️ Rising, 📈 Growing

### 👨‍🏫 Système de Mentorship
- **3 mentors disponibles** : rustacean_pro, js_ninja, py_wizard
- **Spécialités affichées** : Rust & Performance, JavaScript & React, etc.
- **Suivi de mentors** : Voir leur progression et concepts
- **Liste de mentors suivis** avec dates

### 👥 Groupes d'Étude
- **Créez vos groupes** : "Algorithmes Avancés", "React Masters", etc.
- **Description et objectifs** pour chaque groupe
- **Nombre de membres** (simulé)
- **Challenges de groupe** (optionnel)

### 🏆 Achievements Sociaux
- 👑 **Elite Learner** : Atteindre le Top 10
- 🌟 **Top 1%** : Être dans le top 1% de la communauté
- 🦋 **Social Butterfly** : Suivre 5 mentors

## 📦 Configuration

```lua
require("lazylearn").setup({
  social = {
    enabled = true,                    -- ✅ Activer système social
    enable_leaderboards = true,        -- Classements
    enable_peer_comparison = true,     -- Comparaison avec pairs
    enable_mentorship = true,          -- Système de mentors
    enable_study_groups = true,        -- Groupes d'étude
    enable_trending = true,            -- Concepts populaires
    simulate_community = true,         -- Simuler (false en prod)
  },
})
```

## 🚀 Utilisation

### 1. Voir le Leaderboard

```vim
:LLearnLeaderboard
```

Affiche :
- 🏆 Votre position : #5 / 11
- 📊 Percentile : Top 54%
- 🥇🥈🥉 Top 10 apprenants avec stats

### 2. Comparer vos Stats

```vim
:LLearnCompare
```

Compare :
- 💎 XP Total (vous vs moyenne)
- 📚 Concepts Appris
- 🔥 Streak Quotidien
- 📍 Votre classement

### 3. Concepts Populaires

```vim
:LLearnTrending
```

Montre les 5 concepts les plus appris cette semaine avec nombre d'apprenants.

### 4. Suivre un Mentor

```vim
:LLearnFollowMentor
" Sélectionner mentor dans menu
✅ Vous suivez maintenant rustacean_pro
```

### 5. Voir vos Mentors

```vim
:LLearnFollowing
```

Liste tous vos mentors avec spécialité et date de suivi.

### 6. Créer un Groupe

```vim
:LLearnCreateGroup
" Nom: Rust Ownership Masters
" Description: Maîtriser l'ownership en Rust
👥 Groupe créé !
```

### 7. Voir vos Groupes

```vim
:LLearnGroups
```

## 📊 Données Simulées

### Utilisateurs du Leaderboard

| Rank | Username | XP | Concepts | Streak |
|------|----------|-----|----------|--------|
| 🥇 1 | rustacean_pro | 8500 | 127 | 45 |
| 🥈 2 | js_ninja | 7200 | 98 | 32 |
| 🥉 3 | py_wizard | 6800 | 115 | 28 |
| ... | ... | ... | ... | ... |

### Moyennes Communauté

- **XP moyen** : 4800
- **Concepts moyens** : 75
- **Streak moyen** : 18 jours

### Mentors Disponibles

1. **rustacean_pro** - Rust & Performance (127 concepts)
2. **js_ninja** - JavaScript & React (98 concepts)
3. **py_wizard** - Python & ML (115 concepts)

## 🎯 Exemple de Leaderboard

```markdown
# 🏆 Leaderboard Global

**Votre position:** #5 / 11
**Percentile:** Top 54%

---

## Top 10 Apprenants

🥇 **rustacean_pro**
   XP: 8500 | Concepts: 127 | Streak: 45

🥈 **js_ninja**
   XP: 7200 | Concepts: 98 | Streak: 32

🥉 **py_wizard**
   XP: 6800 | Concepts: 115 | Streak: 28

  4. **code_master**
   XP: 6200 | Concepts: 89 | Streak: 41

  5. **YOU** ← VOUS
   XP: 5000 | Concepts: 42 | Streak: 12
```

## 📈 Exemple de Comparaison

```markdown
# 📊 Comparaison avec la Communauté

## XP Total

**Vous:** 5000 XP
**Moyenne:** 4800 XP
✅ **+200 XP** au-dessus de la moyenne (104%)

## Concepts Appris

**Vous:** 42 concepts
**Moyenne:** 75 concepts
📚 **33 concepts** en dessous

## Streak Quotidien

**Vous:** 12 jours
**Moyenne:** 18 jours
⏰ Continuez votre streak !

---

**Classement:** #5 (Top 54%)
```

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnLeaderboard` | Afficher le classement global |
| `:LLearnCompare` | Comparer vos stats avec la communauté |
| `:LLearnTrending` | Voir les concepts populaires |
| `:LLearnFollowMentor` | Suivre un mentor |
| `:LLearnFollowing` | Voir vos mentors suivis |
| `:LLearnCreateGroup` | Créer un groupe d'étude |
| `:LLearnGroups` | Afficher vos groupes |

## 💡 Pourquoi Social Influence fonctionne ?

Le **Core Drive 5: Social Influence & Relatedness** crée une motivation forte via :

1. **Comparaison sociale** : "Où suis-je par rapport aux autres ?"
2. **Social proof** : "Si 347 personnes apprennent ce concept, il doit être important"
3. **Mentorship** : Apprendre de ceux qui réussissent
4. **Belonging** : Faire partie d'un groupe, d'une communauté
5. **Compétition saine** : Vouloir progresser pour monter dans le classement
6. **Collaboration** : Groupes d'étude et apprentissage collectif

### Psychologie du Classement

- **Top 3** : Prestige extrême, fort engagement
- **Top 10** : Élite visible, motivation à rester
- **Top 10%** : Au-dessus de la moyenne, fierté
- **En dessous** : Aspiration à monter, "growth mindset"

### Le pouvoir du Social Proof

> "347 personnes apprennent fibonacci-recursion cette semaine"

→ FOMO (Fear Of Missing Out)
→ Validation du choix d'apprentissage
→ Normalisation de l'effort

## 🌐 Mode Production

Pour une vraie communauté (pas simulée) :

1. **Backend nécessaire** : API REST pour leaderboards réels
2. **Authentification** : Système de comptes utilisateurs
3. **Base de données** : PostgreSQL / MongoDB pour stats
4. **WebSockets** : Mises à jour en temps réel
5. **Modération** : Système anti-triche

```lua
-- En production
social = {
  simulate_community = false,  -- ⚠️ Désactiver simulation
  api_url = "https://api.lazylearn.dev/social",
  api_key_env = "LAZYLEARN_API_KEY",
}
```

## 🔒 Données Locales (Mode Simulé)

En mode simulé (par défaut), toutes les données sont **locales** :

- `~/.local/share/nvim/lazylearn_social.json`
  - `following[]` : Mentors suivis
  - `groups[]` : Groupes créés
  - `social_stats` : Rang, percentile

Les utilisateurs simulés sont **hardcodés** dans `social.lua`.

## 🌟 Conclusion

Le système social transforme l'apprentissage en **expérience collective**. Vous n'êtes plus seul face au code : vous faites partie d'une communauté mondiale d'apprenants.

> **"Learn Together, Grow Together"** - La devise de LazyLearn Social

---

**Rejoignez la communauté !** 🚀
