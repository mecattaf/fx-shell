# dgop

<div align=center>

![GitHub last commit](https://img.shields.io/github/last-commit/AvengeMedia/dgop?style=for-the-badge&labelColor=101418&color=9ccbfb)
![GitHub License](https://img.shields.io/github/license/AvengeMedia/dgop?style=for-the-badge&labelColor=101418&color=b9c8da)
![GitHub Release](https://img.shields.io/github/v/release/AvengeMedia/dgop?style=for-the-badge&labelColor=101418&color=a6da95)
[![AUR](https://img.shields.io/aur/version/dgop?style=for-the-badge&labelColor=101418&color=f5a97f)](https://aur.archlinux.org/packages/dgop)

</div>

<div align="center">
<img src="https://github.com/user-attachments/assets/eb0b4e3e-e6ed-439d-a24b-640d15938510" width="600" alt="dgop" />
</div>

System monitoring tool with CLI and REST API.

Can be used standalone, or as a  companion for [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) to unlock system information functionality.

## Installation

### Latest Release
Download the latest binary from [GitHub Releases](https://github.com/AvengeMedia/dgop/releases/latest)

### Arch Linux (AUR)
```bash
# Using yay
yay -S dgop

# Using paru  
paru -S dgop
```

### Build from Source
```bash
# Build it
make

# Install system-wide
sudo make install

# Or just run locally
go run ./cmd/cli [command]
```

## Basic Commands

```bash
# See all at once
dgop all

# Just CPU info
dgop cpu

# Memory usage
dgop memory

# Network interfaces
dgop network

# Disk usage and mounts
dgop disk

# Running processes (sorted by CPU usage)
dgop processes

# System load and uptime
dgop system

# Hardware info (BIOS, motherboard, etc)
dgop hardware

# GPU information
dgop gpu

# Get temperature for specific GPU
dgop gpu-temp --pci-id 10de:2684

# List available modules
dgop modules
```

## Meta Command

Mix and match any modules you want:

```bash
# Just CPU and memory
dgop meta --modules cpu,memory

# Everything except processes
dgop meta --modules cpu,memory,network,disk,system,hardware,gpu

# GPU with temperatures
dgop meta --modules gpu --gpu-pci-ids 10de:2684

# Multiple GPU temperatures
dgop meta --modules gpu --gpu-pci-ids 10de:2684,1002:164e

# Everything (same as 'dgop all')
dgop meta --modules all
```

## JSON Output

Add `--json` to any command:

```bash
dgop cpu --json
dgop meta --modules gpu,memory --json
```

## Process Options

```bash
# Sort by memory instead of CPU
dgop processes --sort memory

# Limit to top 10
dgop processes --limit 10

# Skip CPU calculation for faster results
dgop processes --no-cpu

# Combine options
dgop meta --modules processes --sort memory --limit 20 --no-cpu
```

## API Server

Start the REST API:

```bash
dgop server
```

Then hit these endpoints:

- **GET** `/gops/cpu` - CPU info
- **GET** `/gops/memory` - Memory usage  
- **GET** `/gops/network` - Network interfaces
- **GET** `/gops/disk` - Disk usage
- **GET** `/gops/processes?sort_by=memory&limit=10` - Top 10 processes by memory
- **GET** `/gops/system` - System load and uptime
- **GET** `/gops/hardware` - Hardware info
- **GET** `/gops/gpu` - GPU information
- **GET** `/gops/gpu/temp?pciId=10de:2684` - GPU temperature
- **GET** `/gops/modules` - List available modules
- **GET** `/gops/meta?modules=cpu,memory&gpu_pci_ids=10de:2684` - Dynamic modules

API docs: http://localhost:63484/docs

## Examples

### Get GPU temps for both your cards
```bash
dgop meta --modules gpu --gpu-pci-ids 10de:2684,1002:164e
```

### Monitor system without slow CPU calculations
```bash
dgop meta --modules cpu,memory,network --no-cpu
```

### API: Get CPU and memory as JSON
```bash
curl http://localhost:63484/gops/meta?modules=cpu,memory
```

### API: Get GPU with temperature
```bash
curl "http://localhost:63484/gops/meta?modules=gpu&gpu_pci_ids=10de:2684"
```

## Real-time Monitoring with Cursors

dgop supports cursor-based sampling for building real-time monitoring tools like htop. Instead of relying on instantaneous snapshots, you can track system state changes over time for more accurate CPU usage calculations and network/disk rates.

The cursor system works by:
- Taking an initial measurement that establishes baseline metrics and timestamps
- Returning a base64-encoded cursor containing the current state data
- Using that cursor in subsequent calls to calculate precise percentages and rates over the sampling interval

This approach accounts for the actual time elapsed between measurements, making it ideal for monitoring tools that poll every few seconds.

### CPU Usage with Cursors

```bash
# First call - establishes baseline and returns cursor
dgop cpu --json
# Returns: {"usage":1.68, ..., "cursor":"eyJ0b3RhbCI6WzE2MjMwLjAzLDUuOTUsNTEyMy4yNV0..."}

# Wait a few seconds, then use cursor for accurate CPU calculations
sleep 3
dgop cpu --json --cursor "eyJ0b3RhbCI6WzE2MjMwLjAzLDUuOTUsNTEyMy4yNV0..."
# Returns more accurate usage percentages based on time delta
```

### Process Monitoring with Cursors

```bash
# First call - establishes process baseline
dgop processes --json --limit 5
# Returns: {"processes":[...], "cursor":"W3sicGlkIjoyODE2NTYsInRpY2tzIjozOS43Mix9XQ..."}

# Use cursor for accurate per-process CPU calculations
sleep 2
dgop processes --json --limit 5 --cursor "W3sicGlkIjoyODE2NTYsInRpY2tzIjozOS43Mix9XQ..."
```

### Network Rate Monitoring

```bash
# First call - establishes network baseline
dgop net-rate --json
# Returns: {"interfaces":[...], "cursor":"eyJ0aW1lc3RhbXAiOiIyMDI1LTA4LTExVDE2OjE1OjM1..."}

# Get real-time transfer rates
sleep 3
dgop net-rate --json --cursor "eyJ0aW1lc3RhbXAiOiIyMDI1LTA4LTExVDE2OjE1OjM1..."
# Returns: {"interfaces":[{"interface":"wlp99s0","rxrate":67771,"txrate":16994}]}
```

### Disk I/O Rate Monitoring

```bash
# Establish disk I/O baseline
dgop disk-rate --json
# Returns cursor for disk rate calculations

# Get real-time disk I/O rates
sleep 2
dgop disk-rate --json --cursor "eyJ0aW1lc3RhbXAiOiIyMDI1LTA4LTExVDE2OjE2..."
```

### Combined Monitoring with Meta Command

```bash
# Monitor CPU, processes, and network rates together
dgop meta --modules cpu,processes,net-rate --json --limit 10

# Use multiple cursors for comprehensive monitoring
dgop meta --modules cpu,processes,net-rate --json --limit 10 \
  --cpu-cursor "eyJ0b3RhbCI6WzE2MjMwLjAz..." \
  --proc-cursor "W3sicGlkIjoyODE2NTYsInRpY2tzIjo..." \
  --net-rate-cursor "eyJ0aW1lc3RhbXAiOiIyMDI1LTA4LTEx..."
```

## Development

```bash
# Build
make

# Run tests
make test

# Format code
make fmt

# Build and install
make && sudo make install

# Clean build artifacts
make clean
```

## Requirements

- Go 1.22+
- Linux (uses `/proc`, `/sys`, and system commands)
- Optional: `nvidia-smi` for NVIDIA GPU temperatures
- Optional: `lspci` for GPU detection

## Why Another Monitoring Tool?

Because nothing did what i wanted, i didnt want to run a metrics server, I wanted GO because its fast and compiles to a single binary, bash scripts got too messy.

TL;DR single binary cli and server with json output, openapi spec, and a bunch of data.
