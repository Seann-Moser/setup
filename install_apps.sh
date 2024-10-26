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

install_k9s_catppuccin_theme() {
    set -e  # Exit immediately if a command exits with a non-zero status


    # Clone the Catppuccin/k9s theme repository
    echo "Cloning Catppuccin k9s theme repository..."
    # Define install commands
    if [ "$UNAME_S" = "Darwin" ]; then
        OUT="${XDG_CONFIG_HOME:-$HOME/Library/Application Support}/k9s/skins"
        mkdir -p "$OUT"
        curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist
    elif [ "$UNAME_S" = "Linux" ]; then
        OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
        mkdir -p "$OUT"
        curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz | tar xz -C "$OUT" --strip-components=2 k9s-main/dist
    else
        echo "Unsupported OS: $UNAME_S"
        exit 1
    fi


    # Create the k9s config directory if it doesn't exist
    mkdir -p ~/.k9s

    # Backup existing config.yml if it exists
    if [ -f ~/.config/k9s/config.yaml ]; then
        echo "Backing up existing ~/.config/k9s/config.yaml to ~/.config/k9s/config.yaml.backup"
        cp ~/.config/k9s/config.yaml ~/.config/k9s/config.yml.backup
    fi

    # Apply the theme configuration
    if [ -f "$TEMP_DIR/catppuccin-k9s/config.yaml" ]; then
        echo "Applying Catppuccin theme from repository..."
        cp "$TEMP_DIR/catppuccin-k9s/config.yaml" ~/.k9s/config.yaml
    else
        echo "config.yml not found in the repository. Applying default Catppuccin theme configuration..."
        cat <<EOF > ~/.config/k9s/config.yaml
k9s:
  liveViewAutoRefresh: false
  screenDumpDir: ${HOME}/.local/state/k9s/screen-dumps
  refreshRate: 2
  maxConnRetry: 5
  readOnly: false
  noExitOnCtrlC: false
  ui:
    skin: catppuccin-mocha
    enableMouse: false
    headless: false
    logoless: false
    crumbsless: false
    reactive: false
    noIcons: false
    defaultsToFullScreen: false
  skipLatestRevCheck: false
  disablePodCounting: false
  shellPod:
    image: busybox:1.35.0
    namespace: default
    limits:
      cpu: 100m
      memory: 100Mi
  imageScans:
    enable: false
    exclusions:
      namespaces: []
      labels: {}
  logger:
    tail: 100
    buffer: 5000
    sinceSeconds: -1
    textWrap: false
    showTime: false
  thresholds:
    cpu:
      critical: 90
      warn: 70
    memory:
      critical: 90
      warn: 70
EOF
        echo "Default Catppuccin theme configuration applied."
    fi

    # Clean up temporary directory
    rm -rf "$TEMP_DIR"

    # Set the K9S_STYLE environment variable
    SHELL_PROFILE=""
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_PROFILE="$HOME/.bashrc"
    else
        # Default to .bashrc if shell is not bash or zsh
        SHELL_PROFILE="$HOME/.bashrc"
    fi

    # Check if K9S_STYLE is already set in the profile
    if grep -q 'export K9S_STYLE=' "$SHELL_PROFILE"; then
        echo "K9S_STYLE is already set in $SHELL_PROFILE. Updating it to 'catppuccin'."
        sed -i.bak '/export K9S_STYLE=/c\export K9S_STYLE="catppuccin"' "$SHELL_PROFILE"
    else
        echo 'export K9S_STYLE="catppuccin"' >> "$SHELL_PROFILE"
    fi

    # Inform the user to reload their shell
    echo "Please reload your shell or run 'source $SHELL_PROFILE' to apply the changes."

    echo "k9s with Catppuccin theme installed successfully."
}

# To use the function, simply copy and paste it into your terminal, then run:
# install_k9s_catppuccin_theme


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
            return 1
        fi
    fi

    # Install zsh plugins and theme
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

install_catppuccin() {
    # Define the Catppuccin directory
    local catppuccin_dir="$HOME/.config/tmux/plugins/catppuccin/tmux"

    # Check if the Catppuccin theme is already installed
    if [ -d "$catppuccin_dir" ]; then
        echo "Catppuccin theme already exists. Updating..."
        git -C "$catppuccin_dir" pull
    else
        # Install the Catppuccin theme
        echo "Installing Catppuccin theme for tmux..."
        mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
        git clone -b v2.0.0 https://github.com/catppuccin/tmux.git "$catppuccin_dir"

        # Check if Catppuccin installation was successful
        if [ -d "$catppuccin_dir" ]; then
            echo "Catppuccin theme installed successfully."
        else
            echo "Failed to install Catppuccin theme."
            return 1
        fi
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
install_k9s_catppuccin_theme
# Call the install_catppuccin function to handle the Catppuccin installation
#mkdir -p ~/.config/tmux/plugins/catppuccin 
#git clone -b v2.0.0 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
install_catppuccin
install_terminal

echo "All specified applications have been checked and installed if necessary."

make update-config
