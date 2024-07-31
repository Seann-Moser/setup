# Define the source and destination directories
SRC_DIR := ./nvm_config
DEST_DIR := $(HOME)/.config/nvim

# Target to copy files and remove old config
update-config: clean-config copy-config

# Target to remove the old configuration directory if it exists
clean-config:
	@if [ -d "$(DEST_DIR)" ]; then \
		echo "Removing old configuration at $(DEST_DIR)..."; \
		rm -rf $(DEST_DIR); \
	else \
		echo "No existing configuration to remove."; \
	fi

# Target to copy files from source to destination
copy-config:
	@mkdir -p $(DEST_DIR)
	@cp -r $(SRC_DIR)/* $(DEST_DIR)
	@echo "Configuration files copied from $(SRC_DIR) to $(DEST_DIR)."

# Default target
.PHONY: update-config clean-config copy-config
