# my own nvim configuration

<img width="3456" height="2234" alt="CleanShot 2025-08-21 at 18 08 03@2x" src="https://github.com/user-attachments/assets/87959379-5681-402e-b843-04c658283497" />
<img width="3456" height="2234" alt="CleanShot 2025-08-21 at 18 09 26@2x" src="https://github.com/user-attachments/assets/8be712b6-2931-4002-abcc-b17b23485e56" />

##  features

###  **transparent ui**
- Complete transparent interface with preserved cursor, selection, and search highlights
- Custom transparent statusline with essential information only
- Clean, distraction-free coding environment

###  **performance optimization**
- **Built-in profiling system** - Toggle with F1 key for performance analysis (WIP)
- Lazy loading for all plugins with optimized startup time
- Auto-save functionality with smart debouncing

###  **built-in dev tools**
- **20+ Language Servers** automatically installed via Mason
- **Tailwind CSS** integration with automatic class sorting across 30+ filetypes
- Template language support (Django, Jinja, HTML) with specialized highlighting
- Auto-tag closing for HTML/JSX components

###  **dual fuzzy finding**
- **Telescope** with FZF native for advanced searching (grep, files, LSP functions)
- **FZF-lua** for lightning-fast file operations
- Live preview for grep results with syntax highlighting

###  **auto completion**
- **Blink.cmp** - Next-generation completion engine
- VSCode-style snippets with custom templates
- Smart auto-completion with LSP integration

###  **smart navigation**
- **Harpoon 2** for instant file switching (5 quick slots)
- **Neo-tree** file explorer with Nerd Font icons and git integration
- **Flash.nvim** for precise cursor movement

## Language Support

### fully configured LSPs:
- **Web:** TypeScript/JavaScript (ts_ls, biome, eslint), HTML, CSS, Tailwind CSS, JSON
- **Backend:** Python (basedpyright, ruff, pyright), Go (gopls), Rust (rust_analyzer)
- **Systems:** C/C++ (clangd), Zig (zls), Lua (lua_ls), Bash
- **Config:** YAML, Markdown, Docker, Nix

### Smart Formatting:
- **Auto-formatting** on save with language-specific formatters
- **Biome** for JavaScript/TypeScript with rustywind for Tailwind
- **Black** for Python, **stylua** for Lua
- **Smart imports** and code organization

## Project Structure

```
~/.config/nvim/
├── init.lua                 # Entry point with Neovide support
├── lua/
│   ├── config/             # Core configuration
│   │   ├── settings.lua    # Neovim options
│   │   ├── keymaps.lua     # Global key mappings
│   │   └── lazy.lua        # Plugin manager setup
│   ├── plugins/            # Individual plugin configs (40+ plugins)
│   └── utils/              # Custom utilities
│       ├── highlights.lua  # Color manipulation functions
│       └── tailwind.lua    # Tailwind CSS helpers
├── after/ftplugin/         # Filetype-specific configs
├── snippets/               # Custom VSCode-style snippets
└── CLAUDE.md              # AI assistant guidance
```

##  Key Bindings

Leader key: `<Space>`

###  **Search & Navigation**
- `<leader>sf` - Find files (Telescope)
- `<leader>sg` - Live grep with preview
- `<leader>sr` - Recent files
- `<leader>fe` - Toggle file explorer (Neo-tree)
- `ma` - Add to Harpoon, `M` - Harpoon menu

###  **LSP & Development**
- `K` - Hover documentation
- `gd` - Go to definition
- `<leader>lr` - Find references
- `<leader>rn` - Smart rename
- `<leader>mp` - Format current buffer
- `<leader>mt` - Sort Tailwind classes

###  **UI & Utilities**
- `F1` - Toggle performance profiler
- `<C-p>` - Toggle Telescope preview (while in Telescope)
- Auto-save on buffer leave and text changes

## Try It Out

### 1. **Backup & Clean Slate**
```bash
# Backup your current config
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

### 2. **Clone & Test**
```bash
# Clone this configuration
git clone https://github.com/yourusername/nvim-config ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim
```

### 3. **First Launch**
- Lazy.nvim will automatically install all plugins
- LSP servers install automatically via Mason
- Wait for installations to complete (~2-3 minutes)
- Restart Neovim to ensure everything loads properly

### 4. **Try These Features**
```bash
# Open a project and test fuzzy finding
cd your-project
nvim .

# Try these commands inside Neovim:
:Telescope find_files
:Mason                    # View installed LSPs
:Lazy                     # Check plugin status
:Alpha                    # Return to dashboard
```

### 5. **Restore Original Config**
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

### System Dependencies (Auto-installed via Mason)
- Language servers, formatters, and linters install automatically
- No manual LSP installation required

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

## 🔧 Troubleshooting

### **Icons Not Displaying**
- Install a Nerd Font and set it in your terminal
- Restart terminal after font installation

### **LSP Not Working**
- Run `:Mason` to check LSP installation status
- Run `:LspInfo` to see active language servers
- Try `:MasonInstall <server-name>` for manual installation

### **Performance Issues**
- Use `F1` to toggle the built-in profiler
- Check `:Lazy profile` for plugin load times
- Disable unused plugins in their respective config files

### **Transparency Issues**
- Ensure terminal supports transparency
- Check terminal-specific transparency settings
- Some terminals may not support full transparency

## License

MIT License - feel free to fork, modify, and share!

##  Acknowledgments

Built with these amazing projects:
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [Blink.cmp](https://github.com/saghen/blink.cmp) - Completion engine
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [Mason](https://github.com/williamboman/mason.nvim) - LSP installer

---

**Happy Coding! 🎉**

*This configuration is constantly evolving. Star ⭐ the repo to stay updated with the latest features!*
