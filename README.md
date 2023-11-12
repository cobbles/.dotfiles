# ansible

## Install ansible

```shell
curl fsSL https://raw.githubusercontent.com/cobbles/ansible/main/install | sh
```

## Run playbook from remote host

```shell
ansible-pull --ask-vault-pass -U https://github.com/cobbles/ansible.git
```

## Run playbook on the locally checked out repo

```shell
ansible-playbook --ask-vault-pass local.yml
```

## Run playbook for a specific tag

```shell
ansible-playbook -t ssh --ask-vault-pass local.yml
```
