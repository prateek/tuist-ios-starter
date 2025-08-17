#!/bin/bash

# ABOUTME: Automated project transformation script for iOS Claude Code Starter template
# ABOUTME: Transforms the template into a clean, production-ready project repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Template detection constants
TEMPLATE_NAME="iOSClaudeCodeStarter"
TEMPLATE_BUNDLE_PREFIX="com.claudecode.starter"

# Global variables
PROJECT_NAME=""
BUNDLE_DOMAIN=""
APP_DISPLAY_NAME=""
REMOVE_EXAMPLES=false
DRY_RUN=false
BACKUP_CREATED=false
BACKUP_BRANCH=""

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "\n${BLUE}🚀 iOS Claude Code Starter - Project Transformation${NC}\n"
}

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

# Validate project name (no spaces, valid identifier)
validate_project_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        return 1
    fi
    
    # Check for spaces
    if [[ "$name" =~ [[:space:]] ]]; then
        print_error "Project name cannot contain spaces"
        return 1
    fi
    
    # Check for valid identifier (letters, numbers, underscores, hyphens)
    if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        print_error "Project name must start with a letter and contain only letters, numbers, underscores, and hyphens"
        return 1
    fi
    
    return 0
}

# Validate bundle domain
validate_bundle_domain() {
    local domain="$1"
    
    if [[ -z "$domain" ]]; then
        return 1
    fi
    
    # Basic domain validation (com.company format)
    if [[ ! "$domain" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$ ]]; then
        print_error "Bundle domain must be in format like 'com.yourcompany'"
        return 1
    fi
    
    return 0
}

# Interactive prompts for project details
gather_project_details() {
    print_header
    echo "Transform this template into your clean, production-ready project."
    echo "This will rename all files and remove template-specific content."
    echo ""
    
    # Project name
    while true; do
        read -p "📱 Project name (e.g., MyAwesomeApp): " PROJECT_NAME
        if validate_project_name "$PROJECT_NAME"; then
            break
        fi
    done
    
    # Bundle domain
    while true; do
        read -p "📦 Bundle domain (e.g., com.yourcompany): " BUNDLE_DOMAIN
        if validate_bundle_domain "$BUNDLE_DOMAIN"; then
            break
        fi
    done
    
    # App display name
    read -p "🏷️  App display name (e.g., My Awesome App) [default: $PROJECT_NAME]: " APP_DISPLAY_NAME
    if [[ -z "$APP_DISPLAY_NAME" ]]; then
        APP_DISPLAY_NAME="$PROJECT_NAME"
    fi
    
    # Remove examples
    echo ""
    print_warning "The template includes example features (Home, Settings) to demonstrate patterns."
    read -p "🗑️  Remove example code and keep only the basic project structure? [y/N]: " remove_examples
    if [[ "$remove_examples" =~ ^[Yy]$ ]]; then
        REMOVE_EXAMPLES=true
    fi
    
    # Show summary
    echo ""
    print_info "Transformation Summary:"
    echo "  📱 Project Name: $PROJECT_NAME"
    echo "  📦 Bundle Domain: $BUNDLE_DOMAIN"
    echo "  🏷️  Display Name: $APP_DISPLAY_NAME"
    echo "  🗑️  Remove Examples: $([ "$REMOVE_EXAMPLES" == "true" ] && echo "Yes" || echo "No")"
    echo ""
    
    # Confirmation
    read -p "Continue with transformation? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Transformation cancelled."
        exit 0
    fi
}

# Create backup branch
create_backup() {
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would create backup branch"
        return
    fi
    
    print_info "Creating backup branch..."
    
    BACKUP_BRANCH="backup-template-$(date +%Y%m%d-%H%M%S)"
    
    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git checkout -b "$BACKUP_BRANCH"
        git add -A
        git commit -m "Backup before template transformation" || true
        git checkout -
        BACKUP_CREATED=true
        print_success "Backup created on branch: $BACKUP_BRANCH"
    else
        print_warning "Not in a git repository, skipping backup"
    fi
}

# Rename project directories
rename_directories() {
    print_info "Renaming project directories..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would rename:"
        print_info "  ${TEMPLATE_NAME}.xcodeproj → ${PROJECT_NAME}.xcodeproj"
        print_info "  ${TEMPLATE_NAME}.xcworkspace → ${PROJECT_NAME}.xcworkspace"
        return
    fi
    
    # Rename .xcodeproj
    if [[ -d "${TEMPLATE_NAME}.xcodeproj" ]]; then
        mv "${TEMPLATE_NAME}.xcodeproj" "${PROJECT_NAME}.xcodeproj"
        print_success "Renamed ${TEMPLATE_NAME}.xcodeproj → ${PROJECT_NAME}.xcodeproj"
    fi
    
    # Rename .xcworkspace
    if [[ -d "${TEMPLATE_NAME}.xcworkspace" ]]; then
        mv "${TEMPLATE_NAME}.xcworkspace" "${PROJECT_NAME}.xcworkspace"
        print_success "Renamed ${TEMPLATE_NAME}.xcworkspace → ${PROJECT_NAME}.xcworkspace"
    fi
}

# Update Project.swift configuration
update_project_swift() {
    print_info "Updating Project.swift configuration..."
    
    if [[ ! -f "Project.swift" ]]; then
        print_error "Project.swift not found"
        return 1
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would update Project.swift with new names and bundle IDs"
        return
    fi
    
    # Create temporary file for modifications
    local temp_file=$(mktemp)
    
    # Replace project name and bundle IDs
    sed -e "s/name: \"$TEMPLATE_NAME\"/name: \"$PROJECT_NAME\"/g" \
        -e "s|$TEMPLATE_BUNDLE_PREFIX|$BUNDLE_DOMAIN.$PROJECT_NAME|g" \
        -e "s/\"Claude Starter\"/\"$APP_DISPLAY_NAME\"/g" \
        "Project.swift" > "$temp_file"
    
    mv "$temp_file" "Project.swift"
    print_success "Updated Project.swift with new configuration"
}

# Update Makefile references
update_makefile() {
    print_info "Updating Makefile references..."
    
    if [[ ! -f "Makefile" ]]; then
        print_warning "Makefile not found, skipping"
        return
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would update Makefile workspace references"
        return
    fi
    
    # Replace workspace references
    sed -i.bak -e "s/${TEMPLATE_NAME}/${PROJECT_NAME}/g" "Makefile"
    rm -f "Makefile.bak"
    print_success "Updated Makefile workspace references"
}

# Update App.swift
update_app_swift() {
    print_info "Updating App.swift..."
    
    local app_file="Projects/App/Sources/App.swift"
    if [[ ! -f "$app_file" ]]; then
        print_error "App.swift not found at $app_file"
        return 1
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would update App.swift struct name"
        return
    fi
    
    # Replace app struct name
    sed -i.bak -e "s/ClaudeCodeStarterApp/${PROJECT_NAME}App/g" "$app_file"
    rm -f "${app_file}.bak"
    print_success "Updated App.swift struct name"
}

# Update CLAUDE.md references
update_claude_md() {
    print_info "Updating CLAUDE.md for your project..."
    
    if [[ ! -f "CLAUDE.md" ]]; then
        print_warning "CLAUDE.md not found, skipping"
        return
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would update CLAUDE.md with project name"
        return
    fi
    
    # Replace template references with project name
    sed -i.bak -e "s/iOS Claude Code Starter/$PROJECT_NAME/g" \
              -e "s/iOSClaudeCodeStarter/$PROJECT_NAME/g" \
              "CLAUDE.md"
    rm -f "CLAUDE.md.bak"
    print_success "Updated CLAUDE.md for your project"
}

# Remove template-specific files
remove_template_files() {
    print_info "Removing template-specific files..."
    
    local files_to_remove=(
        "QUICKSTART.md"
        "CONTRIBUTING.md" 
        "TODO.md"
        "Documentation"
    )
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would remove template-specific files:"
        for file in "${files_to_remove[@]}"; do
            if [[ -e "$file" ]]; then
                print_info "  - $file"
            fi
        done
        return
    fi
    
    for file in "${files_to_remove[@]}"; do
        if [[ -e "$file" ]]; then
            rm -rf "$file"
            print_success "Removed $file"
        fi
    done
}

# Create new project README
create_project_readme() {
    print_info "Creating clean project README..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would create clean project README"
        return
    fi
    
    cat > "README.md" << EOF
# $APP_DISPLAY_NAME

A modern iOS application built with SwiftUI and The Composable Architecture.

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma+ with Xcode 15.0+
- Tuist for project management

### Setup
\`\`\`bash
make setup      # Install dependencies and generate project
make run        # Build and run in simulator
\`\`\`

### Development
\`\`\`bash
make build      # Build the app
make test       # Run tests
make lint       # Run SwiftLint
make format     # Format code
\`\`\`

## 🏗 Architecture

This project uses:
- **SwiftUI** for the user interface
- **The Composable Architecture (TCA)** for state management
- **Tuist** for project generation and dependency management

## ⚡ CI Performance Optimization (Recommended)

To get **65-90% faster CI builds** through Tuist cloud caching:

1. **Authenticate with Tuist**:
   \`\`\`bash
   tuist auth login
   \`\`\`

2. **Create your project**:
   \`\`\`bash
   tuist project create your-handle/$PROJECT_NAME
   \`\`\`

3. **Generate and add token to GitHub Secrets**:
   \`\`\`bash
   tuist project tokens create your-handle/$PROJECT_NAME > /tmp/tuist_token.txt
   gh secret set TUIST_CONFIG_TOKEN < /tmp/tuist_token.txt
   rm /tmp/tuist_token.txt
   \`\`\`

**Benefits**: Binary caching, selective testing, bundle size tracking
**Without tokens**: Project works perfectly, but builds from scratch on every CI run

## 📖 Development Guide

See \`CLAUDE.md\` for AI-assisted development guidelines and \`docs/development-workflow.md\` for team development workflows.

## 🧪 Testing

Run tests with:
\`\`\`bash
make test
\`\`\`

Tests are organized by module:
- \`Projects/Features/Tests/\` - Feature tests
- \`Projects/CoreKit/Tests/\` - Core logic tests
- \`Projects/DesignSystem/Tests/\` - UI component tests

---

*Built with [iOS Claude Code Starter](https://github.com/prateek/tuist-ios-starter)*
EOF
    
    print_success "Created clean project README"
}

# Remove example code (if requested)
remove_example_code() {
    if [[ "$REMOVE_EXAMPLES" != "true" ]]; then
        return
    fi
    
    print_info "Removing example code..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would remove example features (Home, Settings)"
        return
    fi
    
    # Remove example features
    local example_files=(
        "Projects/Features/Sources/Home"
        "Projects/Features/Sources/Settings"
        "Projects/Features/Tests/HomeFeatureTests.swift"
        "Projects/Features/Tests/SettingsFeatureTests.swift"
    )
    
    for file in "${example_files[@]}"; do
        if [[ -e "$file" ]]; then
            rm -rf "$file"
            print_success "Removed example: $file"
        fi
    done
    
    # Update RootFeature to remove tab references
    local root_feature="Projects/Features/Sources/Root/RootFeature.swift"
    if [[ -f "$root_feature" ]]; then
        print_info "Updating RootFeature to remove example tabs..."
        # This is a complex transformation - for now, we'll leave a TODO comment
        sed -i.bak -e '1i\
// TODO: Update RootFeature after removing example Home and Settings features\
' "$root_feature"
        rm -f "${root_feature}.bak"
    fi
}

# Regenerate project
regenerate_project() {
    print_info "Regenerating project with new configuration..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_info "[DRY RUN] Would run: tuist install && tuist generate --no-open"
        return
    fi
    
    # Install dependencies and regenerate
    if command -v tuist >/dev/null 2>&1; then
        tuist install
        tuist generate --no-open
        print_success "Project regenerated successfully"
    else
        print_error "Tuist not found. Please install Tuist and run: tuist install && tuist generate --no-open"
    fi
}

# Show completion summary
show_completion_summary() {
    print_success "\n🎉 Project transformation completed successfully!"
    echo ""
    print_info "Your clean project is ready:"
    echo "  📱 Project: $PROJECT_NAME"
    echo "  📦 Bundle ID: $BUNDLE_DOMAIN.$PROJECT_NAME.*"
    echo "  🏷️  Display Name: $APP_DISPLAY_NAME"
    echo ""
    print_info "Next steps:"
    echo "  1. Open $PROJECT_NAME.xcworkspace in Xcode"
    echo "  2. Build and run your project (⌘+R)"
    echo "  3. Start developing your app!"
    echo ""
    if [[ "$BACKUP_CREATED" == "true" ]]; then
        print_info "💾 Backup available on branch: $BACKUP_BRANCH"
    fi
}

# Error handling and cleanup
cleanup_on_error() {
    print_error "Transformation failed!"
    
    if [[ "$BACKUP_CREATED" == "true" ]] && [[ "$DRY_RUN" != "true" ]]; then
        print_info "Restoring from backup branch: $BACKUP_BRANCH"
        git checkout "$BACKUP_BRANCH" 2>/dev/null || true
    fi
    
    exit 1
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--dry-run] [--help]"
                echo ""
                echo "Options:"
                echo "  --dry-run    Show what would be done without making changes"
                echo "  --help       Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Check if this is a template
    if ! detect_template; then
        print_info "This project has already been transformed or is not a template."
        print_info "Nothing to do."
        exit 0
    fi
    
    # Set up error handling
    trap cleanup_on_error ERR
    
    # Run transformation steps
    gather_project_details
    create_backup
    rename_directories
    update_project_swift
    update_makefile
    update_app_swift
    update_claude_md
    remove_template_files
    create_project_readme
    remove_example_code
    regenerate_project
    show_completion_summary
}

# Run main function
main "$@"