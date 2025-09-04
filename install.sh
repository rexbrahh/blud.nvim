#!/bin/bash

# BludVim - Dockerized Neovim Configuration Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/rexbrahh/.nvim/main/install.sh | bash

set -e

REPO_URL="https://github.com/rexbrahh/.nvim"
INSTALL_DIR="$HOME/.bludvim"
BINARY_NAME="bludvim"
BINARY_PATH="/usr/local/bin/$BINARY_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first: https://docs.docker.com/get-docker/"
    fi
    
    if ! docker info &> /dev/null; then
        error "Docker daemon is not running. Please start Docker first."
    fi
}

# Check if Docker Compose is available
check_docker_compose() {
    if ! docker compose version &> /dev/null && ! docker-compose --version &> /dev/null; then
        warning "Docker Compose not found. Using docker run commands instead."
        return 1
    fi
    return 0
}

# Clone or update the repository
setup_repo() {
    info "Setting up BludVim..."
    
    if [ -d "$INSTALL_DIR" ]; then
        info "Updating existing installation..."
        cd "$INSTALL_DIR"
        git pull origin main
    else
        info "Cloning BludVim configuration..."
        git clone "$REPO_URL" "$INSTALL_DIR"
    fi
}

# Build Docker image
build_image() {
    info "Building Docker image (this may take a few minutes)..."
    cd "$INSTALL_DIR"
    docker build -t bludvim:latest .
    success "Docker image built successfully!"
}

# Create wrapper script
create_wrapper() {
    info "Creating wrapper script..."
    
    # Create the wrapper script content
    cat > "$INSTALL_DIR/bludvim" << 'EOF'
#!/bin/bash

# BludVim Docker wrapper script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="bludvim:latest"

# Function to run with docker-compose if available
run_with_compose() {
    cd "$SCRIPT_DIR"
    if [ -f "docker-compose.yml" ] && (docker compose version &> /dev/null || docker-compose --version &> /dev/null); then
        if docker compose version &> /dev/null; then
            docker compose run --rm nvim "$@"
        else
            docker-compose run --rm nvim "$@"
        fi
    else
        run_with_docker "$@"
    fi
}

# Function to run with plain docker
run_with_docker() {
    docker run -it --rm \
        -v "$(pwd)":/workspace \
        -v nvim_data:/home/nvim/.local/share/nvim \
        -v nvim_cache:/home/nvim/.cache/nvim \
        -v "$HOME/.ssh":/home/nvim/.ssh:ro \
        -v "$HOME/.gitconfig":/home/nvim/.gitconfig:ro \
        -e TERM=xterm-256color \
        -e COLORTERM=truecolor \
        --name bludvim-$(date +%s) \
        "$IMAGE_NAME" "$@"
}

# Check if image exists
if ! docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo "BludVim Docker image not found. Please run: bludvim --build"
    exit 1
fi

# Handle special commands
case "${1:-}" in
    --build)
        echo "Building BludVim Docker image..."
        cd "$SCRIPT_DIR"
        docker build -t "$IMAGE_NAME" .
        echo "Build complete!"
        exit 0
        ;;
    --update)
        echo "Updating BludVim..."
        cd "$SCRIPT_DIR"
        git pull origin main
        docker build -t "$IMAGE_NAME" .
        echo "Update complete!"
        exit 0
        ;;
    --uninstall)
        echo "Uninstalling BludVim..."
        docker rmi "$IMAGE_NAME" 2>/dev/null || true
        docker volume rm nvim_data nvim_cache 2>/dev/null || true
        sudo rm -f "/usr/local/bin/bludvim" 2>/dev/null || rm -f "$HOME/.local/bin/bludvim"
        rm -rf "$SCRIPT_DIR"
        echo "BludVim uninstalled successfully!"
        exit 0
        ;;
    --help)
        echo "BludVim - Dockerized Neovim Configuration"
        echo
        echo "Usage:"
        echo "  bludvim [file...]     Start nvim with optional files"
        echo "  bludvim --build       Rebuild the Docker image"
        echo "  bludvim --update      Update BludVim and rebuild"
        echo "  bludvim --uninstall   Remove BludVim completely"
        echo "  bludvim --help        Show this help"
        echo
        echo "Examples:"
        echo "  bludvim               Open nvim in current directory"
        echo "  bludvim file.txt      Open specific file"
        echo "  bludvim .             Open file explorer in current directory"
        exit 0
        ;;
esac

# Run nvim with provided arguments
run_with_compose "$@"
EOF

    chmod +x "$INSTALL_DIR/bludvim"
}

# Install wrapper script globally
install_globally() {
    info "Installing bludvim command globally..."
    
    # Try to install to /usr/local/bin (requires sudo)
    if sudo cp "$INSTALL_DIR/bludvim" "$BINARY_PATH" 2>/dev/null; then
        success "Installed to $BINARY_PATH"
    else
        # Fallback to user bin directory
        USER_BIN="$HOME/.local/bin"
        mkdir -p "$USER_BIN"
        cp "$INSTALL_DIR/bludvim" "$USER_BIN/bludvim"
        success "Installed to $USER_BIN/bludvim"
        
        # Check if user bin is in PATH
        if [[ ":$PATH:" != *":$USER_BIN:"* ]]; then
            warning "Add $USER_BIN to your PATH to use 'bludvim' command:"
            echo "export PATH=\"\$PATH:$USER_BIN\""
        fi
    fi
}

# Main installation process
main() {
    echo "╭─────────────────────────────────────────────────────╮"
    echo "│                   BludVim                          │"
    echo "│           Docker Neovim Configuration              │"
    echo "╰─────────────────────────────────────────────────────╯"
    echo
    
    check_docker
    setup_repo
    build_image
    create_wrapper
    install_globally
    
    echo
    success "BludVim installed successfully!"
    echo
    info "Usage:"
    echo "  bludvim              - Start nvim in current directory"
    echo "  bludvim file.txt     - Open specific file"
    echo "  bludvim --help       - Show help"
    echo "  bludvim --update     - Update BludVim"
    echo "  bludvim --uninstall  - Remove BludVim"
    echo
    info "Try it now: cd to any project directory and run 'bludvim'"
}

main "$@"