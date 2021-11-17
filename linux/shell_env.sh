#!/bin/bash
# $HOME/.shell_env

alias renv='source $HOME/.shell_env'

# PS1
export _PS1=${_PS1:-"docker"}
export PS1_=${PS1_:-""}
export PS1PS1=${PS1PS1:-${PS1:-'[\u@\h:\w]\$ '}}
export PS1='\n${_PS1:+($_PS1)}'"$PS1PS1"'\n${PS1_:+$PS1_}\$ '


## User profile >>>
if [[ -d "$HOME/local/bin" ]]; then
  export PATH=$HOME/local/bin:$HOME/local/sbin:$PATH
  export LD_LIBRARY_PATH=$HOME/local/lib:${LD_LIBRARY_PATH}
fi

# some more ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
# User specific aliases and functions
alias untar="tar -xvf"
alias untargz="tar -xzvf"
alias untarxz="tar -xJvf"
alias ungz="gzip -d"

alias dus="du --max-depth=1 --exclude=proc --exclude=srv --exclude=sys -h "

alias mkdir="mkdir -p"
alias cls="clear"

## User profile <<<
