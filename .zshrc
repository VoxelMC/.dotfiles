#NOTE: -> Vars
export EDITOR=nvim
# Don't put duplicate lines in the history and do not add lines that start with a space
# export HISTCONTROL=erasedups:ignoredups:ignorespace

setopt AUTO_CD
setopt HIST_IGNORE_DUPS
# setopt COMPLETE_IN_WORD 

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'ROMPT_COMMAND='history -a'

# Colour Vars
#NOTE: BLACK, RED, GREEN, YELLOW, BLUE, PURPLE, CYAN, WHITE
#NOTE: COLOUR => normal; BCOLOUR => bold; UCOLOUR => underline; ON_COLOUR => background; ICOLOUR => intense; BICOLOUR => bold intense; ON_ICOLOUR => background intense;

source ~/.colorsrc

# External Scripts

# source ~/.zsh_scripts/.sh

# append
path+=('/Users/tfox/.zsh_scripts')
export PATH

#NOTE: -> Exports

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="half-life"

plugins=(git)
source $ZSH/oh-my-zsh.sh
export PS1=" ▲ $PS1"
export LESS="-F -X $LESS"

#NOTE: -> Functions

function dev() {
	DEFAULT_DIR=""
	DIR="${1:=$DEFAULT_DIR}"
	cd ~/Dev/$1
	nvim .
}

function godev() {
	DEFAULT_DIR=""
	DIR="${1:=$DEFAULT_DIR}"
	echo $BIBLACK$ON_YELLOW' $ Navigating to ~/Dev/'$1 $RESET ' '
	cd ~/Dev/$1
	ls -1
}
source ~/.zsh_scripts/godev_completion.sh

eval "$(zoxide init zsh)"
function cdls() {
	z $1
	ls
}

function bako() {
	echo "Backing up Obsidian - $(date)"
	pushd -q ~/Dev/projects/Obsidian-Notes
	gaa
	gcmsg "Backup from Macbook - $(date)"
	gp
	popd
}
# Clear command line on down arrow if at the end of history
# function clear-line-down-arrow() {
#     if [[ $#BUFFER -eq 0 && $((HISTCMD + 1)) -gt $(fc -l | wc -l) ]]; then
#         BUFFER=""
#         zle redisplay
#     else
#         zle down-line-or-history
#     fi
# }
# zle -N clear-line-down-arrow
# bindkey '^[[B' clear-line-down-arrow
# bindkey '^[[B' down-line-or-history
# Clear command line on down arrow
function clear-line-down-arrow() {
    BUFFER=""
    zle redisplay
	fc -R
}
zle -N clear-line-down-arrow
bindkey '^[[1;2B' clear-line-down-arrow

# Bind Command Left Arrow to backward-word
bindkey '^[[1;2D' backward-word
# Bind Command Right Arrow to forward-word
bindkey '^[[1;2C' forward-word

## NOTE: -> Custom aliases

alias gotoconfig="nvim ~/.config/"
alias sourcezsh="source ~/.zshrc; echo ' $ $IYELLOW''Sourced zshrc!$RESET'"

alias confignvim="nvim ~/.config/nvim/init.lua"
alias editnvim="confignvim"
alias configzsh="nvim ~/.zshrc && sourcezsh"
alias editzsh="configzsh"
alias configwez="nvim ~/.wezterm.lua"
alias editwez="configwez"

alias editautocomplete="nvim '$(espanso path config)'"

alias t="tree -L"

alias partykit="pnpm partykit"

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

unalias la
unalias ll
unalias ls

alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias lah="ls -lah"

alias :q="exit"

# alias dev='cd ~/Dev; nvim .'
# alias godev='cd ~/Dev'
alias devtypst='cd ~/Dev/typst'

alias initvenv="python3 -m venv venv; chmod +x venv/bin/activate; source venv/bin/activate"
alias activatevenv="source venv/bin/activate"

alias nmr="ssh -Y pshipley@nmr400.ok.ubc.ca"
alias svr="ssh -Y tfox@10.0.0.136"

alias s="grep"

# alias gh="gh --limit 1000"
alias cd="cdls"
alias c="clear"

alias gs="git status"

alias cbcopy="pbcopy"
alias cbpaste="pbpaste"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

alias ohmyzsh="nvim ~/.oh-my-zsh"
export MODULAR_HOME="/Users/tfox/.modular"
export PATH="/Users/tfox/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

# bun completions
[ -s "/Users/tfox/.bun/_bun" ] && source "/Users/tfox/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/tfox/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# wezterm
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH
# wezterm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PATH=~/.console-ninja/.bin:$PATH