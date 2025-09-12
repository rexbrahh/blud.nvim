# BludVim Docker Usage

## Quick Start (AstroVim-style One-Liners)

### 1. **Direct Docker Run (No Installation)**
```bash
# Try BludVim instantly without installing anything
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.ssh":/home/nvim/.ssh:ro \
  -v "$HOME/.gitconfig":/home/nvim/.gitconfig:ro \
  -e TERM=xterm-256color \
  -e COLORTERM=truecolor \
  ghcr.io/rexbrahh/bludvim:latest
```

### 2. **One-Liner Installation**
```bash
# Install BludVim with Docker wrapper
curl -fsSL https://raw.githubusercontent.com/rexbrahh/.nvim/main/install.sh | bash
```

After installation, use:
```bash
bludvim                 # Open in current directory
bludvim file.txt        # Open specific file
bludvim .               # File explorer mode
```

## Docker Commands

### **Build Locally**
```bash
# Clone and build
git clone https://github.com/rexbrahh/.nvim
cd .nvim
docker build -t bludvim:latest .
```

### **Run with Docker Compose**
```bash
# Using docker-compose
docker compose up -d    # Start in background
docker compose exec nvim nvim  # Attach to session
docker compose down     # Stop and cleanup
```

### **Advanced Docker Run**
```bash
# Full features with persistent storage
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v bludvim_data:/home/nvim/.local/share/nvim \
  -v bludvim_cache:/home/nvim/.cache/nvim \
  -v "$HOME/.ssh":/home/nvim/.ssh:ro \
  -v "$HOME/.gitconfig":/home/nvim/.gitconfig:ro \
  -e TERM=xterm-256color \
  -e COLORTERM=truecolor \
  --name bludvim-$(date +%s) \
  bludvim:latest
```

## Available Commands

### **Management Commands**
```bash
bludvim --build         # Rebuild Docker image
bludvim --update        # Update and rebuild
bludvim --uninstall     # Complete removal
bludvim --help          # Show help
```

### **Usage Examples**
```bash
# Basic usage
bludvim                 # Current directory
bludvim main.py         # Specific file
bludvim src/            # Directory exploration

# Project development
cd my-project
bludvim .               # Full IDE experience with LSPs
```

## Features

- **40+ Pre-installed Plugins** - Ready to use
- **20+ Language Servers** - Auto-installed via Mason
- **Persistent Storage** - Configs and plugins preserved
- **Git Integration** - SSH keys and config mounted
- **Performance Optimized** - Alpine Linux base (1.2GB)
- **Zero Setup** - Just run the container

## Comparison with AstroVim

| Feature | AstroVim Docker | BludVim |
|---------|----------------|---------|
| One-liner try | ✅ | ✅ |
| Persistent setup | ❌ | ✅ |
| Custom LSPs | ✅ | ✅ |
| Alpine base | ❌ | ✅ (smaller) |
| Auto-install script | ❌ | ✅ |

## Troubleshooting

### **Container Issues**
```bash
# Check running containers
docker ps -a

# View logs
docker logs bludvim

# Reset everything
docker system prune -a
```

### **Permission Issues**
```bash
# Fix ownership (if needed)
docker run --rm -v "$(pwd)":/workspace bludvim:latest chown -R $(id -u):$(id -g) /workspace
```

### **Storage Issues**
```bash
# Check volumes
docker volume ls

# Clean up volumes
docker volume prune
```