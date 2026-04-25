export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"

# Install completions
# asdf completion zsh > ~/.local/share/zsh/completions/_asdf

path=("$ASDF_DATA_DIR/shims" $path)
