#!/usr/bin/env bats
# Checks a machine after setup: bats tests/smoke.bats

@test "zsh starts without errors" {
    run script -qec "zsh -i -c 'exit 0'" /dev/null
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "zsh plugins are loaded" {
    run zsh -i -c 'typeset -f _zsh_autosuggest_start >/dev/null && (( ${+ZSH_HIGHLIGHT_VERSION} ))'
    [ "$status" -eq 0 ]
}

@test "tmux loads the dracula theme" {
    tmux -L bats -f ~/.tmux.conf new-session -d
    run tmux -L bats show -gv status-left
    tmux -L bats kill-server
    [[ $output == *'#[bg='* ]]
}

@test "nvim installs its plugins" {
    run nvim --headless "+Lazy! restore" +qa
    [ "$status" -eq 0 ]
}

@test "nvim starts without errors" {
    run nvim --headless +qa
    [ "$status" -eq 0 ]
    [[ $output != *Error* ]]
}

@test "configs link into this checkout" {
    repo=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
    [ "$(readlink -f ~/.zshrc)" = "$repo/home/zsh/.zshrc" ]
    [ "$(readlink -f ~/.tmux.conf)" = "$repo/home/tmux/.tmux.conf" ]
    [ "$(readlink -f ~/.config/nvim)" = "$repo/home/nvim/.config/nvim" ]
    [ "$(readlink -f ~/.local/bin/t)" = "$repo/home/bin/.local/bin/t" ]
}

@test "~/.config and ~/.local are real directories" {
    [ ! -L ~/.config ]
    [ ! -L ~/.local ]
    [ ! -L ~/.local/bin ]
}

@test "t offers ~/work itself as a session option" {
    mkdir -p "$BATS_TEST_TMPDIR/home/personal" "$BATS_TEST_TMPDIR/home/work/project" "$BATS_TEST_TMPDIR/bin"
    printf '#!/bin/sh\ncat > "%s"\n' "$BATS_TEST_TMPDIR/choices" > "$BATS_TEST_TMPDIR/bin/fzf"
    chmod +x "$BATS_TEST_TMPDIR/bin/fzf"
    HOME="$BATS_TEST_TMPDIR/home" PATH="$BATS_TEST_TMPDIR/bin:$PATH" run ~/.local/bin/t
    [ "$status" -eq 0 ]
    grep -qx "$BATS_TEST_TMPDIR/home/work" "$BATS_TEST_TMPDIR/choices"
    grep -qx "$BATS_TEST_TMPDIR/home/work/project" "$BATS_TEST_TMPDIR/choices"
}
