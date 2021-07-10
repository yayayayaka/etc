#!/bin/sh

# deploy.sh - Deploy my dotfiles to a local or remote machine
#
# USAGE: deploy.sh [ <gituser_name> <gituser_email> ]
#
# This script will clone the dotfiles repository into ~/.config and
# sets up the necessary symlinks to the home directory.
#
# If <gituser_name> and <gituser_email> are supplied, this script
# will also set the global values `user.name` and `user.email` of
# git-config(1).
#
#
# To deploy this repository on a remote machine, simply
#   $ ssh somewhere < deploy.sh
#
# To pass arguments for deploy.sh to the remote side, use something like
#   $ ssh somewhere 'cat| sh /dev/stdin arg1 arg2' < deploy.sh

### Location of the git repository
ETC_REPO="https://github.com/yayayayaka/etc.git"
BIN_REPO="https://github.com/yayayayaka/bin.git"
REMOTE="origin"
DELFAULT_BRANCH="main"
###


### Default locations of the dotfiles and scripts dir
ETC_DIR="$HOME/etc"
BIN_DIR="$HOME/bin"
PATH="$HOME/bin:$PATH"

XDG_CONFIG_HOME="$HOME/.config"
###


user () {
    printf "[ \\033[0;33m??\\033[0m ] %s\\n" "$1"
}

warn () {
    echo "WARN: $1" >&2
}

fail () {
    echo "FAIL: $1" >&2
}

mkdir -p "$XDG_CONFIG_HOME" || (fail "unable to mkdir $XDG_CONFIG_HOME"; exit 1)

# Some quick check to give an early indicator of breakage
depends="git"
recommends="run-parts crontab curl"
missing=""
for i in $recommends; do
    hash "$i" >/dev/null 2>&1 \
        || warn "not installed: $i"
done
for i in $depends; do
    hash "$i" >/dev/null 2>&1 \
        || missing="$missing $i"
done
[ -n "$missing" ] && fail "not installed:$missing" && exit 1


# Setup the checkout directory itself
pull () {
    dir="$1"
    repo="$2"
    branch="$3"
    mkdir -p "$dir" || (fail "Unable to create config dir" && exit 1)
    (
        export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
        cd "$dir" || (fail "failed to cd into $dir" && exit 1)
        if ! [ -d .git ]; then
            git init || (fail "Unable to init repo" && exit 1)
            git remote add -t \* -f "$REMOTE" "$repo"
            git fetch --all || (fail "Unable to fetch" && exit 1)
            git reset --hard "$REMOTE/$branch"
        else
            # If repo with changes present, bail out
            git fetch --all || (fail "Unable to fetch" && exit 1)
            git merge --ff-only "$REMOTE/$branch" || (fail "Local head out of sync" && exit 1)
        fi
    )
    unset dir
    unset repo
    unset branch
}
pull "$ETC_DIR" "$ETC_REPO" "$DELFAULT_BRANCH"
pull "$BIN_DIR" "$BIN_REPO" "$DELFAULT_BRANCH"


# Setup default git username and email
(
    cd "$ETC_DIR" || (fail "Could not cd into $ETC_DIR" && exit 1)
    [ -n "$1" ] && [ -n "$2" ] && \
        sed -e "s/AUTHORNAME/$1/g" -e "s/AUTHOREMAIL/$2/g" git/config.local.example > git/config.local
)


# Now setup the symlinks in $HOME
(
    cd "$HOME" || (fail "Could not cd into $HOME" && exit 1)
    dir="${ETC_DIR##$HOME/}"

    ln -sfn "$dir/profile" .profile
    ln -sfn "$dir/git/config" .gitconfig
    mkdir -p ~/.ssh && \
        ln -sfn "$dir/ssh/config" ~/.ssh/config

    if hash bash >/dev/null 2>&1; then
        ln -sfn "$dir/profile" .bash_profile
        ln -sfn "$dir/shellrc" .bashrc
    fi

    if hash zsh >/dev/null 2>&1; then
        ln -sfn "$dir/profile" .zprofile
        ln -sfn "$dir/shellrc" .zshrc
    fi

    if hash ksh >/dev/null 2>&1; then
        ln -sfn "$dir/shellrc" .kshrc
    fi

    if hash startx >/dev/null 2>&1; then
        ln -sfn "$dir/xinitrc" .xinitrc
        ln -sfn "$dir/XCompose" .XCompose
        ln -sfn "$dir/Xdefaults" .Xdefaults
    fi
)


# Symlink everything to XDG_CONFIG_HOME
(
    cd "$HOME" || (fail "Could not cd into $HOME" && exit 1)
    dir="${ETC_DIR##$HOME/}"

    for file in "$dir"/*; do
        ln -sfn -t "${XDG_CONFIG_HOME##$HOME/}/" "../$file"
    done
)


# Backup existing crontab and then generate my own
[ -e "$ETC_DIR"/crontab ] || crontab -l > "$ETC_DIR"/crontab
mkcrontab () {
    cat "$ETC_DIR"/crontab 2>/dev/null
    dir="$ETC_DIR/periodic"
    cmd=". $ETC_DIR/profile; run-parts"
    [ -e "$dir/15min" ] && \
        echo "*/15 * * * * $cmd $dir/15min"
    [ -e "$dir/hourly" ] && \
        echo "0 * * * * $cmd $dir/hourly"
    [ -e "$dir/daily" ] && \
        echo "0 2 * * * $cmd $dir/daily"
    [ -e "$dir/weekly" ] && \
        echo "0 3 * * 6 $cmd $dir/weekly"
    [ -e "$dir/monthly" ] && \
        echo "0 4 1 * * $cmd $dir/monthly"
}
mkcrontab|crontab -


# Install amix/vimrc and symlink my adjustments
(
    dir="$ETC_DIR/vim"
    sh "$dir/install.sh"
    ln -sfn "$dir/my_configs.vim" "$HOME/.vim_runtime/my_configs.vim"
)
echo "Done."

