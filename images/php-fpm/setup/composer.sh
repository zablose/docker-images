#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

add_composer=${ARG_ADD_COMPOSER}
add_laravel=${ARG_ADD_LARAVEL}

user_name=${ARG_USER_NAME}
group_name=${ARG_USER_GROUP_NAME}
version=${ARG_VERSION_COMPOSER}

dir_home=/home/${user_name}
user_bin=${dir_home}/bin
bashrc=${dir_home}/.bashrc
composer=${user_bin}/composer
laravel=${dir_home}/.composer/vendor/bin/laravel
log=/var/log/zdi-composer.log

{
    if [[ "$add_composer" != "true" ]]
    then
        show_warning 'Skipping Composer installation.'
        exit 0
    fi

    show_info 'Setting up Composer.'

    if [[ ! -f "${composer}" ]]
    then
        mkdir "${dir_home}/.composer"
        chmod 700 "${dir_home}/.composer"
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir="${user_bin}" --filename=composer \
            --version="${version}"
        sudo chmod 700 "${composer}"
        sudo chown -R "${user_name}:${group_name}" "${dir_home}"
        tee -a "${bashrc}" <<EOF

PATH=\$PATH:${dir_home}/.composer/vendor/bin

EOF
    fi

    if [[ "${add_laravel}" != "true" ]]
    then
        show_warning 'Skipping Laravel installer installation.'
        exit 0
    fi

    if [[ ! -f "${laravel}" ]]
    then
        ${composer} global require laravel/installer
        chmod 700 "${laravel}"
        tee -a "${dir_home}"/.bash_aliases <<EOF

alias lara-db-migrate-and-seed='php artisan migrate && php artisan db:seed'
alias lara-db-fresh-and-seed='php artisan migrate:fresh && php artisan db:seed'

EOF
    fi

    show_success "Composer setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
