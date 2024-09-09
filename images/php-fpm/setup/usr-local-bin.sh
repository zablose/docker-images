#!/usr/bin/env bash

set -e

bin=/usr/local/bin
env_bash='#!/usr/bin/env bash'

. "${bin}/functions.sh"

log=/var/log/usr-local-bin-php.log

{
    show_info 'Setting up scripts in "/usr/local/bin" folder.'

    tee "${bin}/phpcs" <<EOF
${env_bash}

php ./vendor/bin/phpcs "\$@"

EOF

    tee "${bin}/phpunit" <<EOF
${env_bash}

php ./vendor/bin/phpunit "\$@"

EOF

    tee "${bin}/phpunit-with-xdebug" <<EOF
${env_bash}

php -d zend_extension=xdebug.so -d xdebug.mode=coverage ./vendor/bin/phpunit "\$@"

EOF

    reas "${bin}" 755 755

    show_success "Scripts setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
