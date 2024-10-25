SRC_DIR := ./nvm_config
DEST_DIR := $(HOME)/.config/nvim

TMUX_SRC_DIR := ./tmux
TMUX_DEST_DIR := $(HOME)/.config/tmux

ENV_SRC_DIR := ./env
ENV_DEST_DIR := $(HOME)/.oh-my-zsh/custom

CUSTOM_DIR := $(HOME)/.custom
BASHRC := $(HOME)/.zshrc
# Target to copy files and remove old config
update-config: clean-config copy-config refresh#update-bashrc

# Target to remove the old configuration directories if they exist
clean-config:
	@if [ -d "$(DEST_DIR)" ]; then \
		echo "Removing old nvim configuration at $(DEST_DIR)..."; \
		rm -rf $(DEST_DIR); \
	else \
		echo "No existing nvim configuration to remove."; \
	fi
	@if [ -d "$(TMUX_DEST_DIR)" ]; then \
		echo "Removing old tmux configuration at $(TMUX_DEST_DIR)..."; \
		rm -rf $(TMUX_DEST_DIR)/tmux.conf; \
	else \
		echo "No existing tmux configuration to remove."; \
	fi
	@if [ -d "$(ENV_DEST_DIR)" ]; then \
		echo "Removing old environment files at $(ENV_DEST_DIR)..."; \
		rm -rf $(ENV_DEST_DIR)/*.zsh; \
	else \
		echo "No existing environment files to remove."; \
	fi

# Target to copy files from source to destination directories
copy-config:
	@mkdir -p $(DEST_DIR)
	@cp -r $(SRC_DIR)/* $(DEST_DIR)
	@echo "nvim configuration files copied from $(SRC_DIR) to $(DEST_DIR)."

	@mkdir -p $(TMUX_DEST_DIR)
	@cp -r $(TMUX_SRC_DIR)/* $(TMUX_DEST_DIR)
	@echo "tmux configuration files copied from $(TMUX_SRC_DIR) to $(TMUX_DEST_DIR)."

	@mkdir -p $(ENV_DEST_DIR)
	@cp -r $(ENV_SRC_DIR)/* $(ENV_DEST_DIR)
	@echo "Environment files copied from $(ENV_SRC_DIR) to $(ENV_DEST_DIR)."



# Target to update .bashrc with the source loop
update-bashrc:
	@echo "Checking if the loop already exists in $(BASHRC)..."
	@if ! grep -q "for file in" "$(BASHRC)"; then \
		cat bashloader.txt >> "$(BASHRC)"; \
		echo "Loop not found. Updating $(BASHRC)..."; \
		# echo "" >> "$(BASHRC)"; \
		# echo "# Sourcing all .sh files in $(CUSTOM_DIR)" >> "$(BASHRC)"; \
		# echo "for file in $(CUSTOM_DIR)/*.sh; do" >> "$(BASHRC)"; \
		# echo "  [ -r \"$$file\" ] && source \"$file\"" >> "$(BASHRC)"; \
		# echo "done" >> "$(BASHRC)"; \
		echo "Update complete."; \
	else \
		echo "Loop already exists in $(BASHRC). No update needed."; \
	fi


# Default target
.PHONY: update-config clean-config copy-config update-bashrc refresh
