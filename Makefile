STOW_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET_DIR := $(HOME)
DRY_RUN := $(if $(DRY_RUN),1)
STOW_FLAGS := $(if $(DRY_RUN),-n)
XDG_BIN_HOME := $(TARGET_DIR)/.local/bin
XDG_DATA_HOME := $(TARGET_DIR)/.local/share
RUN := $(if $(DRY_RUN),@echo,@)

.PHONY: all install uninstall
all:
	@echo "Doing nothing."

install: bin zsh config nvim
	@echo "Done"

uninstall: unnvim unconfig unzsh unbin
	@echo "Done"

# ZSH {{{
.PHONY: zsh unzsh

$(TARGET_DIR)/.config/zsh:
	$(RUN) mkdir -p $(TARGET_DIR)/.config/zsh

$(XDG_DATA_HOME)/zsh/completions:
	$(RUN) mkdir -p $(XDG_DATA_HOME)/zsh/completions

zsh: $(TARGET_DIR)/.config/zsh $(XDG_DATA_HOME)/zsh/completions config
	@echo " > Stowing zsh configuration..."
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target=$(TARGET_DIR) zsh2

unzsh:
	@echo " > Unstowing zsh configurations..."
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target=$(TARGET_DIR) zsh2


# }}} /ZSH 

# Local binaries
# BIN {{{
.PHONY: bin unbin

$(XDG_BIN_HOME):
	$(RUN) mkdir -p "$(XDG_BIN_HOME)"

bin:
	stow -v $(STOW_FLAGS) --target=$(XDG_BIN_HOME) bin

unbin:
	stow -v -D $(STOW_FLAGS) --target=$(XDG_BIN_HOME) bin
	$(RUN) rmdir "$(XDG_BIN_HOME)"

# }}} /BIN

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
	$(RUN) mkdir -p $(TARGET_DIR)/.config/nvim

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
