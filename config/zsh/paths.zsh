# system local paths:
#   dotfile scripts
#   my binaries from `~/.local/opt` symlinked
#   Maybe PIP is here ?
#   ... ?
path+=("$HOME/.local/bin")
path+=("$HOME/.local/bin/wrappers")

# Custom system installations in userspace / AUR goes here.
custom_sys() {
  # Linux shared libs
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.custom_sys/lib"
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.custom_sys/usr/lib"
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.custom_sys/usr/local/lib"

  # Link-time
  export LIBRARY_PATH="$LIBRARY_PATH:$HOME/.custom_sys/lib"
  export LIBRARY_PATH="$LIBRARY_PATH:$HOME/.custom_sys/usr/lib"
  export LIBRARY_PATH="$LIBRARY_PATH:$HOME/.custom_sys/usr/local/lib"

  # macOS shared libs
  export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$HOME/.custom_sys/lib"
  export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$HOME/.custom_sys/usr/lib"
  export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$HOME/.custom_sys/usr/local/lib"

  # Compile using custom lib headers
  export C_INCLUDE_PATH="$C_INCLUDE_PATH:$HOME/.custom_sys/include"
  export C_INCLUDE_PATH="$C_INCLUDE_PATH:$HOME/.custom_sys/usr/include"
  export C_INCLUDE_PATH="$C_INCLUDE_PATH:$HOME/.custom_sys/usr/local/include"

  # Custom compiled projects.
  path+=("$HOME/.custom_sys/bin")
  path+=("$HOME/.custom_sys/usr/bin")
  path+=("$HOME/.custom_sys/usr/local/bin")
}
