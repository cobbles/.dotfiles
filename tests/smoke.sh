#!/usr/bin/env bash
# Smoke test a machine after the dotfiles are applied.
# Usage: tests/smoke.sh [--plugins]   (--plugins also checks the zsh/tmux plugins)

set -u

dotfiles=$(cd "$(dirname "$0")/.." && pwd)
plugins=false
[[ ${1:-} = --plugins ]] && plugins=true

failures=0
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

pass() { echo "ok   - $1"; }
fail() {
    echo "FAIL - $1"
    [[ -n ${2:-} ]] && sed 's/^/       /' "$2"
    failures=$((failures + 1))
}

# zsh starts cleanly (in a pty, like a real terminal)
if script -qec "zsh -i -c 'exit 0'" /dev/null </dev/null >"$tmp/zsh.err" 2>&1 && [[ ! -s $tmp/zsh.err ]]; then
    pass "zsh starts with no errors"
else
    fail "zsh starts with no errors" "$tmp/zsh.err"
fi

if $plugins; then
    if zsh -i -c 'typeset -f _zsh_autosuggest_start >/dev/null && (( ${+ZSH_HIGHLIGHT_VERSION} ))' </dev/null 2>/dev/null; then
        pass "zsh plugins loaded"
    else
        fail "zsh plugins loaded"
    fi
fi

# tmux loads its config
if tmux -L smoke -f ~/.tmux.conf new-session -d -s smoke 2>"$tmp/tmux.err" &&
    [[ $(tmux -L smoke show -gv prefix) = C-Space ]]; then
    pass "tmux loads config"
else
    fail "tmux loads config" "$tmp/tmux.err"
fi
if $plugins; then
    if tmux -L smoke show -gv status-left 2>/dev/null | grep -q '#\[bg='; then
        pass "tmux dracula theme applied"
    else
        fail "tmux dracula theme applied"
    fi
fi
tmux -L smoke kill-server 2>/dev/null

# nvim installs its plugins from the lockfile and starts cleanly
if nvim --headless "+Lazy! restore" +qa >"$tmp/lazy.out" 2>&1; then
    pass "nvim restores plugins"
else
    fail "nvim restores plugins" "$tmp/lazy.out"
fi
# first start installs treesitter parsers in the background; wait for it
nvim --headless "+lua vim.wait(180000, function() return vim.uv.fs_stat(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/parser/lua.so') ~= nil end, 500)" +qa >/dev/null 2>&1
if nvim --headless ~/.config/nvim/init.lua +qa </dev/null >/dev/null 2>"$tmp/nvim.err" && [[ ! -s $tmp/nvim.err ]]; then
    pass "nvim starts with no errors"
else
    fail "nvim starts with no errors" "$tmp/nvim.err"
fi

if command -v lua-language-server >/dev/null; then
    client=$(nvim --headless ~/.config/nvim/init.lua \
        "+lua vim.wait(15000, function() return #vim.lsp.get_clients() > 0 end)" \
        "+lua io.stdout:write((vim.lsp.get_clients()[1] or {}).name or 'none')" +qa 2>/dev/null)
    if [[ $client = lua_ls ]]; then
        pass "nvim attaches lua_ls from PATH"
    else
        fail "nvim attaches lua_ls from PATH (got: $client)"
    fi
fi

# configs are live links into this checkout, not copies
for path in ~/.zshrc ~/.tmux.conf ~/.config/nvim ~/.local/bin/t; do
    target=$(readlink -f "$path")
    if [[ $target = "$dotfiles"/home/* ]]; then
        pass "$path links into the checkout"
    else
        fail "$path links into the checkout (got: ${target:-missing})"
    fi
done

# shared directories stay real directories
for dir in ~/.config ~/.local ~/.local/bin ~/.local/share; do
    if [[ -d $dir && ! -L $dir ]]; then
        pass "$dir is a real directory"
    else
        fail "$dir is a real directory"
    fi
done

echo
if ((failures)); then
    echo "$failures check(s) failed"
    exit 1
fi
echo "all checks passed"
