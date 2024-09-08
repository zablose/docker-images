#!/usr/bin/env sh

set -e

domain=${ARG_DOMAIN}
php_fpm_host=${ARG_PHP_FPM_HOST}
web_root_dir=${ARG_WEB_ROOT_DIR}

certs=/etc/nginx/certs
crt=${certs}/${domain}.crt
key=${certs}/${domain}.key
snippets=/etc/nginx/snippets

mkdir -p ${certs} ${snippets}

tee ${certs}/certs.conf <<EOF
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

openssl req -x509 -config ${certs}/certs.conf -nodes -days 365 -newkey rsa:2048 -sha256 -keyout "${key}" -out "${crt}"
ln -srf "${crt}" "/usr/local/share/ca-certificates/${domain}.crt"
update-ca-certificates

tee /etc/nginx/conf.d/default.conf <<EOF

server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

    include snippets/main.conf;
}

EOF

tee /etc/nginx/conf.d/default-ssl.conf <<EOF

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server ipv6only=on;

    http2 on;

    ssl_certificate             ${crt};
    ssl_certificate_key         ${key};
    ssl_protocols               TLSv1.2 TLSv1.3;
    ssl_ciphers                 ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers   off;
    ssl_session_timeout         1d;
    ssl_session_cache           shared:MozSSL:10m;
    ssl_session_tickets         off;

    include snippets/main.conf;
}

EOF

tee ${snippets}/main.conf <<EOF

server_name ${domain};

root ${web_root_dir};
client_max_body_size 32M;
access_log /proc/self/fd/1 combined;

index index.php;

location / {
    try_files \$uri \$uri/ /index.php?\$args;
}

charset utf-8;

# this prevents hidden files (beginning with a period) from being served
location ~ /\. {
    access_log off;
    log_not_found off;
    deny all;
}

location ~ \.php\$ {
    try_files \$uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)\$;
    include /etc/nginx/fastcgi_params;
    fastcgi_read_timeout 3600s;
    fastcgi_buffer_size 128k;
    fastcgi_buffers 4 128k;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_index index.php;
    fastcgi_pass ${php_fpm_host}:9000;
    fastcgi_param SERVER_NAME \$host;
}

location ~ /data {
    return 404;
}

location ~* ^.+\.(log|sqlite)\$ {
    return 404;
}

location ~ /\.ht {
    return 404;
}

location ~* ^.+\.(ico|jpg|gif|png|css|js|svg|eot|ttf|woff|woff2|otf)\$ {
    log_not_found off;
    expires 7d;
    etag on;
}

gzip on;
gzip_comp_level 3;
gzip_disable "msie6";
gzip_vary on;
gzip_types
    text/javascript
    application/javascript
    application/json
    text/xml
    application/xml
    application/rss+xml
    text/css
    text/plain;

EOF
