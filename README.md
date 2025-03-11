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
sudo apt install cmake make gcc
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
