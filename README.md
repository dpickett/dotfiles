Dan Pickett's dotfiles
==

personal configurations for zsh, vim, and git related items

Use
--

* backup your dotfiles (homesick will ask you if you want to overwrite files on symlink) 
* install [ohmyzsh](https://github.com/robbyrussell/oh-my-zsh)
* execute the following:

```
  #> gem install homesick
  #> homesick clone dpickett/dotfiles
  #> homesick symlink dpickett/dotfiles
```

To update vim bundles with pathogen once you've symlinked:

```
  #> cd ~/.homesick/repos/dpickett/dotfiles/.vim && ./update_bundles
```

Read through the update_bundles script (it's ruby)- it will initialize your plugins - if you want to add or remove plugins, fork away!

VIM
--

uses pathogen and [Tammer Saleh's excellent update_bundles_command](http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen)

Includes the following plugins:

* nerdtree
* rails.vim
* fugitive.vim
* surround.vim
* cucumber.vim

ZSH
--

uses [ohmyzsh](https://github.com/robbyrussell/oh-my-zsh) to manage plugins and other goodies

* uses the re5et theme (two line)

uses the following ohmyzsh plugins:

* git 
* rails3 
* brew 
* bundler 
* ruby 
* compleat 
* rvm

gemrc
--

* passes --no-ri and --no-rdoc
 