# ⏰ Système de Rareté - LazyLearn.nvim

**Scarcity & Impatience** : Ce que vous ne pouvez pas avoir immédiatement devient plus désirable !

## 🎯 Vision

Créer de l'urgence et de la motivation par la **rareté du temps** et des **récompenses exclusives**. Les challenges limités dans le temps et le contenu débloquable créent un sentiment de "je ne veux pas manquer ça".

> "Ce qui est rare est précieux. Ce qui est limité dans le temps est urgent."

## ✨ Fonctionnalités

### ⏰ Challenges Quotidiens (24h)
- **3 challenges par jour** avec réinitialisation à minuit
- **Compte à rebours visible** : Temps restant en heures/minutes
- **Récompenses XP + Tokens** : Gagnez des 🎫 pour débloquer du contenu
- **Progression trackée** : Voir votre avancement en temps réel

### 🗓️ Challenges Hebdomadaires
- **2 challenges par semaine** (reset le lundi)
- **Objectifs plus ambitieux** : 10 concepts, 3 langages
- **Récompenses amplifiées** : +150-200 XP, 3-5 🎫
- **Timer hebdomadaire** : Jours restants avant expiration

### 🔒 Contenu Exclusif
- **4 contenus débloquables** avec conditions strictes
- **Double barrière** : Niveau requis + Tokens requis
- **Prompts avancés** : Pack d'expert (niveau 10, 10 🎫)
- **Badges rares** : Collectionneur exclusif (niveau 15, 15 🎫)
- **Voix de mentor custom** : Socrate, Feynman (niveau 5, 8 🎫)
- **File prioritaire** : Algorithme optimisé (niveau 8, 12 🎫)

### 🎫 Système de Tokens
- **Monnaie rare** : Gagnée uniquement via challenges limités
- **Économie fermée** : Impossible de "farmer" indéfiniment
- **Choix stratégiques** : Que débloquer en premier ?
- **Sentiment de progrès** : Accumulation visible

## 📦 Configuration

```lua
require("lazylearn").setup({
  scarcity = {
    enabled = true,                    -- ✅ Activer système de rareté
    enable_daily_challenges = true,    -- Challenges quotidiens
    enable_weekly_challenges = true,   -- Challenges hebdomadaires
    enable_exclusive_content = true,   -- Contenu débloquable
    enable_countdown_timers = true,    -- Timers visibles
    auto_check_challenges = true,      -- Vérification automatique
  },
})
```

## 🚀 Utilisation

### 1. Voir les Challenges Quotidiens

```vim
:LLearnDaily
```

**Affiche** :
- ⏳ Temps restant : 7h 23m
- 📚 Apprenant du Jour (Progression: 2/3)
- 🔄 Réviseur Quotidien (Progression: 1/5)
- ⭐ Perfection du Jour (Progression: 0/3)
- 🎫 Tokens disponibles

#### Exemple d'affichage

```markdown
# ⏰ Challenges Quotidiens

⏳ **Temps restant:** 7h 23m

---

⏰ **📚 Apprenant du Jour**
   Apprendre 3 concepts aujourd'hui
   Progression: 2/3
   Récompense: +50 XP, +1 🎫

✅ **🔄 Réviseur Quotidien**
   Compléter 5 révisions aujourd'hui
   Progression: 5/5
   Récompense: +40 XP, +1 🎫

⏰ **⭐ Perfection du Jour**
   3 révisions parfaites (4-5) aujourd'hui
   Progression: 1/3
   Récompense: +60 XP, +2 🎫

---

🎫 **Tokens disponibles:** 8
```

### 2. Voir les Challenges Hebdomadaires

```vim
:LLearnWeekly
```

**Affiche** :
- ⏳ Temps restant : 3 jour(s) 14h
- 🗺️ Explorateur de la Semaine (3 langages)
- 👑 Maître de la Semaine (10 concepts)
- Progression trackée

#### Exemple d'affichage

```markdown
# 🗓️ Challenges Hebdomadaires

⏳ **Temps restant:** 3 jour(s) 14h

---

✅ **🗺️ Explorateur de la Semaine**
   Apprendre dans 3 langages différents
   Progression: 3/3
   Récompense: +150 XP, +3 🎫

🗓️ **👑 Maître de la Semaine**
   Atteindre 10 concepts appris cette semaine
   Progression: 7/10
   Récompense: +200 XP, +5 🎫

---

🎫 **Tokens disponibles:** 11
```

### 3. Voir le Contenu Exclusif

```vim
:LLearnExclusive
```

**Affiche** :
- 🎫 Tokens disponibles
- ⭐ Niveau actuel
- Liste du contenu (🔒 Verrouillé, 🔓 Disponible, ✅ Débloqué)

#### Exemple d'affichage

```markdown
# 🔒 Contenu Exclusif

🎫 **Tokens disponibles:** 11
⭐ **Niveau actuel:** 8

---

🔓 **🎯 Prompts Avancés** (DISPONIBLE)
   Pack de 5 prompts d'expert
   Coût: 10 🎫 | Niveau requis: 10
   💡 Utilisez :LLearnUnlock advanced_prompts

🔓 **🎭 Voix de Mentor Custom** (DISPONIBLE)
   Personnalisez le style de réponse de l'IA
   Coût: 8 🎫 | Niveau requis: 5
   💡 Utilisez :LLearnUnlock custom_mentor_voice

🔒 **⚡ File de Révision Prioritaire** (VERROUILLÉ)
   Algorithme optimisé pour réviser
   Coût: 12 🎫 | Niveau requis: 8 (1 🎫 restants)

🔒 **🏆 Badge Collectionneur Rare** (VERROUILLÉ)
   Badge exclusif visible sur profil
   Coût: 15 🎫 | Niveau requis: 15 (7 niveaux restants, 4 🎫 restants)

```

### 4. Débloquer du Contenu

**Via menu interactif** :
```vim
:LLearnUnlock
" Menu de sélection avec contenu disponible uniquement
```

**Directement par ID** :
```vim
:LLearnUnlock custom_mentor_voice
🎉 Contenu débloqué : 🎭 Voix de Mentor Custom !
```

## ⏰ Challenges Quotidiens

### Liste complète

| Challenge | Description | Target | Récompense |
|-----------|-------------|--------|------------|
| 📚 **Apprenant du Jour** | Apprendre 3 concepts | 3 concepts | +50 XP, +1 🎫 |
| 🔄 **Réviseur Quotidien** | Compléter 5 révisions | 5 révisions | +40 XP, +1 🎫 |
| ⭐ **Perfection du Jour** | 3 révisions parfaites (4-5) | 3 parfaites | +60 XP, +2 🎫 |

### Fonctionnement

- **Réinitialisation** : Tous les jours à minuit (00:00)
- **Timer visible** : Heures et minutes restantes
- **Complétion automatique** : Notifié dès qu'objectif atteint
- **Une fois par jour** : Chaque challenge complétable une seule fois

**Exemple de notification** :
```
⏰ Challenge quotidien complété : 📚 Apprenant du Jour (+50 XP, +1 🎫)
```

## 🗓️ Challenges Hebdomadaires

### Liste complète

| Challenge | Description | Target | Récompense |
|-----------|-------------|--------|------------|
| 🗺️ **Explorateur de la Semaine** | 3 langages différents | 3 langages | +150 XP, +3 🎫 |
| 👑 **Maître de la Semaine** | 10 concepts appris | 10 concepts | +200 XP, +5 🎫 |

### Fonctionnement

- **Réinitialisation** : Tous les lundis à 00:00
- **Timer visible** : Jours et heures restants
- **Progression cumulative** : Stats tracées sur toute la semaine
- **Récompenses amplifiées** : Plus d'XP et tokens qu'en quotidien

## 🔒 Contenu Exclusif

### Catalogue complet

| Contenu | Description | Niveau | Tokens | Rareté |
|---------|-------------|--------|--------|--------|
| 🎯 **Prompts Avancés** | Pack de 5 prompts d'expert | 10 | 10 🎫 | ⭐⭐⭐ |
| 🏆 **Badge Collectionneur** | Badge exclusif profil | 15 | 15 🎫 | ⭐⭐⭐⭐ |
| 🎭 **Voix Mentor Custom** | Style IA personnalisé | 5 | 8 🎫 | ⭐⭐ |
| ⚡ **File Prioritaire** | Algo révision optimisé | 8 | 12 🎫 | ⭐⭐⭐ |

### Conditions de déblocage

**Double barrière** :
1. **Niveau minimum** : Atteindre le niveau requis
2. **Tokens suffisants** : Accumuler les tokens via challenges

**Économie fermée** :
- Tokens uniquement via challenges quotidiens/hebdomadaires
- Maximum **~10 tokens/semaine** (3 daily + 1 weekly + bonus)
- **Choix stratégiques** : Impossible de tout débloquer rapidement

### Exemple de progression

```
Semaine 1:
- Quotidiens: 7 jours × 1-2 tokens = 10 tokens
- Hebdomadaire: Explorateur (+3 tokens)
- Total: 13 tokens
→ Peut débloquer: Voix Mentor Custom (8 tokens)
→ Reste: 5 tokens

Semaine 2:
- Quotidiens: +10 tokens (total: 15 tokens)
- Niveau 10 atteint !
→ Peut débloquer: Prompts Avancés (10 tokens)
→ Reste: 5 tokens

Semaine 3-4:
- Accumulation pour File Prioritaire (12 tokens requis)
```

## 🎫 Système de Tokens

### Gains de tokens

| Source | Tokens gagnés | Fréquence |
|--------|---------------|-----------|
| Apprenant du Jour | +1 🎫 | Quotidien |
| Réviseur Quotidien | +1 🎫 | Quotidien |
| Perfection du Jour | +2 🎫 | Quotidien |
| Explorateur Semaine | +3 🎫 | Hebdomadaire |
| Maître Semaine | +5 🎫 | Hebdomadaire |

**Maximum théorique par semaine** :
- Quotidiens : 7 jours × 4 tokens/jour = **28 tokens**
- Hebdomadaires : **8 tokens**
- **Total : ~36 tokens/semaine** (si TOUT est complété)

**Réaliste** : ~10-15 tokens/semaine

### Dépenses stratégiques

**Early game** (niveau 5-10) :
1. **Voix Mentor Custom** (8 🎫) - Impact immédiat
2. **Prompts Avancés** (10 🎫) - Accélère apprentissage

**Mid game** (niveau 10-15) :
3. **File Prioritaire** (12 🎫) - Optimise révisions

**Late game** (niveau 15+) :
4. **Badge Collectionneur** (15 🎫) - Prestige

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnDaily` | Afficher challenges quotidiens avec timer |
| `:LLearnWeekly` | Afficher challenges hebdomadaires avec timer |
| `:LLearnExclusive` | Voir le contenu exclusif disponible |
| `:LLearnUnlock` | Menu interactif pour débloquer du contenu |
| `:LLearnUnlock <id>` | Débloquer directement par ID |

## 💡 Pourquoi Scarcity & Impatience fonctionne ?

### Psychologie de la Rareté

Le **Core Drive 6: Scarcity & Impatience** du framework Octalysis crée une motivation forte grâce à :

1. **FOMO** (Fear Of Missing Out) : "Je dois compléter ce challenge avant minuit !"
2. **Rareté des récompenses** : Les tokens ne peuvent pas être "farmés" infiniment
3. **Choix stratégiques** : Impossible d'avoir tout, il faut choisir
4. **Urgence temporelle** : Le compte à rebours crée de l'action immédiate
5. **Sentiment d'exclusivité** : Débloquer du contenu rare = prestige

### Mécaniques psychologiques

#### 1. Deadline Effect (Effet de date limite)
```
Sans deadline: "Je peux le faire plus tard"
Avec deadline: "Il reste 2h, je DOIS le faire maintenant !"
```

#### 2. Loss Aversion (Aversion à la perte)
```
"Si je ne fais pas ce challenge aujourd'hui, je PERDS 2 tokens"
→ Plus motivant que "Si je fais ce challenge, je GAGNE 2 tokens"
```

#### 3. Sunk Cost Fallacy (Coût irrécupérable)
```
"J'ai déjà 2/3 concepts appris, autant finir pour avoir le token !"
```

#### 4. Appointment Dynamics (Dynamique de rendez-vous)
```
"Je dois revenir demain pour les nouveaux challenges quotidiens"
→ Engagement régulier
```

## 🎯 Workflow Recommandé

### Pour maximiser les tokens

```lua
scarcity = {
  enabled = true,
  auto_check_challenges = true,  -- Notifications automatiques
}
```

**Routine quotidienne** :
1. **Matin** : Vérifier `:LLearnDaily` pour voir les objectifs
2. **Apprendre** : 3+ concepts pour "Apprenant du Jour"
3. **Réviser** : 5+ révisions pour "Réviseur Quotidien"
4. **Parfait** : 3 révisions 4-5 pour "Perfection du Jour"
5. **Soir** : Vérifier complétion avant minuit

**Routine hebdomadaire** :
1. **Lundi matin** : Vérifier `:LLearnWeekly` pour nouveaux challenges
2. **Diversifier** : Apprendre 3+ langages différents
3. **Volume** : 10+ concepts sur la semaine
4. **Dimanche soir** : Sprint final avant reset

### Pour débloquer stratégiquement

**Semaine 1-2** :
- Focus : Quotidiens uniquement
- Objectif : Accumuler 8-10 tokens
- Déblocage : Voix Mentor Custom (impact immédiat)

**Semaine 3-4** :
- Focus : Quotidiens + Hebdomadaires
- Objectif : Atteindre niveau 10 + 10 tokens
- Déblocage : Prompts Avancés

**Semaine 5-6** :
- Focus : Accumulation pour File Prioritaire
- Objectif : 12 tokens

**Semaine 7+** :
- Focus : Late game, Badge Collectionneur
- Objectif : Niveau 15 + 15 tokens

## 📊 Structure des Données

Les données de rareté sont stockées dans `~/.local/share/nvim/lazylearn_scarcity.json` :

```json
{
  "tokens": 8,
  "daily_challenges": [
    {
      "id": "daily_learner",
      "completed_date": 1705334400
    }
  ],
  "weekly_challenges": [],
  "last_daily_reset": "2025-01-15",
  "last_weekly_reset": "2025-01-13",
  "exclusive_unlocked": ["custom_mentor_voice"],
  "daily_stats": {
    "concepts_learned": 2,
    "reviews_completed": 5,
    "perfect_reviews": 1
  },
  "weekly_stats": {
    "concepts_learned": 12,
    "languages_used": ["javascript", "rust", "python"]
  }
}
```

## 🔧 IDs du Contenu Exclusif

Pour débloquer via `:LLearnUnlock <id>` :

- `advanced_prompts` - Prompts Avancés
- `rare_badge_collector` - Badge Collectionneur Rare
- `custom_mentor_voice` - Voix de Mentor Custom
- `priority_review_queue` - File de Révision Prioritaire

## ❓ FAQ

### Les challenges expirent-ils vraiment ?

Oui ! Les challenges quotidiens réinitialisent à minuit, les hebdomadaires le lundi. Si vous ne complétez pas, vous perdez l'opportunité.

### Puis-je acheter des tokens ?

Non. Les tokens ne peuvent être obtenus QUE via les challenges. C'est une économie fermée pour maintenir la rareté.

### Que se passe-t-il si je manque un jour ?

Vous perdez les challenges quotidiens de ce jour. Pas de rattrapage possible. Cela crée l'urgence !

### Puis-je débloquer tout le contenu exclusif ?

Oui, mais cela prendra plusieurs semaines. C'est intentionnel pour créer un sentiment de progression à long terme.

### Les timers sont-ils locaux ou serveur ?

Locaux (basés sur l'horloge système). En mode production, utiliser un serveur pour éviter la triche.

## 🎨 Personnalisation

### Ajouter des challenges custom

```lua
-- Dans lua/lazylearn/scarcity.lua
table.insert(M.DAILY_CHALLENGES, {
  id = "my_daily_challenge",
  name = "🚀 Mon Challenge",
  description = "Faire quelque chose de cool",
  target = 5,
  reward_xp = 100,
  reward_tokens = 3,
})
```

### Ajouter du contenu exclusif

```lua
-- Dans lua/lazylearn/scarcity.lua
table.insert(M.EXCLUSIVE_CONTENT, {
  id = "super_power",
  name = "⚡ Super Pouvoir",
  description = "Un pouvoir incroyable",
  unlock_level = 20,
  unlock_tokens = 20,
  unlocked = false,
})
```

### Modifier l'économie des tokens

```lua
-- Challenges plus généreux
reward_tokens = 5,  -- Au lieu de 1-2

-- Contenu moins cher
unlock_tokens = 5,  -- Au lieu de 8-15
```

## 🌟 Conclusion

Le système de rareté transforme l'apprentissage en **expérience urgente et précieuse**. Les deadlines créent de l'action, les tokens rares créent des choix stratégiques.

> **"Time is scarce. Make it count."** - La devise de LazyLearn Scarcity

---

**Ne manquez pas les challenges d'aujourd'hui !** ⏰
