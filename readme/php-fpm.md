# Php-fpm image

## Build

```shell
docker build -f ./files/php-fpm.df -t zablose/php-fpm:8.3 \
    --build-arg ZDI_CMD_FULL_PATH=/etc/init.d/php8.3-fpm \
    --build-arg ZDI_USER_GROUP_ID=1000 \
    --build-arg ZDI_USER_ID=1000 \
    --build-arg ZDI_USER_NAME=debian \
    --build-arg ZDI_WEB_APP=/home/web \
    --build-arg ZDI_WEB_DIR=/home/web \
    --build-arg ZDI_WEB_DOMAIN=localhost \
    ./
```

### Run

```shell
docker run -it zablose/php-fpm:8.3 bash
```

[Back](../readme.md)
