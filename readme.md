# Docker images

Custom Docker images with improvements like colored prompt, vim, htop, etc.

## Environment variables

| Name                 | ARG,ENV | Default           | Description                                               |
|----------------------|---------|-------------------|-----------------------------------------------------------|
| ZDI_CMD_FULL_PATH    | env     |                   | Full path to the program, like: '/etc/init.d/php8.3-fpm'. |
| ZDI_USER_GROUP_ID    | arg,env | 1000              |                                                           |
| ZDI_USER_ID          | arg,env | 1000              |                                                           |
| ZDI_USER_NAME        | arg     | debian            |                                                           |
| ZDI_WEB_APP_DIR      | env     | /home/web/laravel |                                                           |
| ZDI_WEB_ROOT_DIR     | arg     | /home/web         |                                                           |
| ZDI_WEB_DOMAIN       | env     | localhost         |                                                           |
| ZDI_USER_GROUP_NAME  | arg     | debian            |                                                           |
| ZDI_ADD_COMPOSER     | arg     | true              |                                                           |
| ZDI_ADD_LARAVEL      | arg     | true              |                                                           |
| ZDI_PHP_FPM_HOST     | arg     |                   |                                                           |
| ZDI_VERSION_PHP      | arg     | 8.3               |                                                           |
| ZDI_VERSION_COMPOSER | arg     | 2.7.9             |                                                           |
|                      |         |                   |                                                           |
|                      |         |                   |                                                           |

## Images

[Rsyslog](./readme/rsyslog.md)
[Nginx](./readme/nginx.md)
