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

mariadb_run_default_sql()
{
    db_name=${1:-}
    db_user=${2:-}
    db_password=${3:-}
    user_name=${4:-}

    mariadb_start

    sudo -- mariadb <<EOF
CREATE DATABASE IF NOT EXISTS ${db_name}
    DEFAULT CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_password}';

USE mysql;
DELETE FROM user WHERE User='';

GRANT ALL PRIVILEGES ON *.* TO '${user_name}'@'%' IDENTIFIED BY '${db_password}' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    mariadb_stop
}
