SHELL := /bin/bash

# Determine OS
UNAME_S := $(shell uname -s)

# Define package managers and install commands
BREW_INSTALL = /bin/bash -c $$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
APT_INSTALL = sudo apt-get update && sudo apt-get install -y

# Check and install Homebrew
ifeq ($(UNAME_S),Darwin)
    PKG_MGR := brew
    INSTALL := brew install
    CHECK_BREW := brew --version
else ifeq ($(UNAME_S),Linux)
    ifeq ($(shell command -v brew 2>/dev/null),)
        $(BREW_INSTALL)
    endif
    PKG_MGR := apt-get
    INSTALL := sudo apt-get install -y
    CHECK_BREW := brew --version
endif

.PHONY: all check_brew golang python3 zsh neovim tmux 1password-cli git

all: check_brew golang python3 zsh neovim tmux 1password-cli git

check_brew:
ifeq ($(shell command -v brew 2>/dev/null),)
    @echo "Installing Homebrew..."
    $(BREW_INSTALL)
else
    @echo "Homebrew is already installed."
endif

golang:
ifeq ($(shell command -v go 2>/dev/null),)
    @echo "Installing Golang..."
    $(INSTALL) go
else
    @echo "Golang is already installed."
endif

python3:
ifeq ($(shell command -v python3 2>/dev/null),)
    @echo "Installing Python3..."
    $(INSTALL) python3
else
    @echo "Python3 is already installed."
endif

zsh:
ifeq ($(shell command -v zsh 2>/dev/null),)
    @echo "Installing Zsh..."
    $(INSTALL) zsh
else
    @echo "Zsh is already installed."
endif

neovim:
ifeq ($(shell command -v nvim 2>/dev/null),)
    @echo "Installing Neovim..."
    $(INSTALL) neovim
else
    @echo "Neovim is already installed."
endif

tmux:
ifeq ($(shell command -v tmux 2>/dev/null),)
    @echo "Installing Tmux..."
    $(INSTALL) tmux
else
    @echo "Tmux is already installed."
endif

1password-cli:
ifeq ($(shell command -v op 2>/dev/null),)
    @echo "Installing 1Password CLI..."
    $(INSTALL) 1password-cli
else
    @echo "1Password CLI is already installed."
endif

git:
ifeq ($(shell command -v git 2>/dev/null),)
    @echo "Installing Git..."
    $(INSTALL) git
else
    @echo "Git is already installed."
endif
