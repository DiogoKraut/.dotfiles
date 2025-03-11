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
sudo apt install cmake make gcc libssl-dev automake autotools-dev libevent-dev yacc
```
## Python (pyenv)
```bash
curl -fsSL https://pyenv.run | bash
```
```bash
pyenv install 3.11
pyenv global 3.11
```

## Node
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
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
1. Download ncurses-6.1 and libevent
   - [https://github.com/libevent/libevent/releases/tag/release-2.1.12-stable](https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz)
   - [https://invisible-mirror.net/archives/ncurses/](https://invisible-mirror.net/archives/ncurses/ncurses-6.1.tar.gz)
2. run `./configure && make` for each lib.
3. Install tmux from source control
   ```bash
   git clone https://github.com/tmux/tmux.git
   cd tmux
   sh autogen.sh
   ./configure && make
   ```
4. Make sure TPM is correctly cloned into ~/.tmux/plugins/tpm
   - https://github.com/tmux-plugins/tpm
5. `prefix + I` to make sure plugins are installed

## NeoVim
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```
Make sure to check if the opt path is added to .zshrc
