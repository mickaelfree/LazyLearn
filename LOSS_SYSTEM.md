# 💔 Système de Perte et d'Évitement - LazyLearn.nvim

**Loss & Avoidance** : La peur de perdre ce que vous avez construit est un puissant motivateur !

## 🎯 Vision

Créer de la motivation par l'**évitement de la perte**. Votre streak, vos concepts maîtrisés, votre progrès - tout cela peut être perdu si vous n'agissez pas. Cette peur positive vous pousse à rester engagé.

> "On est plus motivé à éviter de perdre qu'à gagner quelque chose."

## ✨ Fonctionnalités

### ⚠️ Avertissements de Déclin de Concepts
- **3 niveaux de risque** : Warning (7j), High (14j), Critical (30j)
- **Tracking automatique** : Détection des concepts non révisés
- **Visualisation claire** : 🟡 Avertissement, 🟠 Risque élevé, 🔴 Critique
- **Calcul de perte** : XP investi en danger

### 🔥 Protection de Streak
- **Streak en danger** : Alertes si risque de perte
- **Protections achetables** : 3 🎫 pour 1 protection
- **Utilisation stratégique** : Sauver votre streak d'un jour manqué
- **Timer visible** : Heures restantes avant perte

### 📉 Rapport de Pertes Potentielles
- **Vue d'ensemble** : Tout ce qui est en danger
- **Calcul d'impact** : XP potentiellement perdu
- **Priorisation** : Concepts critiques en premier
- **Action immédiate** : Liens directs vers révisions

### 💎 Visualisation de l'Investissement (Sunk Cost)
- **XP total** : Tout ce que vous avez accumulé
- **Concepts appris** : Votre bibliothèque
- **Temps investi** : Estimation en heures
- **Valeur du streak** : Bonus cumulés

### 🚨 Notifications FOMO
- **Au démarrage** : Alertes automatiques
- **Streak urgent** : Si < 6h restantes
- **Concepts critiques** : Déclin imminent
- **Révisions dues** : Rappels pour 5+ concepts

## 📦 Configuration

```lua
require("lazylearn").setup({
  loss = {
    enabled = true,                      -- ✅ Activer système de perte
    enable_decay_warnings = true,        -- Avertissements de déclin
    enable_streak_protection = true,     -- Protections achetables
    enable_fomo_notifications = true,    -- Notifications FOMO
    enable_sunk_cost_display = true,     -- Affichage investissement
    show_warnings_on_startup = true,     -- Avertir au démarrage
  },
})
```

## 🚀 Utilisation

### 1. Voir les Concepts en Déclin

```vim
:LLearnDecay
```

**Affiche** :
- Total de concepts à risque
- Groupés par niveau (🔴 Critique, 🟠 Élevé, 🟡 Avertissement)
- Jours depuis dernière révision
- Nombre de révisions investies

#### Exemple d'affichage

```markdown
# ⚠️ Concepts en Déclin

**Total à risque:** 8

---

## 🔴 CRITIQUE (2)

**Déclin sévère ! Révisez IMMÉDIATEMENT pour éviter la perte.**

- **fibonacci-recursion** (+32 jours)
  Révisions: 15 | Risque de perte imminente

- **rust-ownership** (+35 jours)
  Révisions: 23 | Risque de perte imminente

## 🟠 RISQUE ÉLEVÉ (3)

**Déclin en cours. Révisez bientôt.**

- **react-hooks** (+18 jours)
  Révisions: 8

...

## 🟡 AVERTISSEMENT (3)

**Révisez cette semaine pour maintenir votre maîtrise.**

- **binary-search** (+9 jours)
  Révisions: 5

...

---

💡 Utilisez `:LLearnReview` pour réviser vos concepts maintenant !
```

### 2. Vérifier l'État du Streak

```vim
:LLearnStreak
```

#### Exemples d'affichage

**Streak en danger** :
```markdown
# 🔥 État du Streak

⚠️ **STREAK EN DANGER !**

**Streak actuel:** 12 jour(s)
**Temps restant:** 5 heure(s)

🚨 **Vous allez PERDRE votre streak si vous n'agissez pas !**

**Options:**
1. Apprenez 1 concept ou révisez maintenant
2. Utilisez une protection de streak (2 disponible(s))
   Commande: `:LLearnProtectStreak`

---

**Protections disponibles:** 2
**Pertes évitées (total):** 3
```

**Streak sécurisé** :
```markdown
# 🔥 État du Streak

✅ **STREAK SÉCURISÉ**

**Streak actuel:** 12 jour(s)
Vous avez appris ou révisé aujourd'hui !

---

**Protections disponibles:** 2
**Pertes évitées (total):** 3
```

### 3. Acheter une Protection de Streak

```vim
:LLearnBuyProtection
```

**Coût** : 3 🎫

**Confirmation** :
```
🛡️ Protection de streak achetée ! (+3 protection(s))
```

### 4. Utiliser une Protection de Streak

```vim
:LLearnProtectStreak
```

**Effet** :
- Sauve votre streak pour aujourd'hui
- Simule une activité
- Consomme 1 protection

**Confirmation** :
```
🛡️ Streak protégé ! Votre streak de 12 jours est sauvé pour aujourd'hui.
```

### 5. Voir les Pertes Potentielles

```vim
:LLearnLosses
```

#### Exemple d'affichage

```markdown
# 📉 Rapport de Pertes Potentielles

⚠️ **Vous risquez de perdre du progrès !**

---

## 📚 Concepts en Déclin

**Nombre:** 8 concept(s)
**XP investi:** ~240 XP
**Statut:** ⚠️ Risque de perte de maîtrise

💡 Action: `:LLearnDecay` pour voir la liste

## 🔥 Streak en Danger

**Valeur du streak:** ~60 XP
**Statut:** 🚨 Perte imminente

💡 Action: Apprenez 1 concept ou utilisez `:LLearnProtectStreak`

---

### 💔 Perte Totale Potentielle

**~300 XP** en danger de perte

🚨 **N'attendez pas ! Agissez maintenant pour éviter de perdre votre progrès.**
```

### 6. Visualiser Votre Investissement

```vim
:LLearnInvestment
```

#### Exemple d'affichage

```markdown
# 💎 Votre Investissement d'Apprentissage

**Tout ce que vous avez construit jusqu'à maintenant.**

---

## ⭐ XP Total

**1950 XP** accumulé
Niveau 7 atteint

## 📚 Concepts

**42 concepts** appris
**87 révisions** complétées

## 🔥 Streak

**12 jour(s)** consécutifs
Valeur: ~60 XP en bonus

## ⏱️ Temps Investi

**~8.5 heures** d'apprentissage

---

💪 **Vous avez investi beaucoup d'efforts. Ne laissez pas ce progrès se perdre !**

⚠️ Utilisez `:LLearnLosses` pour voir ce qui est en danger.
```

## ⚠️ Système de Déclin de Concepts

### Seuils de déclin

| Jours sans révision | Niveau de risque | Statut | Action recommandée |
|---------------------|------------------|--------|-------------------|
| 7-13 jours | 🟡 Warning | Début de déclin | Réviser cette semaine |
| 14-29 jours | 🟠 High Risk | Déclin actif | Réviser cette semaine ! |
| 30+ jours | 🔴 Critical | Déclin sévère | RÉVISER IMMÉDIATEMENT |

### Comment ça fonctionne ?

**Tracking automatique** :
- Chaque concept a une `last_review` date
- Calcul automatique : `days_since_review = now - last_review`
- Comparaison aux seuils (7j, 14j, 30j)

**Calcul de la perte** :
```
XP investi = review_count × 8 (moyenne par révision)
```

**Exemple** :
```
Concept: fibonacci-recursion
- Révisions: 15
- XP investi: 15 × 8 = 120 XP
- Dernière révision: +32 jours
- Statut: 🔴 CRITIQUE (120 XP en danger)
```

### Pourquoi 7/14/30 jours ?

Basé sur la **Courbe d'Oubli d'Ebbinghaus** :
- 7 jours : Début de l'oubli significatif
- 14 jours : 50% d'oubli sans révision
- 30 jours : Perte majeure de rétention

## 🔥 Système de Protection de Streak

### Fonctionnement

**Achat** :
- Coût : 3 🎫 par protection
- Illimité (si vous avez les tokens)
- Stocké pour utilisation future

**Utilisation** :
- Consomme 1 protection
- Simule une activité pour aujourd'hui
- Sauve le streak de la perte
- Utilisable uniquement si streak en danger

### Économie

**Comparaison** :
- Reconstruire un streak de 12 jours : 12 jours d'effort
- 1 Protection : 3 🎫 (obtenue en 1-2 jours de challenges)
- **ROI** : 1-2 jours d'effort vs 12 jours perdus

**Décision stratégique** :
```
Streak de 3 jours: Pas rentable (mieux vaut recommencer)
Streak de 10+ jours: Très rentable (sauver coûte moins cher)
Streak de 30+ jours: CRITIQUE (ne jamais perdre)
```

### Limitations

**Pas de spam** :
- 1 utilisation maximum par jour
- Ne peut pas "farmer" le streak avec protections

**Cooldown implicite** :
- Streak protected aujourd'hui
- Demain, il faut vraiment apprendre/réviser

## 📉 Rapport de Pertes Potentielles

### Calculs

**Concepts à risque** :
```lua
potential_xp_loss = sum(review_count × 8 for each at_risk_concept)
```

**Valeur du streak** :
```lua
streak_value = daily_streak × 5 (bonus XP par jour)
```

**Total** :
```lua
total_loss = potential_xp_loss + streak_value
```

### Interprétation

| Perte totale | Gravité | Action |
|--------------|---------|--------|
| 0-50 XP | 🟢 Faible | Situation normale |
| 50-200 XP | 🟡 Modérée | Réviser bientôt |
| 200-500 XP | 🟠 Élevée | Réviser cette semaine |
| 500+ XP | 🔴 Critique | AGIR IMMÉDIATEMENT |

## 💎 Sunk Cost (Coût Irrécupérable)

### Psychologie

**Effet du Sunk Cost** :
> "J'ai déjà investi 8 heures dans LazyLearn. Je ne veux pas perdre ce progrès !"

→ Motivation à continuer pour protéger l'investissement passé

### Calcul de l'investissement

**XP Total** : Directement depuis progression
**Concepts** : Nombre total appris
**Révisions** : Nombre total complétées
**Streak** : Jours consécutifs × 5 XP
**Temps** : Estimation : `(concepts × 5min + révisions × 2min)`

### Efficacité

**Timing stratégique** :
- Montrer l'investissement quand risque de perte
- Créer le "regret anticipé" de perdre

## 🚨 Notifications FOMO

### Déclenchement automatique

**Au démarrage de Neovim** (si `show_warnings_on_startup = true`) :
1. Vérifier streak (si < 6h restantes)
2. Vérifier concepts critiques (30+ jours)
3. Vérifier révisions dues (5+ concepts)

### Exemples de messages

```
🚨 URGENT ! Votre streak de 12 jours sera perdu dans 5h !

🔴 2 concept(s) en déclin critique ! Risque de perte imminente.

⏰ 8 concepts en attente de révision. Ne laissez pas votre maîtrise décliner !
```

### Fréquence

- **1 fois au démarrage** : Éviter le spam
- **Conditions spécifiques** : Seulement si vraiment critique
- **Actionnable** : Toujours avec lien vers solution

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnDecay` | Afficher les concepts en déclin |
| `:LLearnStreak` | Voir l'état du streak avec alertes |
| `:LLearnBuyProtection` | Acheter une protection de streak (3🎫) |
| `:LLearnProtectStreak` | Utiliser une protection de streak |
| `:LLearnLosses` | Rapport complet des pertes potentielles |
| `:LLearnInvestment` | Visualiser votre investissement total |

## 💡 Pourquoi Loss & Avoidance fonctionne ?

### Psychologie de la Perte

Le **Core Drive 8: Loss & Avoidance** du framework Octalysis crée une motivation forte grâce à :

1. **Loss Aversion** (Kahneman & Tversky) : On pèse les pertes 2-2.5× plus que les gains
2. **Sunk Cost Fallacy** : "J'ai déjà investi, je ne peux pas abandonner maintenant"
3. **Fear of Missing Out (FOMO)** : Peur de rater/perdre quelque chose
4. **Status Quo Bias** : Préférence pour maintenir l'état actuel
5. **Regret Anticipation** : Éviter le regret futur de la perte

### Mécaniques psychologiques

#### 1. Loss Aversion (Kahneman)
```
Gain de 100 XP: Plaisir = 100
Perte de 100 XP: Douleur = -225

→ La douleur de perdre est 2.25× plus forte
→ Motivation asymétrique en faveur de l'évitement
```

#### 2. Sunk Cost Fallacy
```
"J'ai passé 8 heures à apprendre ces concepts..."
"Je ne peux pas laisser ces 15 révisions être perdues..."
→ Engagement continu pour protéger l'investissement passé
```

#### 3. Endowment Effect (Thaler)
```
Concept que vous POSSÉDEZ: Valeur subjective × 3
Concept que vous pourriez apprendre: Valeur objective

→ Ce que vous avez déjà vaut plus dans votre esprit
→ Forte motivation à le garder
```

#### 4. Prospect Theory
```
Certitude de perte (streak cassé demain): Hautement motivant
Probabilité de gain (nouveau concept): Moins motivant

→ Les menaces certaines créent l'action immédiate
```

## 🎯 Workflow Recommandé

### Pour éviter les pertes

```lua
loss = {
  enabled = true,
  show_warnings_on_startup = true,  -- Alertes quotidiennes
  enable_fomo_notifications = true,
}
```

**Routine quotidienne** :
1. **Matin** : Ouvrir Neovim → Voir notifications FOMO
2. **Vérifier streak** : `:LLearnStreak` si alerte
3. **Agir immédiatement** : Apprendre 1 concept OU utiliser protection
4. **Check hebdomadaire** : `:LLearnDecay` pour concepts à risque

**En cas de voyage/absence** :
1. **Avant de partir** : `:LLearnBuyProtection` (acheter 3-5 protections)
2. **Chaque jour absent** : `:LLearnProtectStreak` (sauver streak)
3. **Au retour** : Réviser concepts critiques immédiatement

### Priorisation des risques

**Ordre de priorité** :
1. 🔴 Concepts critiques (30+ jours) → IMMÉDIAT
2. 🚨 Streak < 6h → URGENT
3. 🟠 Concepts High Risk (14-29 jours) → Cette semaine
4. 🟡 Concepts Warning (7-13 jours) → Cette semaine/mois

## 📊 Structure des Données

Les données de perte/évitement sont stockées dans `~/.local/share/nvim/lazylearn_loss.json` :

```json
{
  "streak_protections_available": 2,
  "streak_protected_dates": ["2025-01-10", "2025-01-15"],
  "concepts_at_risk": [],
  "warnings_dismissed": [],
  "total_losses_avoided": 3
}
```

## ❓ FAQ

### Les concepts déclinent-ils vraiment en maîtrise ?

Non, c'est un système motivationnel. Le "déclin" est un avertissement, pas une perte réelle de données. Mais psychologiquement, ça reflète la réalité de l'oubli.

### Puis-je acheter des protections infinies ?

Oui, si vous avez les tokens. Mais l'économie rend ça difficile (3🎫 chacune, max ~10-15🎫/semaine).

### Que se passe-t-il si je perds mon streak ?

Le compteur reset à 0. Vous recommencez. Mais toutes vos données (XP, concepts, niveaux) restent ! Seul le bonus quotidien est perdu.

### Les avertissements sont-ils trop anxiogènes ?

C'est intentionnel (Core Drive 8 utilise la "tension"). Mais vous pouvez désactiver :
```lua
loss = { show_warnings_on_startup = false }
```

### Comment désactiver complètement le système ?

```lua
loss = { enabled = false }
```

## 🎨 Personnalisation

### Modifier les seuils de déclin

```lua
-- Dans lua/lazylearn/loss.lua
M.MASTERY_DECAY = {
  warning_days = 14,   -- Au lieu de 7
  decay_days = 21,     -- Au lieu de 14
  critical_days = 45,  -- Au lieu de 30
}
```

### Changer le coût des protections

```lua
-- Dans lua/lazylearn/loss.lua
M.STREAK_PROTECTION_COST = 5  -- Au lieu de 3
```

### Désactiver certaines notifications

```lua
loss = {
  enabled = true,
  enable_fomo_notifications = false,  -- Pas de FOMO au démarrage
  show_warnings_on_startup = false,
}
```

## ⚖️ Équilibre Éthique

**Gamification responsable** :

✅ **Bon usage** :
- Rappels de révisions basés sur SRS scientifique
- Protéger investissement réel (temps/effort)
- Créer urgence pour action bénéfique

⚠️ **Attention** :
- Ne pas créer d'anxiété excessive
- Permettre de désactiver facilement
- Jamais de vraie "punition" (pas de perte de données)

**Notre approche** :
> Utiliser Loss & Avoidance pour **encourager**, pas manipuler. L'utilisateur garde le contrôle total.

## 🌟 Conclusion

Le système de perte transforme votre progrès en **actif précieux à protéger**. La peur de perdre ce que vous avez construit crée un engagement durable.

> **"Protect what you've built"** - La devise de LazyLearn Loss & Avoidance

---

**Votre progrès est précieux. Ne le laissez pas disparaître !** 💎
