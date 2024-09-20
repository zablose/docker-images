#!/usr/bin/env sh

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

log=/var/log/zdi-vim.log

{
    show_info 'Setting up Vim.'

    tee -a /etc/vim/vimrc <<EOF

let g:skip_defaults_vim = 1
syntax on
set background=dark
set tabstop=4
set expandtab

EOF

    show_success "Vim setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
