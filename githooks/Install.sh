#!/bin/bash

function make_symlink() {
  # 全ての githooks script 名。
  # これらが存在する場合、それぞれにシンボリックリンクを張る
  # @see https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
  readonly local HOOK_SCRIPT_NAMES="
    applypatch-msg
    commit-msg
    post-applypatch
    post-checkout
    post-commit
    post-merge
    post-receive
    post-rewrite
    pre-applypatch
    pre-auto-gc
    pre-commit
    pre-push
    pre-rebase
    pre-receive
    prepare-commit-msg
    update
    pre-receive
  "
  # assuming the script is in a bin directory, one level into the repo
  readonly local HOOK_DIR=$(git rev-parse --show-toplevel)/.git/hooks

  readonly local NOW=$(date +"%Y%m%d_%H%M")

  for hook in $HOOK_SCRIPT_NAMES; do
    # If the hook already exists, is executable, and is not a symlink
    if [ ! -h $HOOK_DIR/$hook -a -x $HOOK_DIR/$hook ]; then
        mv $HOOK_DIR/$hook $HOOK_DIR/"${hook}.backup.${NOW}"
    fi

    # create the symlink, overwriting the file if it exists
    # probably the only way this would happen is if you're using an old version of git
    # -- back when the sample hooks were not executable, instead of being named ____.sample
    ln -s -f ./ $HOOK_DIR/$hook
  done
}
make_symlink
