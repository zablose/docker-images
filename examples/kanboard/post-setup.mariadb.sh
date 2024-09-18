#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

user=${ZDI_USER_NAME}
db_name=${ZDI_DB_NAME}
db_user=${ZDI_DB_PASSWORD}
db_password=${ZDI_DB_USERNAME}

user_bin=/home/${user}/bin
log=/var/log/zdi-post-setup-mariadb.log

. "${user_bin}/functions.sh"

{
    show_info 'Mariadb post setup.'

    mariadb_update_server_config "${user}"
    mariadb_run_default_sql "${db_name}" "${db_user}" "${db_password}" "${user}"

    show_success "Mariadb post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
