#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

add_composer=${ARG_ADD_COMPOSER}
add_laravel=${ARG_ADD_LARAVEL}

user_name=${ARG_USER_NAME}
group_name=${ARG_USER_GROUP_NAME}
version=${ARG_VERSION_COMPOSER}

home=/home/${user_name}
composer=${bin}/composer
laravel=${home}/.composer/vendor/bin/laravel
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
        mkdir "${home}/.composer"
        chmod 700 "${home}/.composer"
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir="${bin}" --filename=composer \
            --version="${version}"
        sudo chmod 755 "${composer}"
        sudo chown -R "${user_name}:${group_name}" "${home}"
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
    fi

    show_success "Composer setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
