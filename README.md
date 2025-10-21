# fx-shell

A modern Wayland desktop shell built on QuickShell, targeting Sway compositor.

## Status

🚧 **Early Development** - Infrastructure phase

Currently implemented:
- ✅ Core repository structure
- ✅ ServiceRegistry singleton
- ✅ EventBus system
- ✅ Config management
- ✅ Theme system
- ✅ Development tooling

## Quick Start

### Prerequisites

- QuickShell
- Sway compositor
- Qt 6.x

### Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/fx-shell.git
cd fx-shell

# Run setup script
./scripts/dev-setup.sh

# Start development shell
./scripts/run-dev.sh
```

## Architecture

fx-shell uses a modular, service-oriented architecture:

- **ServiceRegistry**: Dependency injection and service discovery
- **EventBus**: Decoupled inter-component communication
- **Config**: Centralized configuration management
- **Theme**: Theming and visual customization

See [docs/architecture/](docs/architecture/) for detailed documentation.

## References

This project draws inspiration from:
- **DankMaterialShell** - Widget implementations
- **Noctalia Shell** - Architecture patterns
- **Caelestia** - Build patterns

Reference implementations are included in `references/` directory.

## Development

See [.fx-guidelines/](.fx-guidelines/) for comprehensive development guidelines
optimized for LLM-assisted development.

## License

MIT
