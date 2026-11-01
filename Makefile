# Define the build directory path
BUILD_DIR = /Users/vovatakeda/Desktop/QtProjects/secondInstance/build-ChatClient_QML_migrate-Qt_6_6_1_for_macOS-Debug

# Define patterns for target cleanup
DIALOG_FILE = $(BUILD_DIR)/dialogs
IMAGE_FOLDERS = $(BUILD_DIR)/images
SETTINGS_FILE = $(BUILD_DIR)/settings.ini

# Cleanup function
.PHONY: clean-mac
clean-mac:
	@echo "Cleaning up 'dialog' files and 'image' folders inside $(BUILD_DIR)..."
	rm -f $(DIALOG_FILE)
	rm -f $(SETTINGS_FILE)
	rm -rf $(IMAGE_FOLDERS)
	@echo "Specified files and folders cleaned!"
	
# Cleanup function
.PHONY: clean-windows
clean-windows:
	@echo "Cleaning up files and folders..." 
	@if (Test-Path "$(BUILD_DIR)\dialogs") { Remove-Item "$(BUILD_DIR)\dialogs" -Force }
	@if (Test-Path "$(BUILD_DIR)\settings.ini") { Remove-Item "$(BUILD_DIR)\settings.ini" -Force }
	@if (Test-Path "$(BUILD_DIR)\images") { Remove-Item "$(BUILD_DIR)\images" -Force -Recurse }
	@echo "Cleanup complete!"


# Example usage message
.PHONY: help
help:
	@echo "Targets available:"
	@echo "  clean        Remove all cache data so you can register user again"
	@echo "  Example: make clean"
