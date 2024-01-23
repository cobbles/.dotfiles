# .dotfiles

ansible script to set up my pc

## Ubuntu

```shell
wget -O - https://raw.githubusercontent.com/cobbles/.dotfiles/main/ubuntu | sh
```

```shell
ansible-pull -U https://github.com/cobbles/.dotfiles.git
```

## Run playbook on the locally checked out repo

```shell
git clone https://github.com/cobbles/.dotfiles.git
cd .dotfiles
ansible-playbook local.yml
```

## Run playbook for a specific tag

```shell
ansible-playbook -t ssh local.yml
```
