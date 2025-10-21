# Reference Repository Structure Analysis Plan

**Purpose:** Systematically analyze directory structures of key reference projects to inform fx-shell's architecture evolution  
**Status:** Planning Phase - No Implementation  
**Date:** October 2025  
**Phase:** Post-Infrastructure (After Issue #1 Completion)

---

## Executive Summary

Now that fx-shell's basic infrastructure is in place (Issue #1 completed), the next phase requires deep understanding of how successful QuickShell and Wayland shell projects organize their codebases. This document provides a structured methodology for analyzing reference implementations without diving into actual coding.

**Key Objectives:**
1. Extract directory structures from all Tier 1-3 reference projects
2. Identify organizational patterns and best practices
3. Map module boundaries and dependencies
4. Understand build system integration approaches
5. Document findings for informed architectural decisions

---

## Analysis Methodology

### Phase 1: Automated Structure Extraction

**Tools & Approach:**
```bash
# For each reference repository, extract structure locally

# Method 1: Clone and use tree command
git clone --depth 1 <repo-url> /tmp/<repo-name>
cd /tmp/<repo-name>
tree -L 3 -d > ~/fx-shell/docs/reference-structures/<repo-name>-dirs.txt
tree -L 2 -I 'node_modules|.git' > ~/fx-shell/docs/reference-structures/<repo-name>-full.txt

# Method 2: Use GitHub API (if available)
curl -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/<owner>/<repo>/git/trees/main?recursive=1 \
  > ~/fx-shell/docs/reference-structures/<repo-name>-api.json

# Method 3: Use online GitHub tree visualizers
# - https://www.readmecodegen.com/file-tree/github-file-tree-visualizer
# - Copy/export structure for documentation
```

### Phase 2: Comparative Analysis Framework

For each repository, document:
1. **Top-level organization** - Main directories and their purposes
2. **Module structure** - How features are organized into modules
3. **Common vs specific** - Shared utilities vs feature-specific code
4. **Configuration approach** - Where and how config is stored
5. **Build system** - CMake, Makefiles, scripts
6. **Documentation structure** - API docs, guides, examples
7. **Testing organization** - Unit, integration, e2e test locations
8. **Assets management** - Icons, themes, fonts location

---

## Tier 1: Critical Foundation Projects

These repositories are ESSENTIAL for fx-shell's evolution. Deep dive required.

### 1. DankMaterialShell (PRIMARY)

**Repository:** https://github.com/AvengeMedia/DankMaterialShell  
**Priority:** ⭐⭐⭐⭐⭐ CRITICAL  
**Status:** Most complete QuickShell implementation

**Expected Structure (Based on README):**
```
DankMaterialShell/
├── shell.qml                    # Main entry point
├── modules/                     # Feature modules
│   ├── topbar/                 # Status bar implementation
│   ├── launcher/               # Application launcher
│   ├── media/                  # Media controls
│   ├── notifications/          # Notification system
│   ├── control-center/         # System controls
│   ├── dock/                   # Application dock
│   └── [other widgets]/
├── components/                  # Reusable UI components
│   ├── buttons/
│   ├── sliders/
│   └── containers/
├── services/                    # System integration
│   ├── audio/
│   ├── network/
│   ├── power/
│   ├── bluetooth/
│   └── compositor/
├── commons/                     # Shared utilities
│   ├── Config.qml
│   ├── Theme.qml
│   └── Utils.qml
├── assets/                      # Static resources
│   ├── icons/
│   ├── fonts/
│   └── themes/
├── docs/                        # Documentation
│   ├── IPC.md
│   ├── CUSTOM_THEMES.md
│   └── [guides]/
└── scripts/                     # Utility scripts
```

**Analysis Questions:**
- [ ] How are IPC handlers organized? (dgop integration)
- [ ] What's the service registration pattern?
- [ ] How are compositor-specific features isolated?
- [ ] Configuration file structure and loading mechanism?
- [ ] Theme system implementation details?
- [ ] Widget interdependencies - how are they managed?
- [ ] Build/installation process?

**Key Files to Study:**
- `shell.qml` - Application bootstrap
- `modules/*/` - All widget implementations
- `services/*/` - Service architecture
- `commons/` - Shared infrastructure
- `docs/IPC.md` - IPC patterns
- `docs/CUSTOM_THEMES.md` - Theme system

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/AvengeMedia/DankMaterialShell.git /tmp/dms
cd /tmp/dms
tree -L 4 -I '.git' > ~/fx-shell/docs/reference-structures/dankma terialshell-structure.txt
tree -L 2 -d > ~/fx-shell/docs/reference-structures/dankmaterialshell-dirs-only.txt
```

---

### 2. dgop (DMS IPC Framework)

**Repository:** https://github.com/AvengeMedia/dgop  
**Priority:** ⭐⭐⭐⭐⭐ CRITICAL  
**Purpose:** Understanding IPC patterns for fx-shell

**Expected Focus:**
- IPC protocol design
- Message passing patterns
- Event subscription system
- Service communication patterns

**Analysis Questions:**
- [ ] How is the IPC protocol structured?
- [ ] Message format and serialization?
- [ ] Event routing and subscription?
- [ ] Client-server architecture?
- [ ] Integration points with QuickShell?

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/AvengeMedia/dgop.git /tmp/dgop
cd /tmp/dgop
tree -L 3 > ~/fx-shell/docs/reference-structures/dgop-structure.txt
```

---

### 3. Noctalia Shell

**Repository:** https://github.com/noctalia-dev/noctalia-shell  
**Priority:** ⭐⭐⭐⭐⭐ CRITICAL  
**Purpose:** Multi-compositor abstraction patterns

**Expected Structure:**
```
noctalia-shell/
├── shell.qml
├── modules/
│   ├── core/
│   │   ├── compositor/         # Compositor abstraction
│   │   ├── workspace/
│   │   ├── window/
│   │   └── events/
│   ├── services/
│   │   ├── audio/
│   │   ├── network/
│   │   └── [system services]/
│   └── ui/
│       ├── panels/
│       └── widgets/
├── commons/
│   ├── ServiceRegistry.qml
│   ├── EventBus.qml
│   ├── Config.qml
│   └── Theme.qml
└── [docs, tests, assets]/
```

**Analysis Questions:**
- [ ] How is CompositorService abstracted?
- [ ] Hyprland vs Niri implementation differences?
- [ ] Module communication patterns?
- [ ] Service lifecycle management?
- [ ] Configuration system design?
- [ ] Event bus implementation?

**Key Files to Study:**
- `modules/core/compositor/` - Abstraction layer
- `commons/ServiceRegistry.qml` - DI pattern
- `commons/EventBus.qml` - Event system
- Module organization strategy
- Cross-module communication

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/noctalia-dev/noctalia-shell.git /tmp/noctalia
cd /tmp/noctalia
tree -L 4 -I '.git|node_modules' > ~/fx-shell/docs/reference-structures/noctalia-structure.txt
```

---

### 4. Vantesh DMS Dotfiles

**Repository:** https://github.com/Vantesh/dotfiles/tree/main/home/dot_config/quickshell/dms  
**Priority:** ⭐⭐⭐⭐ HIGH  
**Purpose:** Real-world configuration patterns

**Expected Structure:**
```
dotfiles/
├── home/
│   └── dot_config/
│       └── quickshell/
│           └── dms/
│               ├── settings.json    # User customizations
│               ├── themes/          # Custom themes
│               ├── plugins/         # User plugins
│               └── [overrides]/     # Config overrides
└── [chezmoi management files]
```

**Analysis Questions:**
- [ ] What does a user actually customize?
- [ ] Configuration override patterns?
- [ ] Dotfile management integration (chezmoi)?
- [ ] Custom theme structure?
- [ ] User plugin organization?

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/Vantesh/dotfiles.git /tmp/vantesh-dots
cd /tmp/vantesh-dots
tree home/dot_config/quickshell > ~/fx-shell/docs/reference-structures/vantesh-quickshell-config.txt
```

---

## Tier 2: Essential QuickShell References

### 5. Caelestia Shell

**Repository:** https://github.com/caelestia-dots/shell  
**Priority:** ⭐⭐⭐⭐ HIGH  
**Purpose:** Build system and deployment patterns

**Expected Focus:**
```
shell/
├── CMakeLists.txt              # Build configuration
├── src/                        # QML source files
├── install/                    # Installation scripts
└── packaging/                  # Package definitions
```

**Analysis Questions:**
- [ ] CMake integration for QuickShell projects?
- [ ] Installation workflow?
- [ ] System-wide vs user installation?
- [ ] Dependency management?

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/caelestia-dots/shell.git /tmp/caelestia
cd /tmp/caelestia
tree -L 3 > ~/fx-shell/docs/reference-structures/caelestia-structure.txt
```

---

### 6. End-4 Dots Hyprland (QuickShell)

**Repository:** https://github.com/end-4/dots-hyprland  
**Priority:** ⭐⭐⭐ MEDIUM-HIGH  
**Purpose:** Innovative widget implementations

**Expected Structure:**
```
dots-hyprland/
├── .config/
│   └── quickshell/             # QuickShell implementation
│       ├── ai-plugin/          # AI assistant widget
│       ├── shortcuts/          # Shortcut visualization
│       ├── widgets/            # Various custom widgets
│       └── [innovative features]/
└── [AGS legacy implementation]/
```

**Analysis Questions:**
- [ ] AI plugin architecture and integration?
- [ ] Shortcut visualization implementation?
- [ ] Advanced widget patterns?
- [ ] How are innovative features organized?

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/end-4/dots-hyprland.git /tmp/end4-dots
cd /tmp/end4-dots/.config/quickshell
tree -L 4 > ~/fx-shell/docs/reference-structures/end4-quickshell-structure.txt
```

---

## Tier 3: Sway/i3 Integration References

### 7. Waybar

**Repository:** https://github.com/Alexays/Waybar  
**Priority:** ⭐⭐⭐⭐⭐ CRITICAL (for Sway integration)  
**Language:** C++  
**Purpose:** Production Sway IPC patterns

**Expected Structure:**
```
waybar/
├── include/
│   ├── modules/
│   │   ├── sway/               # Sway-specific modules
│   │   ├── network/
│   │   ├── battery/
│   │   └── [all modules]/
│   └── bar.hpp
├── src/
│   ├── modules/
│   │   ├── sway/               # Sway IPC implementation
│   │   │   ├── workspace.cpp
│   │   │   ├── window.cpp
│   │   │   └── mode.cpp
│   │   └── [all module impls]/
│   └── bar.cpp
├── man/                        # Documentation
└── resources/                  # Assets
```

**Analysis Questions:**
- [ ] Sway IPC protocol implementation patterns?
- [ ] Event subscription and handling?
- [ ] Workspace tracking implementation?
- [ ] Window management patterns?
- [ ] Module organization philosophy?
- [ ] How are modules configured?

**Key Files to Study:**
- `include/modules/sway/*.hpp` - Sway module interfaces
- `src/modules/sway/*.cpp` - IPC implementation
- Module configuration patterns
- Event handling architecture

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/Alexays/Waybar.git /tmp/waybar
cd /tmp/waybar
tree -L 3 -d > ~/fx-shell/docs/reference-structures/waybar-structure.txt
tree src/modules/sway -L 2 > ~/fx-shell/docs/reference-structures/waybar-sway-modules.txt
```

---

### 8. Swaybar (Official)

**Repository:** https://github.com/swaywm/sway (sway/swaybar/)  
**Priority:** ⭐⭐⭐⭐ HIGH  
**Purpose:** Official Sway bar implementation

**Expected Focus:**
```
sway/
├── swaybar/
│   ├── bar.c                   # Main bar implementation
│   ├── ipc.c                   # IPC handling
│   ├── render.c                # Rendering
│   └── status_line.c           # Status command integration
└── [rest of sway compositor]/
```

**Analysis Questions:**
- [ ] Official IPC usage patterns?
- [ ] Bar protocol implementation?
- [ ] Layer-shell integration?
- [ ] Status command integration?

**Extraction Command:**
```bash
git clone --depth 1 https://github.com/swaywm/sway.git /tmp/sway
cd /tmp/sway/swaybar
tree -L 2 > ~/fx-shell/docs/reference-structures/swaybar-structure.txt
```

---

### 9. i3status / i3blocks

**Repositories:**
- https://github.com/i3/i3status
- https://github.com/vivien/i3blocks

**Priority:** ⭐⭐⭐ MEDIUM  
**Purpose:** Traditional status module patterns

**Expected Focus:**
```
i3status/
├── src/
│   ├── print_battery.c
│   ├── print_cpu_temperature.c
│   ├── print_wireless_info.c
│   └── [all modules]/
└── i3status.c                  # Main loop

i3blocks/
├── blocks/                     # Individual block scripts
│   ├── battery
│   ├── cpu
│   └── [all blocks]/
└── i3blocks.c                  # Block manager
```

**Analysis Questions:**
- [ ] Module data collection patterns?
- [ ] Update frequency strategies?
- [ ] Configuration format?
- [ ] How modules communicate with bar?

**Extraction Commands:**
```bash
git clone --depth 1 https://github.com/i3/i3status.git /tmp/i3status
cd /tmp/i3status
tree -L 2 > ~/fx-shell/docs/reference-structures/i3status-structure.txt

git clone --depth 1 https://github.com/vivien/i3blocks.git /tmp/i3blocks
cd /tmp/i3blocks
tree -L 2 > ~/fx-shell/docs/reference-structures/i3blocks-structure.txt
```

---

## Additional Reference Projects

### Tier 4-7 Projects (Secondary Analysis)

**Fabric Implementations:**
- Ax-Shell: https://github.com/Axenide/Ax-Shell
- Tsumiki: https://github.com/rubiin/Tsumiki

**AGS Legacy:**
- matshell: https://github.com/Neurarian/matshell
- gleaming-glacier: https://github.com/Cu3PO42/gleaming-glacier

**Launchers:**
- Rofi: https://github.com/adi1090x/rofi
- Gauntlet: https://github.com/project-gauntlet/gauntlet
- Vicinae: https://github.com/vicinaehq/vicinae
- Sherlock: https://github.com/Skxxtz/sherlock

**Specialized:**
- EWW: https://github.com/elkowar/eww
- Squeekboard: https://gitlab.gnome.org/World/Phosh/squeekboard
- KDE Connect: https://github.com/KDE/kdeconnect-kde

---

## Comparative Analysis Template

For each analyzed repository, document using this template:

```markdown
# [Project Name] Structure Analysis

## Overview
- **Repository:** [URL]
- **Language/Framework:** [Language]
- **Lines of Code:** [Estimate]
- **Last Updated:** [Date]
- **Active Development:** [Yes/No]

## Top-Level Organization

```
[Project]/
├── [directory] - [purpose]
├── [directory] - [purpose]
└── [directory] - [purpose]
```

## Module Organization Pattern

**Pattern Type:** [Flat/Hierarchical/Hybrid]

**Modules Location:** `[path]`

**Module Structure:**
```
modules/[feature]/
├── [key files]
└── [subdirs]
```

**Naming Conventions:**
- Components: [convention]
- Services: [convention]
- Files: [convention]

## Commons/Shared Infrastructure

**Location:** `[path]`

**Contents:**
- [Component 1]: [purpose]
- [Component 2]: [purpose]

## Configuration Management

**Config Location:** `[path]`

**Format:** [JSON/TOML/QML/etc]

**Structure:**
```
[config structure]
```

## Build System

**Type:** [CMake/Make/Scripts/None]

**Build Files:**
- `[file]`: [purpose]

**Installation Process:**
```bash
[commands]
```

## Documentation Structure

**Location:** `[path]`

**Types:**
- API Docs: [location]
- User Guides: [location]
- Developer Docs: [location]

## Testing Organization

**Test Location:** `[path]`

**Test Types:**
- Unit: [location]
- Integration: [location]
- E2E: [location]

## Asset Management

**Assets Location:** `[path]`

**Organization:**
```
assets/
├── icons/ - [approach]
├── themes/ - [approach]
└── fonts/ - [approach]
```

## Key Insights for fx-shell

**Organizational Patterns to Adopt:**
1. [Pattern 1]: [why relevant]
2. [Pattern 2]: [why relevant]

**Patterns to Avoid:**
1. [Anti-pattern 1]: [why avoid]
2. [Anti-pattern 2]: [why avoid]

**Unique Features Worth Studying:**
1. [Feature 1]: [implementation approach]
2. [Feature 2]: [implementation approach]

**Applicable Code Patterns:**
- [Pattern description]
- [Where to apply in fx-shell]

## Cross-References

**Similar to:**
- [Project A]: [in what way]
- [Project B]: [in what way]

**Different from:**
- [Project X]: [how different]
- [Project Y]: [how different]

## Action Items

- [ ] Extract [specific component]
- [ ] Study [specific pattern]
- [ ] Map to fx-shell [module]
- [ ] Document [approach]
```

---

## Analysis Workflow

### Week 1: Tier 1 Deep Dive (Critical Foundation)

**Day 1-2: DankMaterialShell**
- Clone repository
- Extract full directory structure
- Document module organization
- Study service architecture
- Analyze IPC integration (dgop)
- Review widget implementations

**Day 3: dgop**
- Clone repository
- Understand IPC protocol
- Document message patterns
- Study event system

**Day 4-5: Noctalia Shell**
- Clone repository
- Study CompositorService abstraction
- Document module architecture
- Analyze EventBus implementation
- Review configuration system

**Day 6: Vantesh Dotfiles**
- Review real-world configuration
- Document customization patterns
- Study dotfile integration

**Day 7: Comparative Analysis**
- Compare Tier 1 projects
- Document patterns
- Identify best practices
- Create synthesis document

### Week 2: Tier 2 & 3 Analysis

**Day 1-2: Caelestia & End-4**
- QuickShell alternative approaches
- Build system patterns
- Innovative features

**Day 3-5: Waybar & Swaybar**
- Deep dive into Sway IPC
- Production patterns
- Module organization
- Event handling

**Day 6-7: i3status/blocks & Synthesis**
- Traditional patterns
- Module data collection
- Create comprehensive comparison

### Week 3: Documentation & Planning

**Day 1-3: Document Findings**
- Create analysis documents for each project
- Comparative analysis
- Pattern catalog

**Day 4-5: Architecture Recommendations**
- Based on findings, propose fx-shell improvements
- Module reorganization if needed
- Build system decisions

**Day 6-7: Roadmap Updates**
- Update fx-shell roadmap based on learnings
- Identify code to extract/adapt
- Prioritize next implementation phases

---

## Deliverables

### 1. Repository Structure Documents

**Location:** `~/fx-shell/docs/reference-structures/`

**Files:**
- `dankmaterialshell-structure.txt` - Full DMS tree
- `dgop-structure.txt` - IPC framework tree
- `noctalia-structure.txt` - Noctalia tree
- `vantesh-quickshell-config.txt` - Real config tree
- `caelestia-structure.txt` - Build system tree
- `end4-quickshell-structure.txt` - End-4 tree
- `waybar-structure.txt` - Waybar C++ tree
- `waybar-sway-modules.txt` - Sway module detail
- `swaybar-structure.txt` - Official bar tree
- `i3status-structure.txt` - i3status tree
- `i3blocks-structure.txt` - i3blocks tree

### 2. Individual Analysis Documents

**Location:** `~/fx-shell/docs/reference-analyses/`

**Files:** (using template above)
- `DankMaterialShell-ANALYSIS.md`
- `dgop-ANALYSIS.md`
- `Noctalia-ANALYSIS.md`
- `Vantesh-Config-ANALYSIS.md`
- `Caelestia-ANALYSIS.md`
- `End4-ANALYSIS.md`
- `Waybar-ANALYSIS.md`
- `Swaybar-ANALYSIS.md`
- `i3status-ANALYSIS.md`

### 3. Comparative Analysis

**Location:** `~/fx-shell/docs/COMPARATIVE-ANALYSIS.md`

**Contents:**
- Organizational pattern comparison matrix
- Module structure comparison
- Configuration approach comparison
- Build system comparison
- Testing strategy comparison
- Asset management comparison
- Strengths/weaknesses of each approach
- Best practices identified
- Recommended patterns for fx-shell

### 4. Pattern Catalog

**Location:** `~/fx-shell/docs/PATTERN-CATALOG.md`

**Contents:**
- Service organization patterns
- Module communication patterns
- Configuration management patterns
- IPC integration patterns
- Event handling patterns
- Build system patterns
- Testing patterns
- Documentation patterns

### 5. Architecture Recommendations

**Location:** `~/fx-shell/docs/ARCHITECTURE-RECOMMENDATIONS.md`

**Contents:**
- Current fx-shell structure assessment
- Recommended improvements based on analysis
- Module reorganization proposals
- Build system recommendations
- Testing strategy recommendations
- Documentation improvements
- Migration plan (if reorganization needed)

### 6. Implementation Roadmap Update

**Location:** `~/fx-shell/docs/ROADMAP-UPDATE.md`

**Contents:**
- Updated phases based on learnings
- Code extraction priorities
- Adaptation strategies
- Timeline adjustments
- Resource requirements

---

## Success Criteria

### Analysis Complete When:

- [ ] All Tier 1 repositories cloned and analyzed
- [ ] Directory structures extracted and documented
- [ ] Individual analysis documents created for each project
- [ ] Comparative analysis completed
- [ ] Pattern catalog compiled
- [ ] Architecture recommendations drafted
- [ ] Team review and feedback incorporated
- [ ] Roadmap updated with findings

### Quality Metrics:

- [ ] Each project has comprehensive structure documentation
- [ ] Analysis templates fully filled out
- [ ] Cross-references between projects documented
- [ ] Actionable recommendations provided
- [ ] Patterns applicable to fx-shell identified
- [ ] Anti-patterns to avoid documented
- [ ] Code extraction priorities established

---

## Post-Analysis: Next Steps

### Immediate Actions:

1. **Review Recommendations** - Team discussion on proposed changes
2. **Prioritize Patterns** - Decide which patterns to adopt first
3. **Plan Refactoring** - If structure changes needed
4. **Code Extraction** - Begin extracting useful implementations
5. **Module Development** - Start implementing priority modules

### Long-term Actions:

1. **Continuous Learning** - Keep analyzing new projects
2. **Pattern Updates** - Refine patterns as we implement
3. **Documentation** - Keep reference docs updated
4. **Community Engagement** - Share findings, contribute back

---

## Tools & Resources

### Directory Structure Tools:

```bash
# tree command (most universal)
tree -L 3 -d              # Directories only, 3 levels deep
tree -L 2 -I '.git|node_modules'  # Exclude certain dirs
tree -f                    # Full paths
tree -J                    # JSON output

# Alternative: using find
find . -type d -maxdepth 3 | sort

# Alternative: using ls with recursive
ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g'
```

### GitHub Tools:

- **Online Tree Visualizers:**
  - https://www.readmecodegen.com/file-tree/github-file-tree-visualizer
  - https://github.com/mgks/GitHubTree

- **Browser Extensions:**
  - Octotree (GitHub code tree)
  - GitHub Repository Size
  - Sourcegraph (code navigation)

### Documentation Tools:

```bash
# Generate API docs from code
# (project-specific, e.g., doxygen for C++, jsdoc for JS)

# Count lines of code
cloc /path/to/repo

# Find file types
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn
```

---

## Risk Mitigation

### Potential Issues:

1. **Time Constraints:**
   - **Mitigation:** Focus on Tier 1 first, defer lower tiers if needed
   - **Fallback:** Limit analysis depth, focus on key patterns

2. **Repository Access:**
   - **Mitigation:** All target repos are public
   - **Fallback:** Use cached/archived versions if needed

3. **Analysis Paralysis:**
   - **Mitigation:** Set strict time limits per project (1-2 days max)
   - **Fallback:** Document what's useful, move on

4. **Pattern Conflicts:**
   - **Mitigation:** Document trade-offs, team decision required
   - **Fallback:** Default to most mature project (DankMaterialShell)

5. **Information Overload:**
   - **Mitigation:** Use templates, focus on fx-shell applicability
   - **Fallback:** Summarize key points, link to full details

---

## Conclusion

This systematic analysis plan ensures comprehensive understanding of reference projects before diving into implementation. By following this structured approach, fx-shell will make informed architectural decisions based on proven patterns from successful projects.

**Remember:** The goal is **planning and understanding**, not implementation. Resist the urge to start coding until analysis is complete and team has reviewed recommendations.

**Timeline:** 3 weeks of focused analysis will save months of refactoring later.

---

## Appendix A: Quick Reference Commands

```bash
# One-liner to extract all Tier 1 structures
mkdir -p ~/fx-shell/docs/reference-structures
for repo in \
  "AvengeMedia/DankMaterialShell" \
  "AvengeMedia/dgop" \
  "noctalia-dev/noctalia-shell" \
  "Vantesh/dotfiles"; do
    name=$(echo $repo | cut -d'/' -f2)
    git clone --depth 1 "https://github.com/$repo.git" "/tmp/$name"
    tree "/tmp/$name" -L 3 -I '.git|node_modules' > \
      "~/fx-shell/docs/reference-structures/${name}-structure.txt"
done

# Compare directory structures
diff -y --suppress-common-lines \
  ~/fx-shell/docs/reference-structures/dankmaterialshell-structure.txt \
  ~/fx-shell/docs/reference-structures/noctalia-structure.txt
```

---

## Appendix B: Analysis Template Markdown

Save this as `~/fx-shell/docs/templates/PROJECT-ANALYSIS-TEMPLATE.md`:

```markdown
# [Project Name] Structure Analysis

## Overview
- **Repository:** 
- **Language/Framework:** 
- **Lines of Code:** 
- **Last Updated:** 
- **Active Development:** 

## Top-Level Organization
[paste tree output]

## Module Organization Pattern
**Pattern Type:** 
**Modules Location:** 
**Module Structure:** [describe]
**Naming Conventions:** [list]

## Commons/Shared Infrastructure
[document shared code]

## Configuration Management
[document config approach]

## Build System
[document build process]

## Documentation Structure
[document docs organization]

## Testing Organization
[document test structure]

## Asset Management
[document asset organization]

## Key Insights for fx-shell
**Organizational Patterns to Adopt:**
1. 

**Patterns to Avoid:**
1. 

**Unique Features Worth Studying:**
1. 

**Applicable Code Patterns:**
- 

## Cross-References
**Similar to:**
- 

**Different from:**
- 

## Action Items
- [ ] 
```

---

**End of Planning Document**

**Next Action:** Execute Phase 1 - Begin cloning and analyzing Tier 1 repositories, starting with DankMaterialShell.
