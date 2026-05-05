# Mason does not provide linux/arm64 musl builds for every configured tool
# here, and clangd is currently linux/x64 glibc-only in the Mason registry.
ARG BASE_PLATFORM=linux/amd64
FROM --platform=${BASE_PLATFORM} debian:trixie-slim AS base

ARG NEOVIM_VERSION=0.11.7
ENV DEBIAN_FRONTEND=noninteractive

# Install essential dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        build-essential \
        ca-certificates \
        cargo \
        curl \
        fd-find \
        fish \
        fzf \
        git \
        golang \
        gzip \
        nodejs \
        npm \
        openssh-client \
        python3 \
        python3-pip \
        python3-venv \
        ripgrep \
        rustc \
        tar \
        tmux \
        tree-sitter-cli \
        tzdata \
        unzip \
        wget \
        xz-utils \
        zsh \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# Install the same stable Neovim target used by the local config.
RUN curl -fsSL "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
        -o /tmp/nvim-linux-x86_64.tar.gz \
    && tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C /opt \
    && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm /tmp/nvim-linux-x86_64.tar.gz \
    && nvim --version | head -n 1

# Create nvim user
RUN useradd --create-home --shell /bin/bash nvim

# Switch to nvim user
USER nvim
WORKDIR /home/nvim

# Copy the local configuration under test
COPY --chown=nvim:nvim . /home/nvim/.config/nvim

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
RUN nvim --headless "+Lazy! sync" +qa

# Install LSP/DAP packages via Mason and fail the image build on package errors.
RUN nvim --headless "+luafile /home/nvim/.config/nvim/scripts/docker-install-mason.lua" +qa

# Set shell to bash for better compatibility
ENV SHELL=/bin/bash

# Expose common development ports (optional)
EXPOSE 3000 8000 8080 4000 5000

# Set working directory for mounted projects
WORKDIR /workspace

# Default command
CMD ["nvim"]
