# Nginx image

Image will be domain specific, therefor different images must be built for different apps.
Unless, you mount your own ssl keys and Nginx configs.

## Build

```shell
docker build -f ./files/nginx.df -t zablose/nginx-example:1.27 --build-arg ARG_WEB_DOMAIN=example.com ./
```

### Run

```shell
docker run -it zablose/nginx:1.27 bash
```

[Back](../readme.md)
