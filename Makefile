STOW_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET_DIR := $(HOME)
DRY_RUN := $(if $(DRY_RUN),1)
STOW_FLAGS := $(if $(DRY_RUN),-n)
XDG_BIN_HOME := $(TARGET_DIR)/.local/bin
XDG_DATA_HOME := $(TARGET_DIR)/.local/share
XDG_CACHE_HOME := $(TARGET_DIR)/.cache
XDG_CONFIG_HOME := $(TARGET_DIR)/.config
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

ZSH_CONFIG_DIR := $(TARGET_DIR)/.config/zsh
ZSH_DATA_DIR := $(XDG_DATA_HOME)/zsh/completions
ZSH_CACHE_DIR := $(XDG_CACHE_HOME)/zsh

$(ZSH_CONFIG_DIR):
	$(RUN) mkdir -p "$@"

$(ZSH_DATA_DIR):
	$(RUN) mkdir -p "$@"

$(ZSH_CACHE_DIR):
	$(RUN) mkdir -p "$@"

zsh: $(ZSH_CACHE_DIR) $(ZSH_CONFIG_DIR) $(ZSH_DATA_DIR) config
	@echo " > Stowing zsh configuration..."
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target="$(TARGET_DIR)" zsh2

unzsh:
	@echo " > Unstowing zsh configurations..."
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target="$(TARGET_DIR)" zsh2


# }}} /ZSH 

# Local binaries
# BIN {{{
.PHONY: bin unbin

$(XDG_BIN_HOME):
	$(RUN) mkdir -p "$@"

bin: $(XDG_BIN_HOME)
	stow -v $(STOW_FLAGS) --target="$(XDG_BIN_HOME)" bin

unbin:
	stow -v -D $(STOW_FLAGS) --target="$(XDG_BIN_HOME)" bin

# }}} /BIN

# Config directory contains fully linkable things only
# CONFIG {{{
.PHONY: config unconfig

$(XDG_CONFIG_HOME):
	$(RUN) mkdir -p "$@"

config: $(XDG_CONFIG_HOME)
	@echo " > Stowing .config"
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target="$(XDG_CONFIG_HOME)" config

unconfig:
	@echo " > Unstowing .config"
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target="$(XDG_CONFIG_HOME)" config

# }}} /.config

# NVIM 0.12 {{{
.PHONY: nvim unnvim

$(XDG_CONFIG_HOME)/nvim:
	$(RUN) mkdir -p "$@"

nvim: $(XDG_CONFIG_HOME)/nvim
	@echo " > Stowing nvim 0.12"
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target="$(XDG_CONFIG_HOME)/nvim" nvim

unnvim:
	@echo " > Unstowing nvim 0.12"
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target="$(XDG_CONFIG_HOME)/nvim" nvim

# }}} /NVIM 0.12

# GPG config.
.PHONY: gnupg ungnupg

$(TARGET_DIR)/.gnupg:
	$(RUN) mkdir -p "$@"

gnupg: $(TARGET_DIR)/.gnupg
	@echo " > Stowing gnupg..."
	cd $(STOW_DIR) && stow -v $(STOW_FLAGS) --target="$(TARGET_DIR)/.gnupg/" gnupg

ungnupg:
	@echo " > Unstowing gnupg..."
	cd $(STOW_DIR) && stow -v -D $(STOW_FLAGS) --target="$(TARGET_DIR)/.gnupg/" gnupg
