#!/bin/bash
# fx-shell Reference Repository Structure Extraction Script
# Purpose: Clone and extract directory structures from key reference projects
# Focus: Architectural patterns, especially QuickShell implementations
# Date: October 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ANALYSIS_DIR="/tmp/fx-shell-analysis"
OUTPUT_DIR="$HOME/fx-shell/docs/reference-structures"
ANALYSIS_STUBS_DIR="$HOME/fx-shell/docs/reference-analyses"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}fx-shell Reference Repository Analysis${NC}"
echo -e "${BLUE}Focus: Architectural Patterns & Organization${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Create directories
mkdir -p "$ANALYSIS_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$ANALYSIS_STUBS_DIR"

# Check for required tools
echo -e "${YELLOW}Checking required tools...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}ERROR: git not found. Please install git.${NC}"
    exit 1
fi

if ! command -v tree &> /dev/null; then
    echo -e "${YELLOW}WARNING: tree not found. Install with: sudo dnf install tree${NC}"
    echo -e "${YELLOW}Continuing without tree command (will use find instead)${NC}"
    USE_TREE=false
else
    USE_TREE=true
fi

if ! command -v cloc &> /dev/null; then
    echo -e "${YELLOW}WARNING: cloc not found (optional). Install with: sudo dnf install cloc${NC}"
    USE_CLOC=false
else
    USE_CLOC=true
fi

echo ""

# Repository definitions
# Tier 1: Critical QuickShell Architecture References
declare -A TIER1_REPOS=(
    ["DankMaterialShell"]="https://github.com/AvengeMedia/DankMaterialShell"
    ["dgop"]="https://github.com/AvengeMedia/dgop"
    ["noctalia-shell"]="https://github.com/noctalia-dev/noctalia-shell"
    ["vantesh-dms"]="https://github.com/Vantesh/dotfiles"
)

# Tier 2: Essential QuickShell Pattern References
declare -A TIER2_REPOS=(
    ["caelestia-shell"]="https://github.com/caelestia-dots/shell"
    ["end4-dots"]="https://github.com/end-4/dots-hyprland"
)

# Function to extract structure
extract_structure() {
    local repo_name=$1
    local repo_path=$2

    echo -e "${BLUE}Extracting structure: ${repo_name}${NC}"

    cd "$repo_path"

    # Method 1: Tree command (preferred)
    if [ "$USE_TREE" = true ]; then
        echo "  - Generating tree (L3 depth)..."
        tree -L 3 -I 'node_modules|.git|__pycache__|*.pyc|.venv|venv' \
            > "$OUTPUT_DIR/${repo_name}-L3.txt" 2>/dev/null || true

        echo "  - Generating directories only..."
        tree -L 4 -d -I 'node_modules|.git|__pycache__|.venv|venv' \
            > "$OUTPUT_DIR/${repo_name}-dirs.txt" 2>/dev/null || true
    else
        # Fallback: Use find command
        echo "  - Generating structure with find..."
        find . -maxdepth 3 -type d ! -path '*/\.git/*' ! -path '*/node_modules/*' \
            > "$OUTPUT_DIR/${repo_name}-dirs.txt" 2>/dev/null || true
    fi

    # File type statistics
    echo "  - Generating file type statistics..."
    find . -type f ! -path '*/\.git/*' ! -path '*/node_modules/*' | \
        sed 's/.*\.//' | sort | uniq -c | sort -rn \
        > "$OUTPUT_DIR/${repo_name}-filetypes.txt" 2>/dev/null || true

    # Lines of code (if cloc available)
    if [ "$USE_CLOC" = true ]; then
        echo "  - Counting lines of code..."
        cloc . --quiet --csv --out="$OUTPUT_DIR/${repo_name}-loc.csv" 2>/dev/null || true
    fi

    echo -e "${GREEN}  ✓ Structure extracted${NC}\n"
}

# Function to create analysis stub
create_analysis_stub() {
    local repo_name=$1
    local stub_file="$ANALYSIS_STUBS_DIR/${repo_name}-ANALYSIS.md"

    if [ -f "$stub_file" ]; then
        echo "  - Analysis stub already exists, skipping"
        return
    fi

    cat > "$stub_file" << 'EOF'
# [PROJECT_NAME] Architecture Analysis

**Repository:** [URL]
**Analysis Date:** [DATE]
**Focus:** Architectural patterns, module organization, theming system

---

## Executive Summary

[Brief overview of the project and its architectural approach]

---

## Top-Level Organization

### Directory Structure
```
[Paste key directories here]
```

### Key Observations
- **Organization pattern:** [Describe the top-level pattern]
- **Module separation:** [How are features separated?]
- **Configuration approach:** [Where and how is config managed?]
- **Asset management:** [How are assets organized?]

---

## Module Architecture

### Module Organization Pattern
[Describe how modules are structured]

### Communication Patterns
- **Inter-module communication:** [How do modules talk to each other?]
- **Service discovery:** [How are services registered/discovered?]
- **Event handling:** [Event bus? Direct signals? Other?]

### Example Module Structure
```
[Show a typical module's internal structure]
```

---

## Service Architecture

### Service Pattern
[Describe the service pattern used]

### Key Services Identified
1. **[Service Name]**
   - Purpose: [What it does]
   - Location: [File path]
   - Dependencies: [What it depends on]
   - API: [Key functions/properties]

[Repeat for other major services]

---

## Configuration System

### Configuration Approach
[How is configuration managed?]

### Config File Locations
- Main config: [Path]
- Theme config: [Path]
- User overrides: [Path]

### Configuration Pattern
[Singleton? Multiple files? JSON? QML? Other?]

---

## Theme System

### Theming Approach
[How are themes implemented?]

### Matugen Integration (if applicable)
- **Integration point:** [Where matugen is used]
- **Color generation:** [How colors are generated/applied]
- **Theme switching:** [How users switch themes]

### Theme File Structure
[Describe theme organization]

---

## Build System

### Build Approach
[CMake? Make? Scripts? None?]

### Installation Process
[How is the shell installed?]

### Dependencies
- Required: [List]
- Optional: [List]

---

## Patterns Worth Adopting

### Pattern 1: [Name]
- **Description:** [What is it?]
- **Benefits:** [Why is it good?]
- **Applicability:** [How to adapt for fx-shell?]

[Repeat for other patterns]

---

## Anti-Patterns Observed

### Anti-Pattern 1: [Name]
- **Description:** [What is it?]
- **Problems:** [Why is it problematic?]
- **How to avoid:** [Alternative approach]

[Repeat for other anti-patterns]

---

## Code Extraction Candidates

### High Priority
1. **[Component Name]**
   - Location: [Path]
   - Complexity: [Low/Medium/High]
   - Dependencies: [What it needs]
   - Adaptation effort: [Estimate]

[Repeat for other components]

---

## Key Takeaways

### Architecture Lessons
1. [Lesson 1]
2. [Lesson 2]
3. [Lesson 3]

### Recommendations for fx-shell
1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

---

## References

- Repository: [URL]
- Key files reviewed: [List]
- Documentation: [Links]
- Related projects: [Links]
EOF

    # Replace placeholder
    sed -i "s/\[PROJECT_NAME\]/$repo_name/g" "$stub_file"
    sed -i "s/\[DATE\]/$(date +%Y-%m-%d)/g" "$stub_file"

    echo -e "  - Created analysis stub: $stub_file"
}

# Process Tier 1 repositories
echo -e "${YELLOW}=== Processing Tier 1: Critical Architecture References ===${NC}\n"

for repo_name in "${!TIER1_REPOS[@]}"; do
    repo_url="${TIER1_REPOS[$repo_name]}"
    repo_path="$ANALYSIS_DIR/$repo_name"

    echo -e "${GREEN}Processing: $repo_name${NC}"

    # Clone if not already cloned
    if [ -d "$repo_path" ]; then
        echo "  - Repository already cloned, skipping..."
    else
        echo "  - Cloning repository..."
        git clone --depth 1 "$repo_url" "$repo_path" 2>&1 | grep -v "^Cloning" || true
    fi

    # Extract structure
    extract_structure "$repo_name" "$repo_path"

    # Create analysis stub
    create_analysis_stub "$repo_name"

    echo ""
done

# Process Tier 2 repositories
echo -e "${YELLOW}=== Processing Tier 2: Essential Pattern References ===${NC}\n"

for repo_name in "${!TIER2_REPOS[@]}"; do
    repo_url="${TIER2_REPOS[$repo_name]}"
    repo_path="$ANALYSIS_DIR/$repo_name"

    echo -e "${GREEN}Processing: $repo_name${NC}"

    # Clone if not already cloned
    if [ -d "$repo_path" ]; then
        echo "  - Repository already cloned, skipping..."
    else
        echo "  - Cloning repository..."
        git clone --depth 1 "$repo_url" "$repo_path" 2>&1 | grep -v "^Cloning" || true
    fi

    # Extract structure
    extract_structure "$repo_name" "$repo_path"

    # Create analysis stub
    create_analysis_stub "$repo_name"

    echo ""
done

# Generate summary report
SUMMARY_FILE="$OUTPUT_DIR/EXTRACTION-SUMMARY.md"
echo -e "${BLUE}Generating extraction summary...${NC}"

cat > "$SUMMARY_FILE" << EOF
# Reference Repository Structure Extraction Summary

**Generated:** $(date)
**Focus:** Architectural patterns for fx-shell
**Total Repositories:** $((${#TIER1_REPOS[@]} + ${#TIER2_REPOS[@]}))

---

## Extraction Statistics

### Tier 1: Critical Architecture References
$(for repo in "${!TIER1_REPOS[@]}"; do echo "- ✓ $repo"; done)

### Tier 2: Essential Pattern References
$(for repo in "${!TIER2_REPOS[@]}"; do echo "- ✓ $repo"; done)

---

## Output Locations

### Structure Files
Location: \`$OUTPUT_DIR\`

For each repository:
- \`[repo]-L3.txt\` - Directory tree (3 levels deep)
- \`[repo]-dirs.txt\` - Directories only (4 levels)
- \`[repo]-filetypes.txt\` - File type statistics
- \`[repo]-loc.csv\` - Lines of code analysis (if cloc available)

### Analysis Stubs
Location: \`$ANALYSIS_STUBS_DIR\`

Each repository has a corresponding \`[repo]-ANALYSIS.md\` stub file ready to be filled in.

---

## Next Steps

1. **Review extracted structures:**
   \`\`\`bash
   ls -lh $OUTPUT_DIR
   \`\`\`

2. **Start with DankMaterialShell analysis:**
   \`\`\`bash
   less $OUTPUT_DIR/DankMaterialShell-L3.txt
   \$EDITOR $ANALYSIS_STUBS_DIR/DankMaterialShell-ANALYSIS.md
   \`\`\`

3. **Compare structures:**
   \`\`\`bash
   diff -y --width=200 \\
     $OUTPUT_DIR/DankMaterialShell-dirs.txt \\
     $OUTPUT_DIR/noctalia-shell-dirs.txt | less
   \`\`\`

4. **Fill in analysis stubs** for each project

5. **Create comparative analysis** using COMPARATIVE-ANALYSIS-FRAMEWORK.md

---

## Focus Areas for Analysis

### Architecture Patterns
- Module organization strategies
- Service architecture and communication
- Configuration management approaches
- Build system integration

### Theme System (Matugen)
- DankMaterialShell: Original implementation
- Noctalia: How it consumes/adapts DMS patterns
- Caelestia: Further adaptations

### Reusable Patterns
- ServiceRegistry patterns
- EventBus implementations
- Config singleton approaches
- Theme system architectures

---

## Analysis Order (Recommended)

1. **DankMaterialShell** - Most complete, sets the pattern baseline
2. **Noctalia Shell** - How patterns are adapted/improved
3. **Caelestia Shell** - Further refinements
4. **dgop** - IPC patterns used by DMS
5. **Vantesh dotfiles** - Real-world configuration
6. **End-4 dots** - Innovative features

---

**Extraction complete!** Ready to begin analysis phase.
EOF

echo -e "${GREEN}✓ Summary generated: $SUMMARY_FILE${NC}\n"

# Final summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}Extraction Complete!${NC}"
echo -e "${BLUE}================================================${NC}\n"

echo -e "Output locations:"
echo -e "  - Structures: ${GREEN}$OUTPUT_DIR${NC}"
echo -e "  - Analysis stubs: ${GREEN}$ANALYSIS_STUBS_DIR${NC}"
echo -e "  - Summary: ${GREEN}$SUMMARY_FILE${NC}\n"

echo -e "Next actions:"
echo -e "  1. Review summary: ${YELLOW}cat $SUMMARY_FILE${NC}"
echo -e "  2. View structures: ${YELLOW}ls -lh $OUTPUT_DIR${NC}"
echo -e "  3. Start analysis: ${YELLOW}\$EDITOR $ANALYSIS_STUBS_DIR/DankMaterialShell-ANALYSIS.md${NC}\n"

echo -e "${GREEN}Ready to analyze!${NC}"
