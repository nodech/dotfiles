DOTFILES
=======

Here are my ZShell and VIM configs

#### Zshell
  * I use [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  * My configurations and plugins go to .zshrc file

#### VIM
  * I use [Vundle Package Manager](https://github.com/gmarik/Vundle.vim)
  * It's included in this repo (Better if you update)
  * Configurations and Plugins I use you can see .vimrc file
  * Don't forget to run `:PluginInstall`

### Multi Environment for VIM
You can have multiple environment for VIM, so if you want some plugins for CPP and others for node.js you can have it.

  1. Create environment .vimrc file in ~/.vim/configs/envName.vimrc
  2. Write your code just include template from ~/.vim/configs/default.vimrc
  3. start vim with that name first `vim cpp files`
  4. You're done.

Note: Code is in `.zshrc` for MultiEnv VIM...
TODO: Add mvim

##### Cloning

When you clone this repo, you can install everything to system by running `./save.js`.
Dependency for that is `node.js`
