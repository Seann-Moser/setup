#!/bin/bash
upgrade=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --upgrade)
      upgrade=true
      shift # Remove --upgrade from the list of arguments
      ;;
    *)
      # Unknown option
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Determine OS
UNAME_S=$(uname -s)
mkdir -p ~/go/src/github.com/Seann-Moser

# Function to check and install Homebrew
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi
}

# Define install commands
if [ "$UNAME_S" = "Darwin" ]; then
    check_homebrew
    INSTALL_CMD="brew install"
    PACKAGE_MANAGER="brew"
    UPGRADE_CMD="brew upgrade"
elif [ "$UNAME_S" = "Linux" ]; then
    check_homebrew
    INSTALL_CMD="sudo apt-get install -y"
    PACKAGE_MANAGER="apt-get"
    UPGRADE_CMD="sudo apt-get upgrade -y"
else
    echo "Unsupported OS: $UNAME_S"
    exit 1
fi

# Function to check and install a package
install_package() {
    local pkg=$1
    local check_cmd=$2
    local override=$3
    local cask=$4
    if ! command -v $check_cmd &> /dev/null; then
        echo "Installing $pkg..."
        if [ "$PACKAGE_MANAGER" = "brew" ]; then
            if [ "$cask" = "true" ]; then
                brew install --cask $pkg
            else
                brew install $pkg
            fi

        else
            sudo apt-get update
            sudo apt-get install -y $pkg
        fi
    elif ! $upgrade; then
         echo "$pkg is already installed."
    else
        echo "$pkg is already installed. Upgrading..."
        if [ "$override" = "brew" ]; then
            brew upgrade $pkg
        elif [ "$PACKAGE_MANAGER" = "brew" ]; then
            brew upgrade $pkg
        else
            sudo apt-get update
            sudo apt-get upgrade -y $pkg
        fi
    fi
}

# Function to install nvm
install_nvm() {
    if [ -d "$HOME/.nvm" ]; then
        echo "NVM is already installed."
    else
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    fi
}

install_terminal() {
    # Determine the operating system
    OS=$(uname)

    if [[ "$OS" == "Linux" ]]; then
        # Check if kitty is already installed
        if ! command -v kitty &> /dev/null; then
            echo "Kitty is not installed. Installing now..."
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

            # Setup desktop integration for kitty after installation
            echo "Setting up desktop integration for Kitty..."
            ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
            cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
            cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
            sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
            sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
            echo 'kitty.desktop' > ~/.config/xdg-terminals.list
        else
            echo "Kitty is already installed. Setting up desktop integration..."

            # Setup desktop integration for kitty if it is already installed
            ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
            cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
            cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
            sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
            sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
            echo 'kitty.desktop' > ~/.config/xdg-terminals.list
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        # Check if iTerm2 is already installed
        if ! command -v iterm2 &> /dev/null && ! [ -d "/Applications/iTerm.app" ]; then
            echo "iTerm2 is not installed. Installing now..."
            brew install --cask iterm2
        else
            echo "iTerm2 is already installed."
        fi
    else
        echo "Unsupported operating system. Skipping terminal installation."
    fi
}


# Function to install Docker
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        if [ "$UNAME_S" = "Darwin" ]; then
            brew install --cask docker
        elif [ "$UNAME_S" = "Linux" ]; then
            sudo apt-get update
            sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        fi
        sudo usermod -aG docker $USER
        echo "Docker installed. You may need to restart your session for group changes to take effect."
        elif ! $upgrade; then
             echo "$pkg is already installed."
        else
            echo "Docker is already installed. Upgrading..."
            if [ "$UNAME_S" = "Darwin" ]; then
                brew upgrade --cask docker
            elif [ "$UNAME_S" = "Linux" ]; then
                sudo apt-get update
                sudo apt-get upgrade -y docker-ce docker-ce-cli containerd.io
            fi
        fi
}

install_tpm() {
    # Define the TPM directory
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    # Check if TPM is already installed
    if [ -d "$tpm_dir" ]; then
        echo "TPM is already installed at $tpm_dir."
    else
        # Clone the TPM repository to the specified directory
        echo "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"

        # Check if the installation was successful
        if [ -d "$tpm_dir" ]; then
            echo "TPM installed successfully."
        else
            echo "Failed to install TPM."
        fi

        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
}


# Function to install Nerd Fonts
install_nerd_fonts() {
    local font="$1"

    local font_dir
    if [ "$UNAME_S" = "Darwin" ]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi

    local files_found=0
    for file in "$font_dir"/"$font"*; do
      if [[ -e "$file" ]]; then
        files_found=1
        break
      fi
    done

    if [[ $files_found -eq 0 ]]; then
        echo "Installing Nerd Fonts($font)..."
        mkdir -p "$font_dir"
        # cd /tmp
        wget -P $font_dir "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/$font.zip" \
        && cd ~/.local/share/fonts \
        && unzip "$font.zip" \
        && rm "$font.zip" \
        && fc-cache -fv
        echo "Nerd Fonts($font) installed."
    else
        echo "Nerd Fonts($font) are already installed."
    fi
}

# Install packages
install_package "golang" "go" "brew"
install_package "python3" "python3"
install_package "zsh" "zsh"
install_package "neovim" "nvim"
install_package "tmux" "tmux"
install_package "1password-cli" "op"
install_package "git" "git"
install_package "libnotify-bin" "notify-send"
install_package "zed" "zed"
install_package "jetbrains-toolbox" "jetbrains-toolbox" "" "true"
install_package "wget" "wget"
install_package "1password" "1password" "" "true"
install_package "1password-cli" "1password-cli" "" ""
install_package "fzf" "fzf"
install_package "protobuf" "protogs"
install_package "golangci-lint" "golangci-lint" "brew"

# install_package "fonts-font-awesome" "fonts-font-awesome"
install_nvm
install_docker
install_nerd_fonts "JetBrainsMono"
install_nerd_fonts "MartianMono"
install_nerd_fonts "ProFont"
install_nerd_fonts "ZedMono"
install_tpm
install_terminal

echo "All specified applications have been checked and installed if necessary."

make update-config
