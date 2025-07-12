#!/usr/bin/env bash

mariadb_start()
{
    sudo /etc/init.d/mariadb start

    while [ ! -e "/var/run/mysqld/mysqld.sock" ]; do
        sleep 1
    done
    sleep 1
}

mariadb_stop()
{
    sudo /etc/init.d/mariadb stop

    while [ -e "/var/run/mysqld/mysqld.sock" ]; do
        sleep 1
    done
}

mariadb_update_server_config()
{
    user=${1:-}
    cnf=/etc/mysql/mariadb.conf.d/50-server.cnf

    sudo sed -i -e "s~^\(bind-address.*\)$~#\1~" ${cnf}
    #sudo sed -i -e "s/^#user\s.*$/user ${user}/" "${cnf}"
    #sudo sed -i -e "s~^#log_error\s.*$~log_error /proc/self/fd/2~" "${cnf}"
}

mariadb_create_db()
{
    db_name=${1:-}
    db_user=${2:-}
    db_password=${3:-}

    sudo -- mariadb <<EOF
CREATE DATABASE IF NOT EXISTS ${db_name}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_password}';

FLUSH PRIVILEGES;
EOF
}

mariadb_create_super_user()
{
    user_name=${1:-}
    password=${2:-}

    sudo -- mariadb <<EOF
USE mysql;
GRANT ALL PRIVILEGES ON *.* TO '${user_name}'@'%' IDENTIFIED BY '${password}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
}

mariadb_remove_empty_users()
{
    sudo -- mariadb <<EOF
USE mysql;
DELETE FROM user WHERE User='';
FLUSH PRIVILEGES;
EOF
}

mariadb_process_init_files()
{
    dir_init=${1:-$HOME/db_init}

    for file in "${dir_init}"/*; do
        if [[ -f "$file" ]]; then
            extension="${file##*.}"
            case "${extension}" in
            sh)
                if [ -x "${file}" ]; then
                    echo "$0: running ${file}"
                    "${file}"
                else
                    echo "$0: sourcing ${file}"
                    # shellcheck disable=SC1090
                    . "${file}"
                fi
                ;;
            sql)
                echo "$0: running ${file}"
                # shellcheck disable=SC2024
                sudo mariadb < "$file"
                ;;
            *)
                echo "$0: ignoring ${file}"
                ;;
            esac
        fi
    done
}
