STOW_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET_DIR := $(HOME)
DRY_RUN := $(if $(DRY_RUN),1)
STOW_FLAGS := $(if $(DRY_RUN),-n)

.PHONY: all install uninstall
all:
	@echo "Doing nothing."

install: zsh config nvim
	@echo "Done"

uninstall: unnvim unconfig unzsh
	@echo "Done"

# ZSH {{{
.PHONY: zsh unzsh nodzsh unnodzsh

$(TARGET_DIR)/.oh-my-zsh:
	@echo " > Installing Oh My Zsh... $(DRY_RUN)"
	@echo "Downloading oh-my-zsh..."
ifneq ($(DRY_RUN),1)
	@git clone https://github.com/ohmyzsh/ohmyzsh.git $(TARGET_DIR)/.oh-my-zsh
else
	@echo "Dry run: Skipping download..."
	@mkdir -p $(TARGET_DIR)/.oh-my-zsh/themes
endif

nodzsh: $(TARGET_DIR)/.oh-my-zsh
	@echo " > Stowing zsh theme"
	cd $(STOW_DIR)/oh-my-zsh && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR)/.oh-my-zsh/themes themes
ifeq ($(DRY_RUN),1)
	-@rmdir ~/.oh-my-zsh/themes
	-@rmdir ~/.oh-my-zsh
endif

unnodzsh:
	@echo " > Unstowing zsh theme"
	cd $(STOW_DIR)/oh-my-zsh && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR)/.oh-my-zsh/themes themes

zsh: nodzsh
	@echo " > Stowing zsh configuration..."
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR) zsh

unzsh: unnodzsh
	@echo " > Unstowing zsh configurations..."
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR) zsh

# }}} /ZSH 

# Config directory contains fully linkable things only
# CONFIG {{{
.PHONY: config unconfig

config:
	@echo " > Stowing .config"
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR)/.config config

unconfig:
	@echo " > Unstowing .config"
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR)/.config config

# }}} /.config

# NVIM 0.12 {{{
.PHONY: nvim unnvim

$(TARGET_DIR)/.config/nvim:
	mkdir -p $(TARGET_DIR)/.config/nvim

nvim: $(TARGET_DIR)/.config/nvim
	@echo " > Stowing nvim 0.12"
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR)/.config/nvim nvim

unnvim:
	@echo " > Unstowing nvim 0.12"
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR)/.config/nvim nvim

# }}} /NVIM 0.12

# GPG config.
.PHONY: gnupg ungnupg

gnupg:
	@echo " > Stowing gnupg..."
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR)/.gnupg/ gnupg

ungnupg:
	@echo " > Unstowing gnupg..."
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR)/.gnupg/ gnupg
