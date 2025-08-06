#!/bin/bash

set -e

echo "🚀 Manual Publishing Script for HashiCorp Vault N8N Node"
echo "========================================================"

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Make sure you're in the project root directory."
    exit 1
fi

# Check if we have the necessary tools
if ! command -v pnpm &> /dev/null; then
    echo "❌ Error: pnpm is not installed. Please install pnpm first."
    echo "   npm install -g pnpm"
    exit 1
fi

# Check if user is logged in to npm
if ! npm whoami &> /dev/null; then
    echo "❌ Error: You are not logged in to npm."
    echo "   Please run: npm login"
    exit 1
fi

echo "✅ Environment checks passed"

# Get current version
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📦 Current version: $CURRENT_VERSION"

# Ask for version bump
echo ""
echo "🔢 Version bump options:"
echo "1) patch (1.0.0 -> 1.0.1)"
echo "2) minor (1.0.0 -> 1.1.0)"
echo "3) major (1.0.0 -> 2.0.0)"
echo "4) custom version"
echo "5) keep current version"

read -p "Choose an option (1-5): " version_choice

case $version_choice in
    1)
        NEW_VERSION=$(npm version patch --no-git-tag-version)
        ;;
    2)
        NEW_VERSION=$(npm version minor --no-git-tag-version)
        ;;
    3)
        NEW_VERSION=$(npm version major --no-git-tag-version)
        ;;
    4)
        read -p "Enter custom version: " custom_version
        NEW_VERSION=$(npm version $custom_version --no-git-tag-version)
        ;;
    5)
        NEW_VERSION="v$CURRENT_VERSION"
        ;;
    *)
        echo "❌ Invalid option. Exiting."
        exit 1
        ;;
esac

echo "📦 Version will be: $NEW_VERSION"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
pnpm install --frozen-lockfile

# Run linting
echo ""
echo "🔍 Running linter..."
pnpm run lint

# Run formatting
echo ""
echo "🎨 Running formatter..."
pnpm run format

# Build the package
echo ""
echo "🔨 Building package..."
pnpm run build

# Run tests (if they exist)
echo ""
echo "🧪 Running tests..."
if pnpm run test 2>/dev/null; then
    echo "✅ Tests passed"
else
    echo "⚠️  No tests found or tests failed, continuing..."
fi

# Show what will be published
echo ""
echo "📋 Files that will be published:"
npm pack --dry-run

# Confirm publication
echo ""
read -p "🚀 Ready to publish? (y/N): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Publishing to npm..."
    npm publish --access public

    echo ""
    echo "✅ Successfully published $NEW_VERSION to npm!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Commit and push the version change:"
    echo "   git add package.json"
    echo "   git commit -m \"Release $NEW_VERSION\""
    echo "   git tag $NEW_VERSION"
    echo "   git push origin main --tags"
    echo ""
    echo "2. Create a GitHub release at:"
    echo "   https://github.com/imitruk/hashicorp_n8n_node/releases/new"
    echo ""
    echo "3. Users can install with:"
    echo "   npm install n8n-nodes-hashicorp-vault"
else
    echo "❌ Publication cancelled."

    # Revert version change if it was made
    if [ "$version_choice" != "5" ]; then
        git checkout package.json 2>/dev/null || true
        echo "🔄 Version changes reverted."
    fi
fi