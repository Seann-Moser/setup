if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"  # For Apple Silicon
    # eval "$(/usr/local/bin/brew shellenv)"  # Uncomment this line for Intel Macs if needed
fi
