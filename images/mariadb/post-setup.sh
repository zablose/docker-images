#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/functions.sh"
. "${bin}/source-env-file"

user=${ZDI_USER_NAME}
db_name=${ZDI_DB_NAME}
db_user=${ZDI_DB_USERNAME}
db_password=${ZDI_DB_PASSWORD}

user_bin=/home/${user}/bin
log=/var/log/zdi-post-setup-mariadb.log

. "${user_bin}/functions.sh"

{
    show_info 'Mariadb post setup.'

    mariadb_update_server_config "${user}"

    mariadb_start
    mariadb_create_db "${db_name}" "${db_user}" "${db_password}"
    mariadb_create_db "${db_name}_testing" "${db_user}" 'password'
    mariadb_create_super_user "${user}" "${db_password}"
    mariadb_remove_empty_users
    mariadb_process_init_files
    mariadb_stop

    show_success "Mariadb post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
