# Multi-stage build for optimal image size
FROM alpine:3.20 AS base

# Install essential dependencies
RUN apk add --no-cache \
    neovim \
    git \
    curl \
    wget \
    unzip \
    tar \
    gzip \
    nodejs \
    npm \
    python3 \
    py3-pip \
    go \
    rust \
    cargo \
    bash \
    zsh \
    fish \
    tmux \
    ripgrep \
    fd \
    fzf \
    tree-sitter \
    openssh-client \
    ca-certificates \
    tzdata \
    && rm -rf /var/cache/apk/*

# Create nvim user
RUN adduser -D -s /bin/bash nvim

# Switch to nvim user
USER nvim
WORKDIR /home/nvim

# Clone the configuration
RUN git clone https://github.com/rexbrahh/.nvim.git /home/nvim/.config/nvim

# Pre-install lazy.nvim
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
    --branch=stable /home/nvim/.local/share/nvim/lazy/lazy.nvim

# Create necessary directories
RUN mkdir -p /home/nvim/.local/share/nvim/{mason,lazy} \
    && mkdir -p /home/nvim/.cache/nvim

# Set environment variables
ENV XDG_CONFIG_HOME=/home/nvim/.config
ENV XDG_DATA_HOME=/home/nvim/.local/share
ENV XDG_CACHE_HOME=/home/nvim/.cache

# Pre-install plugins and LSPs by running nvim headlessly
RUN nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

# Install LSPs via Mason
RUN nvim --headless "+MasonInstallAll" +qa 2>/dev/null || true

# Set shell to bash for better compatibility
ENV SHELL=/bin/bash

# Expose common development ports (optional)
EXPOSE 3000 8000 8080 4000 5000

# Set working directory for mounted projects
WORKDIR /workspace

# Default command
CMD ["nvim"]