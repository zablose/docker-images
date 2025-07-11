# Php-fpm image

## Build

```shell
docker build -f ./files/php-fpm.df -t zablose/php-fpm:zdi ./
```

### Run

```shell
docker run -u debian -it zablose/php-fpm:zdi bash

# To run 'chromium --no-sandbox' command.
docker run -u debian -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -it zablose/php-fpm:zdi bash
```

[Back](../../readme.md)
