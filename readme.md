# Docker images

Custom Docker images with improvements like colored prompt, vim, htop, etc.

## Environment variables

* Arg - Variable is used as `ARG` during image build;
* Env - Variable is used as `ENV` inside container;
* Dc - Variable is set in docker compose file.

| Name                 | Arg,Env,Dc | Default           | Description                                                 |
|----------------------|------------|-------------------|-------------------------------------------------------------|
| ZDI_ADD_COMPOSER     | arg        | true              |                                                             |
| ZDI_ADD_LARAVEL      | arg        | true              |                                                             |
| ZDI_CONTAINER_NAME   | env,dc     |                   | Container name, used in Bash prompt instead of hostname.    |
| ZDI_DB_NAME          | env        |                   |                                                             |
| ZDI_DB_PASSWORD      | env        |                   |                                                             |
| ZDI_DB_USERNAME      | env        |                   |                                                             |
| ZDI_ENV              | arg,env    | prod              | Set to 'dev' to display errors in PHP.                      |
| ZDI_PHP_FPM_HOST     | arg,dc     |                   | A php-fpm service name from your 'docker-compose.yml' file. |
| ZDI_TIMEZONE         | arg,env    | Europe/London     |                                                             |
| ZDI_USER_GROUP_ID    | arg,env    | 1000              |                                                             |
| ZDI_USER_GROUP_NAME  | arg        | debian            |                                                             |
| ZDI_USER_ID          | arg,env    | 1000              |                                                             |
| ZDI_USER_NAME        | arg        | debian            |                                                             |
| ZDI_VERSION_COMPOSER | arg        | 2.7.9             |                                                             |
| ZDI_VERSION_PHP      | arg,env    | 8.3               |                                                             |
| ZDI_WEB_APP_DIR      | env        | /home/web/laravel |                                                             |
| ZDI_WEB_DOMAIN       | env        | localhost         |                                                             |
| ZDI_WEB_ROOT_DIR     | arg        | /home/web         |                                                             |
|                      |            |                   |                                                             |

## Images

* [Mariadb](./readme/mariadb.md)
* [Nginx](./readme/nginx.md)
* [Php-fpm](./readme/php-fpm.md)
* [Rsyslog](./readme/rsyslog.md)
