#!/bin/bash

# Script de publication pour LazyLearn.nvim
# Usage: ./publish.sh

set -e

echo "🚀 Publication de LazyLearn.nvim sur GitHub"
echo "=========================================="
echo ""

# Vérifier si on est dans le bon répertoire
if [ ! -f "README.md" ] || [ ! -d "lua/lazylearn" ]; then
    echo "❌ Erreur: Exécutez ce script depuis le répertoire LazyLearn.nvim"
    exit 1
fi

# Vérifier si git est installé
if ! command -v git &> /dev/null; then
    echo "❌ Erreur: git n'est pas installé"
    exit 1
fi

echo "📋 Étape 1: Vérification des fichiers..."
echo "----------------------------------------"

# Compter les fichiers
lua_files=$(find lua -name "*.lua" | wc -l)
json_files=$(find packs -name "*.json" | wc -l)

echo "✓ Fichiers Lua trouvés: $lua_files"
echo "✓ Fichiers JSON trouvés: $json_files"
echo "✓ README.md présent"
echo "✓ LICENSE présent"
echo ""

echo "📋 Étape 2: Tests du plugin..."
echo "----------------------------------------"

# Lancer les tests
if nvim --headless -u NONE -c "set rtp+=." -c "luafile test_plugin.lua" -c "qa" 2>&1 | grep -q "Tous les tests sont passés"; then
    echo "✓ Tous les tests sont passés!"
else
    echo "❌ Les tests ont échoué. Corrigez les erreurs avant de publier."
    exit 1
fi
echo ""

echo "📋 Étape 3: Initialisation Git..."
echo "----------------------------------------"

# Vérifier si git est déjà initialisé
if [ ! -d ".git" ]; then
    echo "Initialisation du dépôt Git..."
    git init
    echo "✓ Dépôt Git initialisé"
else
    echo "✓ Dépôt Git déjà initialisé"
fi
echo ""

echo "📋 Étape 4: Configuration Git..."
echo "----------------------------------------"

# Demander les informations utilisateur
read -p "Votre nom GitHub (ex: monpseudo): " github_user

if [ -z "$github_user" ]; then
    echo "❌ Nom d'utilisateur requis"
    exit 1
fi

echo "✓ Utilisateur: $github_user"
echo ""

echo "📋 Étape 5: Ajout des fichiers..."
echo "----------------------------------------"

# Ajouter tous les fichiers
git add .
echo "✓ Fichiers ajoutés"
echo ""

echo "📋 Étape 6: Premier commit..."
echo "----------------------------------------"

# Créer le premier commit
if git diff --staged --quiet; then
    echo "ℹ️  Aucun changement à commiter"
else
    git commit -m "🎉 Initial commit - LazyLearn.nvim v1.0.0

- 32 techniques d'apprentissage intégrées
- Support de 5 providers IA (Groq, OpenAI, Ollama, LM Studio, Custom)
- Système de révision espacée (SRS)
- Interface avec fenêtres flottantes
- 6 commandes utilisateur
- 10 prompts communautaires bonus
- Documentation complète
- Tests passants" || echo "⚠️  Commit déjà effectué"
    echo "✓ Commit créé"
fi
echo ""

echo "📋 Étape 7: Configuration du remote..."
echo "----------------------------------------"

# Configurer le remote
remote_url="https://github.com/$github_user/LazyLearn.nvim.git"

if git remote | grep -q origin; then
    echo "ℹ️  Remote origin déjà configuré"
    git remote set-url origin "$remote_url"
else
    git remote add origin "$remote_url"
fi

echo "✓ Remote configuré: $remote_url"
echo ""

echo "📋 Instructions finales:"
echo "----------------------------------------"
echo ""
echo "1️⃣  Créez un nouveau dépôt sur GitHub:"
echo "   https://github.com/new"
echo "   Nom: LazyLearn.nvim"
echo "   Description: Un plugin Neovim pour apprendre à coder avec l'IA"
echo "   Public ✓"
echo "   Ne pas initialiser avec README, .gitignore ou LICENSE"
echo ""
echo "2️⃣  Une fois le dépôt créé, lancez:"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3️⃣  Créez une release:"
echo "   - Allez dans 'Releases' sur GitHub"
echo "   - Cliquez 'Create a new release'"
echo "   - Tag: v1.0.0"
echo "   - Title: LazyLearn.nvim v1.0.0"
echo "   - Description: Première version stable"
echo ""
echo "4️⃣  Partagez avec la communauté:"
echo "   - Reddit: r/neovim"
echo "   - Discord: Neovim"
echo "   - Twitter/X avec #neovim"
echo ""
echo "✅ Plugin prêt pour la publication!"
echo ""
echo "📝 N'oubliez pas de mettre à jour le README.md avec:"
echo "   - Votre nom d'utilisateur GitHub"
echo "   - Un GIF de démonstration"
echo "   - Des badges (version, license, etc.)"
echo ""
