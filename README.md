# .dotfiles

ansible script to set up my pc

## Ubuntu

```shell
wget -O - https://raw.githubusercontent.com/cobbles/.dotfiles/main/ubuntu | sh
```

```shell
ansible-pull --ask-become-pass --ask-vault-pass -U https://github.com/cobbles/.dotfiles.git
```

## Run playbook on the locally checked out repo

```shell
git clone https://github.com/cobbles/.dotfiles.git
cd .dotfiles
ansible-playbook --ask-become-pass --ask-vault-pass --ask-become-user local.yml
```

## Run playbook for a specific tag

```shell
ansible-playbook -t ssh --ask-become-pass --ask-vault-pass local.yml
```
