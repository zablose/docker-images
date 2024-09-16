#!/usr/bin/env bash

nginx_set_user_and_log()
{
    env=${1:-}
    log_level=$(if [ "${env}" == 'dev' ]; then echo 'notice'; else echo 'error'; fi)
    nginx_conf=/etc/nginx/nginx.conf

    sudo sed -i -e "s/^user\s.*$/user www-data www-data;/" "${nginx_conf}"
    sudo sed -i -e "s~^error_log\s.*$~error_log /proc/self/fd/2 ${log_level};~" "${nginx_conf}"
}

nginx_generate_certs()
{
    domain=${1:-localhost}
    certs=/etc/nginx/certs
    conf=${certs}/certs.conf
    crt=${certs}/domain.crt
    key=${certs}/domain.key

    sudo mkdir -p ${certs}

    sudo tee ${conf} <<EOF
[req]
req_extensions     = req_ext
distinguished_name = req_distinguished_name
prompt             = no
[req_distinguished_name]
commonName=*.${domain}
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${domain}
DNS.2 = *.${domain}
EOF

    sudo openssl req -x509 -config ${conf} -nodes -days 365 -newkey rsa:2048 -sha256 -keyout "${key}" -out "${crt}"
    sudo ln -srf "${crt}" "/usr/local/share/ca-certificates/${domain}.crt"
    sudo update-ca-certificates
}

nginx_update_main_conf()
{
    name=${1:-localhost}
    root=${2:-/home/web}
    php_fpm=${3:-php-fpm}

    conf=/etc/nginx/snippets/main.conf

    sudo sed -i -e "s/^server_name\s.*$/server_name ${name};/" "${conf}"
    sudo sed -i -e "s~^root\s.*$~root ${root};~" "${conf}"
    sudo sed -i -e "s/\s\{4\}fastcgi_pass\s.*$/    fastcgi_pass ${php_fpm}:9000;/" "${conf}"
}
