#! /bin/bash

## path modifications
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
#     # shellcheck source=/dev/null
#     . "$HOME/.nix-profile/etc/profile.d/nix.sh";
# fi # added by Nix installer

## bash prompt
DEFAULT='\[\e[m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
PURPLE='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
GRAY='\[\e[0;37m\]'
DARKGRAY='\[\e[1;30m\]'

# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37

GITBRANCH='git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "not a git repository"'
# shellcheck disable=SC2016
GITDIRTY='[[ -n "$(git status -s 2> /dev/null)" ]] && echo "*"'
TIMEZONE='date +"%z"'

get-resolver() {
  SNAPSHOT="$(grep '^\(snapshot\|resolver\):' stack.yaml 2>/dev/null \
           || grep '^\(snapshot\|resolver\):' ../stack.yaml 2>/dev/null \
           || grep '^\(snapshot\|resolver\):' ../../stack.yaml 2>/dev/null \
           || grep '^\(snapshot\|resolver\):' ../../../stack.yaml 2>/dev/null \
           || grep '^\(snapshot\|resolver\):' ../../../../stack.yaml 2>/dev/null \
           || echo "absent")"
  if [ "$SNAPSHOT" = "absent" ]; then
    echo ""
  else
    echo "  -- $SNAPSHOT"
  fi
  # PROJECT_ROOT="$(stack --resolver ghc-8.6.2 path --project-root)"
  # if [ "$PROJECT_ROOT" = "/Users/dan/.stack/global-project" ]; then
  #   echo ""
  # else
  #   SNAPSHOT="$(cat $PROJECT_ROOT/stack.yaml | grep '^\(snapshot\|resolver\):' | cut -f 2 -d ' ')"
  #   echo "-- snapshot: $SNAPSHOT"
  # fi
}

get-python-version() {
  PYVER="$(cat .python-version 2>/dev/null \
        || cat ../.python-version 2>/dev/null \
        || cat ../../.python-version 2>/dev/null \
        || cat ../../../.python-version 2>/dev/null \
        || cat ../../../../.python-version 2>/dev/null \
        || echo "absent")"
  if [ "$PYVER" = "absent" ]; then
    echo ""
  else
    echo "  # .python-version: $PYVER"
  fi
}

export PS1="\\n${CYAN}\\w${PURPLE}\\n  [\$($GITBRANCH)\$($GITDIRTY)]\$(get-resolver)\$(get-python-version)\\n${YELLOW}============== ${GRAY}[\\t${DARKGRAY}\$($TIMEZONE)${GRAY}] ${GREEN}\\u${GRAY}@${CYAN}\\h ${DARKGRAY}\\s ${YELLOW}==============${DEFAULT}\\n\$ "

# colorized terminal output
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Bash completions
if [ "$(command -v stack 2> /dev/null)" ]; then
    eval "$(stack --bash-completion-script "$(command -v stack)")"
fi

# https://apple.stackexchange.com/questions/168157/tab-completion-for-hosts-defined-in-ssh-config-doesnt-work-anymore-on-yosemi
# May need to run the following:
# brew install bash-completion
# brew tap homebrew/completions
# brew install git # to get the git completions on mac, use git from brew
if [ "$(command -v brew 2> /dev/null)" ]; then
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        # shellcheck source=/dev/null
        . "$(brew --prefix)/etc/bash_completion"
    fi
fi

alias typeless='history | tail -n 20000 | sed "s/.*  //" | sort | uniq -c | sort -g | tail -n 100'
alias reload='source $HOME/github.com/$GITHUB_USER/dotfiles/bash_common.sh'
alias ls='ls -GF'

alias scheck='stack update && ./check 2> >(tee scheck.txt >&2)'

# shellcheck disable=SC2016
CODE_FENCE='```'

sunpack() {
    PKG="$1"
    cd ~/scratch || return
    stack unpack "$PKG"
    cd "$PKG"* || return
}

alias sinit='stack init --force --resolver nightly'
alias snightly='echo "resolver: nightly-$(date -u +%F)" > stack.yaml'
alias stest='stack build --test --bench --no-run-benchmarks --fast'

spr() {
    sunpack "$1"
    snightly
    stest
}

semi() {
    echo 'Add semigroup instances'
    echo 'See also: https://ghc.haskell.org/trac/ghc/wiki/Migration/8.4#SemigroupMonoidsuperclasses'
}

stitle() {
    PKG="$(basename "$(pwd)")"
    echo "$PKG build failure with GHC 8.4"
    echo "$PKG build failure with GHC 8.4" | pbcopy
}

issue() {
    semi
    echo
    echo "$CODE_FENCE"
    echo "$CODE_FENCE"
    echo
    repro
}

repro() {
  PKG="$(basename "$(pwd)")"
  STACK_YAML_LINES=$(wc -l stack.yaml | awk '{print $1}')

  echo 'I was able to reproduce this locally like so:'
  echo
  echo "$CODE_FENCE"bash
  echo "stack unpack $PKG && cd $PKG"
  if test "$STACK_YAML_LINES" -eq 1; then
    echo "echo '$(cat stack.yaml)' > stack.yaml"
  else
    echo 'edit stack.yaml # add the following stack.yaml'
  fi
  echo 'stack build --test --bench --no-run-benchmarks --fast'
  echo "$CODE_FENCE"

  if test "$STACK_YAML_LINES" -eq 1; then
    : # don't print the stack.yaml
  else
    echo
    echo "$CODE_FENCE"yaml
    echo '# stack.yaml'
    cat stack.yaml
    echo
    echo "$CODE_FENCE"
  fi
}

uuidlower() {
  ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
  echo "$ID" | tr -d '\n' | pbcopy
  echo "$ID"
}

docker-recompose() {
  docker-compose down && docker-compose up -d
}

# Requires $GITHUB_USER
gclone() {
  LOC="$(basename "$(pwd)")"
  git clone "git@github.com:$LOC/$1.git"
  cd "$1" || return
  git remote add forked-origin "git@github.com:$GITHUB_USER/$1.git"
}

# Hard-coded to TVision-Insights, since that's the only bitbucket I ever clone from.
bclone() {
  # LOC=$(basename $(pwd))
  cd "$HOME/bitbucket.org/TVision-Insights/" || return
  git clone "git@bitbucket.org:TVision-Insights/$1.git"
  cd "$1" || return
}

# NOTE: I don't currently use this. It tends to crash emacs or cause other weird behavior.
# Which is too bad, because it made opening files in emacs INSANELY fast.
# https://medium.com/@bobbypriambodo/blazingly-fast-spacemacs-with-persistent-server-92260f2118b7
em() {
  # Checks if there's a frame open
  emacsclient -n -e "(if (> (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null
  if [ "$?" -eq "1" ]; then
    emacsclient -a '' -nqc "$@" &> /dev/null
  else
    emacsclient -nq "$@" &> /dev/null
  fi
}

export S3_LOCAL_DIR="$HOME/s3"
# requires aws
s3-get() {
  FILE="$1"
  FILE_DIR="$(dirname "$FILE")"
  LOCAL_FILE="$S3_LOCAL_DIR/$FILE"
  mkdir -p "$S3_LOCAL_DIR/$FILE_DIR"
  aws s3 cp "s3://$FILE" "$LOCAL_FILE" >&2
  echo "$LOCAL_FILE"
}

# requires shellcheck
shellcheck-bash-profile () {
  shellcheck \
    "$HOME/github.com/$GITHUB_USER/dotfiles/bash_common.sh" \
    "$HOME/.bash_profile"
}

moss-grep () {
  find \
    "$HOME/bitbucket.org/TVision-Insights" \
    "(" -name '*.hs' -or -name 'package.yaml' ")" \
    -and -not -path "*/.*/*" \
    -and -not -path "*/third-party/*" \
    -exec grep -H "$1" {} ';'
}

alias whoamip='curl ifconfig.co'
