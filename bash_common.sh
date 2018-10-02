## path modifications
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.local/bin:$PATH

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
# modified by Dan to use $HOME
# if [ -e /Users/danburton/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/danburton/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

## bash prompt
DEFAULT='\[\e[m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
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
GITDIRTY='[[ -n "$(git status -s 2> /dev/null)" ]] && echo "*"'
TIMEZONE='date +"%z"'
export PS1="\n${CYAN}\w${PURPLE} [\$($GITBRANCH)\$($GITDIRTY)]\n${YELLOW}================ ${GRAY}[\t${DARKGRAY}\$($TIMEZONE)${GRAY}] ${GREEN}\u${GRAY}@${CYAN}\h ${DARKGRAY}\s ${YELLOW}================${DEFAULT}\n\$ "

# colorized terminal output
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Bash completions
if [ $(command -v stack 2> /dev/null) ]; then
    eval "$(stack --bash-completion-script "$which stack")"
fi

# https://apple.stackexchange.com/questions/168157/tab-completion-for-hosts-defined-in-ssh-config-doesnt-work-anymore-on-yosemi
# May need to run the following:
# brew install bash-completion
# brew tap homebrew/completions
# brew install git # to get the git completions on mac, use git from brew
if [ $(command -v brew 2> /dev/null) ]; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

alias typeless='history | tail -n 20000 | sed "s/.*  //" | sort | uniq -c | sort -g | tail -n 100'
alias reload='source $HOME/github.com/danburton/dotfiles/bash_common.sh'
alias ls='ls -GF'

# alias scheck='stack update && stack --resolver ghc-8.2.2 exec stackage-curator check'
alias scheck='stack update && ./check 2> scheck.txt'

sunpack() {
    PKG=$1
    cd ~/scratch
    stack unpack $1
    cd $1*
}

alias sinit='stack init --force --resolver nightly'
alias snightly='echo "resolver: nightly-$(date -u +%F)" > stack.yaml'
alias stest='stack build --test --bench --no-run-benchmarks'

spr() {
    sunpack $1
    snightly
    stest
}

semi() {
    echo 'Add semigroup instances'
    echo 'See also: https://ghc.haskell.org/trac/ghc/wiki/Migration/8.4#SemigroupMonoidsuperclasses'
}

stitle() {
    PKG=$(basename $(pwd))
    echo "$PKG build failure with GHC 8.4"
    echo "$PKG build failure with GHC 8.4" | pbcopy
}

issue() {
    semi
    echo
    echo '```'
    echo '```'
    echo
    repro
}

repro() {
    PKG=$(basename $(pwd))
    STACK_YAML_LINES=$(wc -l stack.yaml | awk '{print $1}')

    echo 'I was able to reproduce this locally like so:'
    echo
    echo '```bash'
    echo "stack unpack $PKG && cd $PKG"
    if test $STACK_YAML_LINES -eq 1; then
        echo "echo '$(cat stack.yaml)' > stack.yaml"
    else
        echo 'edit stack.yaml # add the following stack.yaml'
    fi
    echo 'stack build --test --bench --no-run-benchmarks'
    echo '```'

    if test $STACK_YAML_LINES -eq 1; then
        : # don't print the stack.yaml
    else
        echo
        echo '```yaml'
        echo '# stack.yaml'
        cat stack.yaml
        echo
        echo '```'
    fi

}

uuidlower() {
    ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
    echo $ID | tr -d '\n' | pbcopy
    echo $ID
}

docker-recompose() {
  docker-compose down && docker-compose up -d
}

# Requires $GITHUB_USER
gclone() {
  LOC=$(basename $(pwd))
  git clone git@github.com:$LOC/$1.git
  cd $1
  git remote add forked-origin git@github.com:$GITHUB_USER/$1.git
}

# Requires $BITBUCKET_USER
bclone() {
  LOC=$(basename $(pwd))
  git clone git@bitbucket.org:TVision-Insights/$1.git
  cd $1
}
