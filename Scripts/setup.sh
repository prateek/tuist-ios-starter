#!/bin/bash

# ABOUTME: Development environment setup script
# ABOUTME: Detects template usage and offers transformation, or installs required tools and generates the Xcode project

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Template detection constants
TEMPLATE_NAME="iOSClaudeCodeStarter"

# Check if this is a template that needs transformation
detect_template() {
    local needs_transformation=false
    
    # Check for template indicators
    if [[ -f "Project.swift" ]] && grep -q "$TEMPLATE_NAME" "Project.swift"; then
        needs_transformation=true
    fi
    
    if [[ -d "${TEMPLATE_NAME}.xcodeproj" ]]; then
        needs_transformation=true
    fi
    
    if [[ -d "${TEMPLATE_NAME}.xcworkspace" ]]; then
        needs_transformation=true
    fi
    
    if [[ "$needs_transformation" == "true" ]]; then
        return 0  # Success (needs transformation)
    else
        return 1  # No transformation needed
    fi
}

# Standard setup for existing projects
standard_setup() {
    echo -e "${BLUE}🚀 Setting up project development environment...${NC}"
    
    # Check if we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "❌ This script requires macOS"
        exit 1
    fi
    
    # Install Tuist if not present
    if ! command -v tuist &> /dev/null; then
        echo "📦 Installing Tuist..."
        curl -Ls https://install.tuist.io | bash
    else
        echo "✅ Tuist is already installed"
    fi
    
    # Setup GitHub MCP authentication
    if command -v gh &> /dev/null; then
        echo "🐙 Setting up GitHub MCP authentication..."
        if gh auth status &> /dev/null; then
            # Refresh auth with required scopes
            gh auth refresh --scopes "repo,read:packages,read:org" --hostname github.com || true
            # Create .env file with PAT
            echo "GITHUB_PAT=$(gh auth token)" > .env
            echo "✅ GitHub MCP configured"
        else
            echo "⚠️  Run 'gh auth login' first for GitHub MCP integration"
        fi
    else
        echo "⚠️  Install gh CLI for GitHub MCP: brew install gh"
    fi
    
    # Generate Xcode project
    echo "🔨 Generating Xcode project..."
    tuist install
    tuist generate --no-open
    
    echo -e "${GREEN}✅ Setup complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open the generated project: open *.xcworkspace"
    echo "2. Build and run the app (⌘+R)"
    echo "3. Start developing!"
    echo ""
    echo "📖 Check CLAUDE.md for AI development guidelines"
    echo "📖 Check docs/development-workflow.md for team workflows"
}

# Template transformation setup
template_setup() {
    echo -e "${YELLOW}🎯 Template Detected!${NC}"
    echo ""
    echo "This appears to be a fresh clone of the iOS Claude Code Starter template."
    echo "You can transform it into a clean, production-ready project for your app."
    echo ""
    echo "The transformation will:"
    echo "  • Rename all project files to your app name"
    echo "  • Update bundle identifiers and configuration"
    echo "  • Remove template-specific documentation"
    echo "  • Optionally remove example code"
    echo "  • Create a clean project focused on YOUR app"
    echo ""
    read -p "Would you like to transform this template into your project? [y/N]: " transform
    
    if [[ "$transform" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${BLUE}🔄 Starting project transformation...${NC}"
        
        # Run the transformation script
        if [[ -x "Scripts/setup-new-project.sh" ]]; then
            ./Scripts/setup-new-project.sh
        else
            echo "❌ Transformation script not found or not executable"
            echo "Please make sure Scripts/setup-new-project.sh exists and is executable"
            exit 1
        fi
    else
        echo ""
        echo -e "${BLUE}📚 Setting up template for exploration...${NC}"
        echo "You can run the transformation later with: ./Scripts/setup-new-project.sh"
        echo ""
        
        # Run standard setup for template exploration
        standard_setup
    fi
}

# Main execution
main() {
    if detect_template; then
        template_setup
    else
        standard_setup
    fi
}

# Run main function
main "$@"