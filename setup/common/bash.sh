#!/usr/bin/env sh

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

log=/var/log/zdi-bash.log

{
    show_info 'Setting up Bash.'

    tee -a /root/.bashrc <<EOF

# Set a fancy prompt
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]\h\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

EOF

    tee -a /etc/skel/.bashrc <<EOF

# set a fancy prompt (overwrite the one in /etc/profile)
if [ "\`id -u\`" -ne 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;93m\]\u\[\033[0;90m\]@\[\033[2;92m\]\h\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;93m\]\\$\[\033[00m\] '
fi

EOF

    tee -a /etc/bash.bashrc <<EOF

# Aliases for all users.
alias ls='ls --color --group-directories-first'
alias ll='ls -al --color --group-directories-first'
alias top='htop'

EOF

    show_success "Bash setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
