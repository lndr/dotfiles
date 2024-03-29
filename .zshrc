# Color support
autoload -U colors
colors

# Prompt configuration
# This uses 3 variants:
# a) Local user (no ssh): Green username (without hostname)
# b) Remote user (over ssh): Yellow username@hostname
# c) root (same for local and remote): Red root@hostname
autoload -U promptinit
promptinit

if [ -z "$SSH_CLIENT" ]; then
    PROMPT="%{%(#.$fg[red]%B%n@%m.$fg[green]%B%n)%}%b %{$fg[blue]%}%~%{$reset_color%}
>: "
else
    PROMPT="%{%(#.$fg[red].$fg[yellow])%}%B%n@%m%b %{$fg[blue]%}%~%{$reset_color%}
>: "
fi
RPROMPT="%(?..%{$fg[red]%}%B!%b%{$reset_color%})"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# Keybindings
bindkey -v
# To avoid using raw escape sequences, some zsh versions (e.g. on Debian)
# determine the correct value from terminfo and populate key[...].
# These are used if available, otherwise falling back to the escape sequence.
# On Darwin key[...] is populated with ^[O* but the terminal sends ^[[*. 
if [[ -z "$key" ]]
then
    typeset -A key
    key=(Up "^[[A" Down "^[[B")
elif [[ `uname` == "Darwin" ]]
then
    key[Up]=^[[A
    key[Down]=^[[B
fi
bindkey "${key[Up]}" history-beginning-search-backward
bindkey "${key[Down]}" history-beginning-search-forward

# Misc options
setopt autocd
setopt extendedglob
setopt nomatch
unsetopt beep
unsetopt notify

# Completion
autoload -U compinit
compinit

# Disable completion of hostnames from /etc/hosts
zstyle ':completion:*' hosts off

# Enable completion menu 
zstyle ':completion:*' menu yes select

# Check if tmux sessions are active and list them
if command -v tmux &> /dev/null && [ ! -n "$TMUX" ]
then
  command tmux ls &> /dev/null; rc=$?
  if [ $rc -eq 0  ]
  then
    echo "\nActive tmux sessions:"
    tmux ls
  fi
fi
