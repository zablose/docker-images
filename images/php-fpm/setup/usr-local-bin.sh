#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

log=/var/log/usr-local-bin-php.log

{
    show_info 'Setting up scripts in "/usr/local/bin" folder.'

    tee "${BIN}/phpcs" <<EOF
#!/usr/bin/env bash

php ./vendor/bin/phpcs "\$@"

EOF

    tee "${BIN}/phpunit" <<EOF
#!/usr/bin/env bash

php ./vendor/bin/phpunit "\$@"

EOF

    tee "${BIN}/phpunit-with-xdebug" <<EOF
#!/usr/bin/env bash

php -d zend_extension=xdebug.so -d xdebug.mode=coverage ./vendor/bin/phpunit "\$@"

EOF

    reas "${BIN}" 755 755

    show_success "Scripts setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
