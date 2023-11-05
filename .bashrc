#### STYLING ####

# PS1='\[\e[1;2m\]:: \[\e[0;1;38;5;45m\]\u \[\e[38;5;120m\]\w \[\e[38;5;222m\]> \[\e[0m\]'
# PS1='\[\e[1;2m\]:: \[\e[0;1;38;5;45m\]\u | \[\e[0;38;5;120m\]\w \[\e[38;5;222;1m\]> \[\e[0m\]'
PS1='\[\e[1;2m\]:: \[\e[0;1;38;5;45m\]\u \[\e[39;2m\]| \[\e[0;38;5;120m\]\w \[\e[38;5;222;1m\]> \[\e[0m\]'

# Uncomment to include hostname.
# PS1='\[\e[38;5;245;1m\]\h\[\e[39;2m\] :: \[\e[0;1;38;5;45m\]\u \[\e[0;38;5;120m\]\w \[\e[38;5;222;1m\]> \[\e[0m\]'

#### IMPORTS and FUNCTION ENABLING ####

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /opt/etc/bash_completion ] && ! shopt -oq posix; then
    . /opt/etc/bash_completion
fi