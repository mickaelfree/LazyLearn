# 💎 Système de Possession - LazyLearn.nvim

**Ownership & Possession** : Possédez, accumulez et valorisez votre bibliothèque de connaissances !

## 🎯 Vision

Transformez vos concepts en **véritables possessions**. Chaque concept est une pièce de votre collection personnelle, avec sa valeur, sa rareté et son histoire.

> "Ce que vous possédez, vous en prenez soin."

## ✨ Fonctionnalités

### 💎 Knowledge Vault (Coffre de Connaissances)
- **Valeur totale** de votre bibliothèque
- **Stats détaillées** : XP accumulé, révisions, concepts
- **Répartition par rareté** : Common, Rare, Epic, Legendary
- **Top 5 concepts** les plus précieux

### 🎴 Concept Cards (Cartes à Collectionner)
- **5 raretés** : ⚪ Common → 🟡 Legendary
- **Stats sur chaque carte** : Révisions, vues, XP, maîtrise
- **Visualisation ASCII** type carte de collection
- **Évolution automatique** : Plus vous révisez, plus c'est rare !

### 📚 Collections Thématiques
- **Créez vos collections** : "Algorithmes", "React Advanced", etc.
- **Objectifs de collection** : 10/15 concepts complétés
- **Barres de progression** visuelles
- **Complétion rewarding** : Achievement au 100%

### ⚡ Personnalisation
- **Notes personnelles** sur chaque concept
- **Tags custom** pour organisation
- **Système de favoris** ⭐
- **Sentiment d'appropriation** total

### 🏆 Achievements de Collection
- 📚 **Bibliothécaire** : 100 concepts possédés
- 🔵 **Chasseur de Raretés** : 10+ concepts Rare
- 🟡 **Maître Collectionneur** : 5+ Legendary
- ✅ **Collection Complète** : Finir une collection

## 📦 Configuration

```lua
require("lazylearn").setup({
  ownership = {
    enabled = true,                   -- ✅ Activer possession
    enable_collections = true,        -- Collections thématiques
    enable_concept_cards = true,      -- Cartes à collectionner
    enable_customization = true,      -- Personnalisation
    auto_check_achievements = true,   -- Vérif achievements
  },
})
```

## 🚀 Utilisation

### 1. Voir votre Coffre

```vim
:LLearnVault
```

Affiche :
- 💎 Valeur totale de votre bibliothèque
- 📊 Stats (concepts, XP, révisions)
- 🎴 Répartition par rareté
- ⭐ Top 5 concepts précieux

### 2. Créer une Collection

```vim
:LLearnCreateCollection
" Nom: "Algorithmes Avancés"
" Target: 15
✅ Collection créée !
```

### 3. Ajouter à une Collection

```vim
:LLearnAddToCollection
" Sélectionner collection
" Sélectionner concept
✨ Ajouté !
```

### 4. Voir vos Collections

```vim
:LLearnCollections
```

Affiche toutes vos collections avec progression.

### 5. Personnaliser un Concept

```vim
:LLearnCustomize
" Sélectionner concept
" Options : Note, Tag, Favori, Voir carte
```

### 6. Voir vos Favoris

```vim
:LLearnFavorites
```

## 🎴 Système de Rareté

| Rareté | Icon | Révisions | XP/révision |
|--------|------|-----------|-------------|
| Common | ⚪ | 0-2 | 10 |
| Uncommon | 🟢 | 3-6 | 10 |
| Rare | 🔵 | 7-14 | 10 |
| Epic | 🟣 | 15-24 | 10 |
| Legendary | 🟡 | 25+ | 10 |

**Évolution automatique** : Plus vous révisez, plus c'est rare !

## 🎴 Exemple de Carte

```
╔════════════════════════════════════════╗
║  🟡 fibonacci-recursion                ║
║                                        ║
║  Rareté: Legendary                     ║
║  Maîtrise: Master                      ║
║                                        ║
║  📊 Stats:                             ║
║    • Révisions: 27                     ║
║    • Vues: 45                          ║
║    • XP gagné: 270                     ║
║                                        ║
║  Obtenue le: 2025-01-10                ║
╚════════════════════════════════════════╝
```

## 💰 Calcul de Valeur

**Valeur d'un concept** = (Révisions × 10) + (Vues × 2)

**Valeur totale bibliothèque** = (Total concepts × 10) + Total XP

## 📚 Exemple de Collection

```markdown
## Algorithmes Avancés

**Progression:** 12/15 (80%)

[████████████████░░░░] 80%

**Concepts:**
1. fibonacci-recursion
2. quicksort-algorithm
3. binary-search-tree
...
```

## ⚙️ Commandes

| Commande | Description |
|----------|-------------|
| `:LLearnVault` | Voir votre coffre de connaissances |
| `:LLearnCreateCollection` | Créer une collection |
| `:LLearnAddToCollection` | Ajouter à une collection |
| `:LLearnCollections` | Voir toutes vos collections |
| `:LLearnCustomize` | Personnaliser un concept |
| `:LLearnFavorites` | Voir vos favoris |

## 💡 Pourquoi Ownership fonctionne ?

Le **Core Drive 4: Ownership & Possession** crée une motivation forte via :

1. **Sentiment de possession** : "C'est À MOI"
2. **Accumulation gratifiante** : Voir grandir sa collection
3. **Valorisation** : Chaque concept a une valeur
4. **Personnalisation** : Appropriation complète
5. **Collection complete** : Vouloir "tout avoir"

## 🌟 Conclusion

Le système de possession transforme l'apprentissage en **collection précieuse**. Vos concepts sont des trésors que vous accumulez et faites évoluer.

> **"Build, Collect, Own"** - La devise de LazyLearn Ownership

---

**Construisez votre empire de connaissances !** 🚀
