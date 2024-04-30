# tools-git-hooks

# Usage
There is a `install-git-hooks.sh` script at the top-level which
is meant to be executed via curl directly within any workspace for
any repository.  This should be executed with your CWD being within
the git workspace you want to install it in.

Initially it is used to install the prepare-commit-msg
hook.

```
curl -s https://raw.githubusercontent.com/Maia-Tech/tools-git-hooks/main/install_git_hooks.sh | bash
```

You can set up an alias in your bashrc:

```
alias install_git_hooks="curl -s https://raw.githubusercontent.com/Maia-Tech/tools-git-hooks/main/install_git_hooks.sh | bash"
```
