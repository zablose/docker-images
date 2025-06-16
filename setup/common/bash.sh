#!/usr/bin/env sh

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

log=/var/log/zdi-bash.log

{
    show_info 'Setting up Bash.'

    tee -a /etc/bash.bashrc <<EOF

# Aliases for all users.
alias ls='ls --color --group-directories-first'
alias ll='ls -al --color --group-directories-first'
alias top='htop'

EOF

    show_success "Bash setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
