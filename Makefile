# Define the build directory path
BUILD_DIR = 

# Define patterns for target cleanup
DIALOG_FILE = $(BUILD_DIR)/dialogs
IMAGE_FOLDERS = $(BUILD_DIR)/images
SETTINGS_FILE = $(BUILD_DIR)/settings.ini

# Cleanup function
.PHONY: clean
clean:
	@echo "Cleaning up 'dialog' files and 'image' folders inside $(BUILD_DIR)..."
	rm -f $(DIALOG_FILE)
	rm -f $(SETTINGS_FILE)
	rm -rf $(IMAGE_FOLDERS)
	@echo "Specified files and folders cleaned!"

# Example usage message
.PHONY: help
help:
	@echo "Targets available:"
	@echo "  clean        Remove all cache data so you can register user again"
	@echo "  Example: make clean"
