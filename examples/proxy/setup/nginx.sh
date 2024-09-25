#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/functions.sh"

domain=${ZDI_WEB_DOMAIN}
env=${ZDI_ENV}
user=${ZDI_USER_NAME}

user_bin=/home/${user}/bin
log=/var/log/zdi-post-setup-nginx-proxy.log

. "${user_bin}/functions.sh"

{
    show_info 'Nginx proxy post setup.'

    nginx_set_user_and_log "${env}"
    nginx_generate_certs "${domain}"

    sudo tee /etc/nginx/conf.d/default-ssl.conf <<EOF
server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server ipv6only=on;

    http2 on;

    ssl_certificate             /etc/nginx/certs/domain.crt;
    ssl_certificate_key         /etc/nginx/certs/domain.key;
    ssl_protocols               TLSv1.2 TLSv1.3;
    ssl_ciphers                 ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers   off;
    ssl_session_timeout         1d;
    ssl_session_cache           shared:MozSSL:10m;
    ssl_session_tickets         off;

    location / {
        proxy_pass https://proxy-pma;
    }
}
EOF

    show_success "Nginx proxy post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
