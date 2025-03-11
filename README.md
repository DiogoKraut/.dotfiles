# Prerequisites
## Update/Upgrade
```bash
sudo apt update
```
```bash
sudo apt upgrade
```
## Compilers
```bash
sudo apt install cmake make gcc libssl-dev
```

## Github ssh key (or use existing)
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
```bash
eval "$(ssh-agent -s)"
```
```bash
ssh-add ~/.ssh/id_ed25519
```

# Terminal
## Oh-my-zsh
```bash
sudo apt install zsh
```
```bash
chsh -s $(which zsh)
```
After cloning this repo to $HOME:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Tmux
We want the latest version of Tmux, which means compiling from source.
1. Download ncurses and libevent
   - [https://github.com/libevent/libevent/releases/tag/release-2.1.12-stable](https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz)
   - [https://invisible-mirror.net/archives/ncurses/](https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz)
2. run `./configure && make` for each lib.
