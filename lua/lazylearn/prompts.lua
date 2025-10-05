-- LazyLearn.nvim - Prompts Module
-- Author: LazyLearn Contributors
-- License: MIT

local M = {}
local config = require("lazylearn.config")

-- Prompts intégrés (provenant de votre fichier original)
M.builtin = {
  -- TECHNIQUES MNÉMONIQUES AVANCÉES
  {
    id = "chunking",
    name = "Chunking Mnémonique",
    icon = "🧩",
    category = "mnemonic",
    description = "Découpage mémoriel optimisé",
    prompt = [[Décompose ce concept en chunks mnémoniques :
1. Identifie 5-7 unités d'information distinctes (chunks)
2. Organise ces chunks de manière hiérarchique
3. Crée des connections entre chunks utilisant des motifs ou associations
4. Suggère des phrases mnémoniques courtes pour chaque chunk
5. Propose une stratégie de révision espacée pour ces chunks

Le concept à chunker est : ]],
  },
  {
    id = "memory_palace",
    name = "Palais de Mémoire",
    icon = "🏛️",
    category = "mnemonic",
    description = "Technique de mémorisation spatiale",
    prompt = [[Crée un palais de mémoire pour ce concept de développement :
1. Définis 5-7 "pièces" distinctes représentant les aspects clés du concept
2. Pour chaque pièce, associe:
   - Une image vive et sensorielle
   - Un objet ou meuble distinct pour chaque sous-concept
   - Une action ou interaction mémorable
3. Crée un parcours logique reliant ces pièces
4. Ajoute des éléments insolites pour renforcer la mémorisation
5. Explique comment "parcourir" ce palais pour rappeler le concept

Le concept à mémoriser est : ]],
  },
  {
    id = "dual_coding",
    name = "Double Encodage",
    icon = "🔄",
    category = "mnemonic",
    description = "Encodage visuel et verbal",
    prompt = [[Encode ce concept visuellement et verbalement :
1. Représentation textuelle concise (5-7 phrases clés)
2. Représentation visuelle (décrite en détail)
3. Connections explicites entre éléments visuels et textuels
4. Narration combinant les aspects visuels et verbaux
5. Suggestions pour renforcer l'encodage multisensoriel

Le concept à encoder est : ]],
  },
  {
    id = "elaborative_interrogation",
    name = "Interrogation Élaborative",
    icon = "❓",
    category = "mnemonic",
    description = "Comprendre par les pourquoi",
    prompt = [[Pose les questions "pourquoi" essentielles :
1. Pourquoi ce concept fonctionne comme il le fait?
2. Pourquoi a-t-il été conçu de cette manière?
3. Pourquoi est-il structuré ainsi?
4. Pourquoi cette approche plutôt qu'une alternative?
5. Pourquoi est-il important de bien comprendre ce concept?
6. Pourquoi ce concept s'intègre-t-il avec d'autres de cette façon?
7. Fournir des réponses détaillées à chaque question

Le concept à interroger est : ]],
  },
  {
    id = "desirable_difficulty",
    name = "Difficulté Désirable",
    icon = "🔍",
    category = "mnemonic",
    description = "Apprentissage par effort productif",
    prompt = [[Applique la technique de difficulté désirable à ce concept :
1. Version complexifiée délibérément :
   - Réécris le concept avec 30% plus de complexité
   - Introduis des abstractions supplémentaires
   - Ajoute des contraintes artificielles

2. Récupération forcée :
   - Crée 3-5 questions délibérément difficiles
   - Formule des problèmes qui semblent insolubles au premier abord
   - Propose des situations d'application avec informations manquantes

3. Résolution guidée :
   - Fournis des indices minimaux pour surmonter les obstacles
   - Décompose le chemin de résolution en étapes non-évidentes
   - Explique pourquoi cette difficulté renforce l'apprentissage

Le concept à apprendre par difficulté désirable est : ]],
  },
  {
    id = "inverted_feynman",
    name = "Feynman Inversé",
    icon = "🧠",
    category = "mnemonic",
    description = "Du simple au complexe et retour",
    prompt = [[Applique la technique Feynman inversée à ce concept :
1. Simplification extrême :
   - Explique d'abord ce concept comme à un enfant de 10 ans
   - Utilise uniquement des mots simples et des analogies concrètes
   - Évite tout jargon technique

2. Complexification progressive :
   - Réintroduis progressivement la complexité en 4 niveaux
   - À chaque niveau, identifie les lacunes de l'explication précédente
   - Marque explicitement les points où la simplicité devient trompeuse

3. Connexion finale :
   - Réconcilie la version simple et la version complexe
   - Crée un modèle mental hybride qui préserve l'intuition sans sacrifier la précision
   - Identifie les "ancres mentales" clés pour basculer entre niveaux de compréhension

Le concept à expliquer par méthode Feynman inversée est : ]],
  },
  {
    id = "interleaving",
    name = "Interleaving Conceptuel",
    icon = "🧵",
    category = "mnemonic",
    description = "Connexions inter-domaines",
    prompt = [[Applique la technique d'interleaving conceptuel à ce concept :
1. Identification des concepts connexes :
   - Identifie 3-4 concepts qui semblent non-reliés mais partagent des structures profondes
   - Trouve des domaines d'application radicalement différents
   - Sélectionne des concepts à différents niveaux d'abstraction

2. Tissage cognitif :
   - Alterne entre ces concepts par blocs de 3-5 phrases
   - Crée des transitions délibérément abruptes entre domaines
   - Force des connexions non-évidentes entre les concepts

3. Synthèse transversale :
   - Extrais les patterns communs qui émergent de ce tissage
   - Formule des principes métacognitifs applicables à tous les domaines
   - Crée une "carte de transfert" pour appliquer ce concept dans des contextes inattendus

Le concept principal pour l'interleaving est : ]],
  },
  {
    id = "timed_retrieval",
    name = "Récupération Temporisée",
    icon = "⏱️",
    category = "mnemonic",
    description = "Protocole de révision programmée",
    prompt = [[Crée un protocole de récupération temporisée pour ce concept :
1. Points de rappel immédiats (après 1 minute) :
   - 3 questions courtes exigeant un rappel précis de détails clés
   - Force la récupération sans indices

2. Points de rappel à court terme (après 10 minutes) :
   - 2 problèmes d'application demandant une manipulation du concept
   - Fournir 30% des informations nécessaires

3. Points de rappel à moyen terme (après 1 jour) :
   - 1 problème de synthèse exigeant une reconstruction complète du concept
   - Ajouter une contrainte non présente dans l'apprentissage initial

4. Points de rappel à long terme (après 1 semaine) :
   - 1 problème d'intégration demandant de combiner ce concept avec un nouveau
   - Demander une application dans un domaine non couvert initialement

Le concept pour la récupération temporisée est : ]],
  },
  {
    id = "multisensory_coding",
    name = "Multi-Sensoriel",
    icon = "🎨",
    category = "mnemonic",
    description = "Encodage par tous les sens",
    prompt = [[Encode ce concept dans multiples modalités sensorielles :
1. Encodage visuo-spatial :
   - Crée une représentation visuelle abstraite (décrite en détail)
   - Associe des couleurs spécifiques aux composantes clés
   - Définis des relations spatiales explicites entre éléments

2. Encodage auditif-rythmique :
   - Développe une phrase mnémonique avec un rythme spécifique
   - Crée des associations sonores pour les éléments clés
   - Propose un pattern de "lecture à voix haute" avec emphases

3. Encodage kinesthésique :
   - Conçois des gestes physiques représentant le concept
   - Crée une "chorégraphie cognitive" séquentielle
   - Décris les sensations physiques associées

4. Encodage émotionnel :
   - Associe des états émotionnels spécifiques à des aspects du concept
   - Crée une "histoire émotionnelle" suivant une progression
   - Établis des ancres émotionnelles pour les points critiques

Le concept à encoder multi-sensoriellement est : ]],
  },

  -- ANALYSE DE PRINCIPES
  {
    id = "pareto",
    name = "20/80 Analyse",
    icon = "⚖️",
    category = "principles",
    description = "Points critiques et impact maximal",
    prompt = [[Analyse selon le principe de Pareto (20/80) pour ce concept :
1. Points critiques (20%) :
   - Quels sont les éléments essentiels ?
   - Quelles parties demandent le plus d'attention ?
   - Où faut-il concentrer ses efforts ?

2. Impact maximal (80%) :
   - Quelles optimisations auront le plus d'impact ?
   - Quelles parties du code sont les plus utilisées ?
   - Où sont les gains rapides possibles ?

3. Priorités d'apprentissage :
   - Quels concepts maîtriser en premier ?
   - Quelles compétences développer prioritairement ?
   - Quels patterns sont les plus importants ?

Le concept à analyser est : ]],
  },
  {
    id = "core_principles",
    name = "Principes Fondamentaux",
    icon = "🎯",
    category = "principles",
    description = "Bases essentielles",
    prompt = [[Extrais les principes fondamentaux de ce concept :
1. Quels sont les axiomes de base ?
2. Quelles sont les règles invariables ?
3. Quels patterns se répètent ?
4. Quelles sont les exceptions importantes ?
Le concept à analyser est : ]],
  },
  {
    id = "concept_map",
    name = "Carte Conceptuelle",
    icon = "🗺️",
    category = "principles",
    description = "Visualiser les relations",
    prompt = [[Décompose ce concept en créant une carte mentale :
1. Concept central
2. Principes fondamentaux
3. Relations clés
4. Applications pratiques
5. Concepts connexes
Le concept à analyser est : ]],
  },

  -- MODÈLES MENTAUX
  {
    id = "meta_programming_model",
    name = "Méta-Modèles",
    icon = "🔬",
    category = "mental_models",
    description = "Modèles mentaux fondamentaux",
    prompt = [[Analyse ce concept avec ces modèles mentaux fondamentaux :
1. Modèle de flux de données:
   - Comment les données circulent-elles?
   - Quelles transformations subissent-elles?
   - Où sont les points de décision?

2. Modèle d'abstraction en couches:
   - Quelles sont les couches d'abstraction?
   - Comment interagissent-elles?
   - Quelles responsabilités à chaque niveau?

3. Modèle d'états et transitions:
   - Quels sont les états possibles?
   - Comment se produisent les transitions?
   - Quelles sont les invariants?

4. Modèle de composition/décomposition:
   - Comment ce concept peut-il être décomposé?
   - Comment peut-il être recombiné?
   - Quelles sont les unités minimales fonctionnelles?

Le concept à analyser est : ]],
  },
  {
    id = "debugging_models",
    name = "Modèles de Débogage",
    icon = "🐞",
    category = "mental_models",
    description = "Modèles pour résolution de problèmes",
    prompt = [[Applique ces modèles mentaux de débogage :
1. Modèle de cause à effet:
   - Quelles sont les relations causales?
   - Comment isoler les facteurs individuels?
   - Comment confirmer les hypothèses?

2. Modèle de regression:
   - Quand ce problème est-il apparu?
   - Quelles modifications ont pu l'introduire?
   - Comment revenir à un état fonctionnel?

3. Modèle de divide-and-conquer:
   - Comment bisectionner le problème?
   - Quelles parties peuvent être exclues?
   - Comment réduire l'espace de recherche?

4. Modèle d'anomalie systémique:
   - S'agit-il d'un problème isolé ou systémique?
   - Existe-t-il d'autres occurrences similaires?
   - Y a-t-il un pattern sous-jacent?

Le problème à déboguer est : ]],
  },
  {
    id = "architecture_models",
    name = "Modèles d'Architecture",
    icon = "🏗️",
    category = "mental_models",
    description = "Pensée architecturale",
    prompt = [[Analyse cette architecture avec ces modèles mentaux :
1. Modèle de contraintes:
   - Quelles contraintes définissent le système?
   - Comment ces contraintes façonnent-elles les solutions?
   - Comment optimiser dans ces limites?

2. Modèle de couplage et cohésion:
   - Où sont les points de couplage?
   - Comment mesurer et améliorer la cohésion?
   - Quels changements amélioreraient la structure?

3. Modèle de surface d'attaque:
   - Quelles sont les vulnérabilités potentielles?
   - Comment réduire la surface d'attaque?
   - Quels mécanismes de défense en profondeur?

4. Modèle d'évolution:
   - Comment ce système évoluera-t-il?
   - Quelles parties changeront le plus?
   - Comment faciliter les changements futurs?

L'architecture à analyser est : ]],
  },

  -- APPRENTISSAGE PROGRESSIF
  {
    id = "analogies",
    name = "Analogies Quotidiennes",
    icon = "🏠",
    category = "progressive",
    description = "Comprendre par comparaison",
    prompt = [[Explique ce concept à travers des analogies de la vie quotidienne.
Ne donne pas d'exemple technique, mais utilise des comparaisons avec :
1. Des situations quotidiennes
2. Des objets familiers
3. Des expériences communes
Le concept à expliquer est : ]],
  },
  {
    id = "socratic",
    name = "Questions Socratiques",
    icon = "🤔",
    category = "progressive",
    description = "Comprendre par le questionnement",
    prompt = [[En tant que mentor Socratique, pose une série de questions progressives pour comprendre ce concept :
1. D'abord, des questions de clarification basiques
2. Ensuite, des questions sur les hypothèses sous-jacentes
3. Puis, des questions sur les implications
4. Enfin, des questions de synthèse
Le concept est : ]],
  },
  {
    id = "learning_path",
    name = "Chemin d'Apprentissage",
    icon = "📈",
    category = "progressive",
    description = "Progression structurée",
    prompt = [[Crée un chemin d'apprentissage progressif pour ce concept :
1. Quels sont les prérequis essentiels ?
2. Quelles sont les étapes d'apprentissage ?
3. Quels sont les points de contrôle de compréhension ?
4. Comment vérifier la maîtrise ?
Le concept à apprendre est : ]],
  },
  {
    id = "misconceptions",
    name = "Correction Misconceptions",
    icon = "🐛",
    category = "progressive",
    description = "Éviter les erreurs courantes",
    prompt = [[Identifie et corrige les confusions courantes :
1. Quelles sont les erreurs de compréhension typiques ?
2. Pourquoi ces erreurs sont-elles fréquentes ?
3. Comment éviter ces pièges ?
4. Quels sont les points clés à retenir ?
Le concept à clarifier est : ]],
  },

  -- APPLICATIONS PRATIQUES
  {
    id = "quick_debug",
    name = "Debug Rapide",
    icon = "🔍",
    category = "practical",
    description = "Debugging efficace",
    prompt = [[Pour un debugging efficace de ce concept :
1. Points de contrôle clés :
   - Où placer les breakpoints stratégiques ?
   - Quelles variables surveiller ?
   - Quels cas tester en priorité ?

2. Erreurs courantes (80%) :
   - Quels problèmes causent la majorité des bugs ?
   - Quelles vérifications faire en premier ?
   - Quels patterns d'erreurs rechercher ?

3. Solutions rapides :
   - Quelles corrections apportent les meilleurs résultats ?
   - Quelles optimisations sont les plus simples ?
   - Quels tests effectuer en priorité ?

Le problème à debugger est : ]],
  },
  {
    id = "quick_optimize",
    name = "Optimisation Rapide",
    icon = "⚡",
    category = "practical",
    description = "Gains rapides",
    prompt = [[Pour une optimisation efficace selon le principe 20/80 :
1. Goulots d'étranglement :
   - Où sont les 20% du code qui causent 80% des problèmes ?
   - Quelles optimisations donneront les meilleurs résultats ?
   - Quels compromis sont les plus rentables ?

2. Gains rapides :
   - Quelles optimisations sont faciles à implémenter ?
   - Quelles parties du code sont les plus critiques ?
   - Où sont les victoires rapides ?

3. Validation :
   - Comment mesurer l'impact des optimisations ?
   - Quels benchmarks utiliser ?
   - Comment valider les améliorations ?

Le code à optimiser est : ]],
  },
  {
    id = "quick_review",
    name = "Revue Rapide",
    icon = "👀",
    category = "practical",
    description = "Revue de code efficace",
    prompt = [[Pour une revue de code efficace (20% qui compte pour 80%) :
1. Points critiques :
   - Quels aspects vérifier en priorité ?
   - Quels patterns problématiques rechercher ?
   - Quelles bonnes pratiques sont essentielles ?

2. Sécurité et robustesse :
   - Quelles sont les vulnérabilités courantes ?
   - Quels cas limites vérifier ?
   - Quelles validations sont critiques ?

3. Maintenabilité :
   - Quels aspects du code pourraient poser problème ?
   - Comment améliorer la lisibilité ?
   - Quelles parties nécessitent une refactorisation ?

Le code à revoir est : ]],
  },
  {
    id = "optimization",
    name = "Optimisation",
    icon = "⚡",
    category = "practical",
    description = "Performance et efficacité",
    prompt = [[Analyse les aspects d'optimisation pour ce concept :
1. Performance :
   - Quels sont les goulots d'étranglement typiques ?
   - Quelles optimisations sont possibles ?
   - Quels compromis considérer ?

2. Complexité :
   - Quelle est la complexité temporelle ?
   - Quelle est la complexité spatiale ?
   - Comment réduire la complexité ?

3. Ressources :
   - Comment optimiser l'utilisation mémoire ?
   - Comment améliorer l'efficacité CPU ?
   - Quelles ressources sont critiques ?

4. Scalabilité :
   - Comment le code se comporte à grande échelle ?
   - Quels problèmes peuvent survenir ?
   - Comment améliorer la scalabilité ?

5. Cas limites :
   - Quels cas limites considérer ?
   - Comment gérer les situations extrêmes ?
   - Quelles optimisations spécifiques appliquer ?

Le concept à optimiser est : ]],
  },

  -- PERSPECTIVES AVANCÉES
  {
    id = "expert_view",
    name = "Vision Expert",
    icon = "👨‍🔬",
    category = "advanced",
    description = "Perspective avancée",
    prompt = [[Comment un expert voit-il ce concept ?
1. Quelles subtilités un novice pourrait manquer ?
2. Quels aspects sont souvent mal compris ?
3. Quelles optimisations sont possibles ?
4. Quels cas limites sont importants ?
Le concept à analyser est : ]],
  },
  {
    id = "context",
    name = "Contexte et Applications",
    icon = "🌍",
    category = "advanced",
    description = "Vue d'ensemble",
    prompt = [[Replace ce concept dans son contexte plus large :
1. D'où vient ce concept ?
2. Pourquoi a-t-il été développé ?
3. Où est-il particulièrement utile ?
4. Comment s'intègre-t-il avec d'autres concepts ?
Le concept à contextualiser est : ]],
  },
  {
    id = "alternative_approaches",
    name = "Approches Alternatives",
    icon = "🔄",
    category = "advanced",
    description = "Différentes solutions",
    prompt = [[Propose différentes approches pour ce problème :
1. Solution classique :
   - Implémentation standard
   - Avantages/inconvénients
   - Cas d'utilisation

2. Solution orientée performance :
   - Optimisations possibles
   - Compromis nécessaires
   - Gains attendus

3. Solution orientée mémoire :
   - Gestion mémoire optimisée
   - Structures de données
   - Compromis espace/temps

4. Solution bit à bit :
   - Manipulations binaires
   - Optimisations bas niveau
   - Cas d'application

Le problème à analyser est : ]],
  },

  -- STYLES ET PRATIQUES
  {
    id = "best_practices",
    name = "Bonnes Pratiques",
    icon = "✨",
    category = "style",
    description = "Standards et conventions",
    prompt = [[Explique les meilleures pratiques pour ce concept :
1. Conventions et standards :
   - Quelles sont les conventions établies ?
   - Quels standards suivre ?
   - Quelles sont les pratiques recommandées ?

2. Anti-patterns à éviter :
   - Quelles sont les erreurs communes ?
   - Quels pièges éviter ?
   - Quelles sont les mauvaises pratiques courantes ?

3. Cas d'utilisation :
   - Quand utiliser ce concept ?
   - Quand ne pas l'utiliser ?
   - Quelles sont les alternatives ?

4. Sécurité et robustesse :
   - Quels aspects de sécurité considérer ?
   - Comment rendre le code plus robuste ?
   - Quelles vérifications implémenter ?

5. Maintenabilité :
   - Comment rendre le code maintenable ?
   - Comment documenter efficacement ?
   - Comment faciliter les tests ?

Le concept à analyser est : ]],
  },
  {
    id = "code_style",
    name = "Style de Code",
    icon = "📝",
    category = "style",
    description = "Lisibilité et maintenance",
    prompt = [[Analyse le style de code pour ce concept :
1. Lisibilité :
   - Comment rendre le code plus lisible ?
   - Quelles conventions de nommage utiliser ?
   - Comment structurer le code ?

2. Modularité :
   - Comment découper le code ?
   - Quelle architecture adopter ?
   - Comment gérer les dépendances ?

3. Design Patterns :
   - Quels patterns sont applicables ?
   - Comment les implémenter correctement ?
   - Quels bénéfices apportent-ils ?

4. Tests :
   - Comment tester efficacement ?
   - Quels cas de test prévoir ?
   - Comment assurer la couverture ?

5. Documentation :
   - Comment documenter le code ?
   - Quels aspects documenter ?
   - Comment maintenir la documentation ?

Le concept à analyser est : ]],
  },
  {
    id = "carmack_style",
    name = "Style Carmack",
    icon = "🚀",
    category = "style",
    description = "Approche John Carmack",
    prompt = [[Analyse ce problème avec l'approche John Carmack :
1. Optimisation bas niveau :
   - Comment optimiser au niveau des registres ?
   - Quelles optimisations bit-à-bit sont possibles ?
   - Comment minimiser les accès mémoire ?

2. Architecture performante :
   - Comment structurer pour la performance ?
   - Quelles structures de données utiliser ?
   - Comment gérer la mémoire efficacement ?

3. Approche pragmatique :
   - Quelle est la solution la plus directe ?
   - Comment simplifier la logique ?
   - Quels compromis performance/lisibilité ?

4. Considérations techniques :
   - Comment exploiter le hardware ?
   - Quelles spécificités du CPU utiliser ?
   - Quelles optimisations assembleur possibles ?

Le problème à résoudre est : ]],
  },
  {
    id = "five_stars",
    name = "Style 5 Étoiles",
    icon = "⭐",
    category = "style",
    description = "Solution élégante",
    prompt = [[Analyse ce problème comme un mainteneur 5 étoiles :
1. Approche élégante :
   - Quelle solution la plus élégante ?
   - Comment maximiser l'efficacité ?
   - Quelles astuces avancées utiliser ?

2. Optimisations expertes :
   - Quelles optimisations non évidentes ?
   - Comment réduire la complexité ?
   - Quelles techniques avancées employer ?

3. Style et qualité :
   - Comment rendre le code parfait ?
   - Quelles conventions respecter ?
   - Comment dépasser les attentes ?

4. Documentation et clarté :
   - Comment documenter clairement ?
   - Quels aspects expliquer ?
   - Comment justifier les choix ?

Le problème à résoudre est : ]],
  },

  -- TECHNIQUES SPÉCIFIQUES
  {
    id = "pointer_magic",
    name = "Full Pointeurs",
    icon = "🔍",
    category = "specific",
    description = "Solution pointeurs",
    prompt = [[Résous ce problème en utilisant uniquement des pointeurs :
1. Manipulation de pointeurs :
   - Comment utiliser l'arithmétique des pointeurs ?
   - Quelles structures avec pointeurs créer ?
   - Comment optimiser les déréférencements ?

2. Techniques avancées :
   - Comment utiliser les pointeurs de fonction ?
   - Quelles structures chaînées implémenter ?
   - Comment gérer les pointeurs multiples ?

3. Optimisations :
   - Comment minimiser les copies ?
   - Comment optimiser les accès mémoire ?
   - Quelles astuces pointeurs utiliser ?

4. Sécurité et robustesse :
   - Comment vérifier les pointeurs ?
   - Comment éviter les fuites ?
   - Quelles validations implémenter ?

Le problème à implémenter est : ]],
  },
  {
    id = "bit_manipulation",
    name = "Opérations Binaires",
    icon = "⚡",
    category = "specific",
    description = "Manipulation bits",
    prompt = [[Résous ce problème avec des opérations binaires :
1. Opérations bit à bit :
   - Quels masques binaires utiliser ?
   - Quelles opérations bit à bit appliquer ?
   - Comment optimiser les manipulations ?

2. Techniques binaires :
   - Comment utiliser les shifts ?
   - Quelles opérations AND/OR/XOR ?
   - Comment optimiser les tests de bits ?

3. Optimisations bas niveau :
   - Comment réduire les opérations ?
   - Quelles astuces binaires utiliser ?
   - Comment exploiter les flags CPU ?

4. Cas particuliers :
   - Comment gérer les signes ?
   - Comment traiter les overflows ?
   - Quelles limites considérer ?

Le problème à résoudre est : ]],
  },
}

-- Cache pour les prompts chargés depuis les packs
M.custom_prompts = {}

-- Charger les packs communautaires
function M.load_packs()
  if not config.options.packs.enabled then
    return
  end

  M.custom_prompts = {}

  for _, pack_path in ipairs(config.options.packs.paths) do
    if vim.fn.isdirectory(pack_path) == 1 then
      local pack_files = vim.fn.glob(pack_path .. "/*.json", false, true)

      for _, file in ipairs(pack_files) do
        local success, content = pcall(function()
          local file_content = table.concat(vim.fn.readfile(file), "\n")
          return vim.fn.json_decode(file_content)
        end)

        if success and content and content.prompts then
          for _, prompt in ipairs(content.prompts) do
            table.insert(M.custom_prompts, prompt)
          end
        end
      end
    end
  end
end

-- Obtenir tous les prompts (builtin + custom)
function M.get_all()
  M.load_packs()
  local all_prompts = vim.deepcopy(M.builtin)
  for _, prompt in ipairs(M.custom_prompts) do
    table.insert(all_prompts, prompt)
  end
  return all_prompts
end

-- Obtenir les prompts par catégorie
function M.get_by_category(category)
  local all_prompts = M.get_all()
  local filtered = {}

  for _, prompt in ipairs(all_prompts) do
    if prompt.category == category then
      table.insert(filtered, prompt)
    end
  end

  return filtered
end

-- Obtenir un prompt par ID
function M.get_by_id(id)
  local all_prompts = M.get_all()

  for _, prompt in ipairs(all_prompts) do
    if prompt.id == id then
      return prompt
    end
  end

  return nil
end

-- Lister les catégories disponibles
function M.list_categories()
  local all_prompts = M.get_all()
  local categories = {}
  local seen = {}

  for _, prompt in ipairs(all_prompts) do
    if prompt.category and not seen[prompt.category] then
      table.insert(categories, prompt.category)
      seen[prompt.category] = true
    end
  end

  return categories
end

return M
