# my own nvim configuration

<img width="3456" height="2234" alt="Ghostty 2025-09-13 19 45 58" src="https://github.com/user-attachments/assets/e3331096-da06-479b-b1d7-ab297bb4e842" />

<img width="3456" height="2234" alt="Ghostty 2025-09-13 19 46 10" src="https://github.com/user-attachments/assets/4d79a921-bfad-4b98-b54c-9324dbc4bbe7" />

<img width="3456" height="2234" alt="Ghostty 2025-09-13 19 46 26" src="https://github.com/user-attachments/assets/8decaba1-a6ce-440d-8815-5c0725619c02" />

<img width="3456" height="2234" alt="Ghostty 2025-09-13 19 46 37" src="https://github.com/user-attachments/assets/a39d22c4-0ad8-415b-922b-e450341b8706" />

## installation:

### 1. **Backup & Clean Slate**
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

### 2. **Clone & Test**
```bash
git clone https://github.com/rexbrahh/blud.nvim.git ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim
```

### Optionally this one-liner:
```bash
curl -fsSL https://raw.githubusercontent.com/rexbrahh/blud.nvim/main/install.sh | bash
```

### Or with docker
```bash
# Test command - just prints version
docker run --rm \
  -v "$(pwd)":/workspace \
  bludvim:latest nvim --version
```
```bash
# interactive mode
docker run -it --rm \
  -v "$(pwd)":/workspace \
  -v "$HOME/.ssh":/home/nvim/.ssh:ro \
  -v "$HOME/.gitconfig":/home/nvim/.gitconfig:ro \
  -e TERM=xterm-256color \
  -e COLORTERM=truecolor \
  bludvim:latest
```
### Or try it with my docker image
```bash
  docker pull ghcr.io/rexbrahh/blud.nvim:sha256-082e52133450504a35828c5c8dd40e62963bd8c03b399381b2032890cd2278f2.sig
```

### **Restore Original Config**
```bash
# Remove test config
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Restore your backup
mv ~/.config/nvim.backup ~/.config/nvim
mv ~/.local/share/nvim.backup ~/.local/share/nvim
```

##  Requirements

- **Neovim 0.10+** (required for modern plugin compatibility)
- **Nerd Font** - For icons (MesloLGLDZ Nerd Font recommended)
- **Git** - For plugin management
- **Node.js** - For LSP servers
- **Python 3** - For Python LSPs
- **Rust** - For rust-analyzer (optional)
- **Go** - For gopls (optional)
  
##  Customization

### **Transparency**
The full transparency is configured in:
- `lua/plugins/transparency.lua` - Main transparency plugin
- `lua/utils/highlights.lua` - Manual transparency overrides

### **LSP Configuration**
Add new language servers in `lua/plugins/lsp-config.lua` and `lua/plugins/mason.lua`

### **Key Bindings**
Modify mappings in `lua/config/keymaps.lua` and individual plugin configs

### **Theme & Colors**
Customize colors in `lua/plugins/colorschemes.lua` and highlight utilities


