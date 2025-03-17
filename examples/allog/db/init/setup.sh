#!/usr/bin/env bash

set -e

db_name=${ZDI_DB_NAME}

client_1_name=${ALLOG_CLIENT_1_NAME}
client_1_token=${ALLOG_CLIENT_1_TOKEN}
client_1_ip=${ALLOG_CLIENT_1_IP}

client_2_name=${ALLOG_CLIENT_2_NAME}
client_2_token=${ALLOG_CLIENT_2_TOKEN}
client_2_ip=${ALLOG_CLIENT_2_IP}

sudo -- mysql <<EOF
USE '${db_name}';

CREATE TABLE IF NOT EXISTS \`clients\` (
    \`name\`        VARCHAR(32) NOT NULL,
    \`token\`       CHAR(32)    NOT NULL,
    \`remote_addr\` CHAR(15)    NOT NULL,
    \`active\`      TINYINT(1)  NOT NULL DEFAULT '1',
    \`updated\`     DATETIME    NOT NULL,
    \`created\`     DATETIME    NOT NULL,
    UNIQUE KEY \`allog_clients_name_unique\` (\`name\`)
)
    ENGINE = InnoDB;

INSERT INTO \`clients\`
    (name, token, remote_addr, active, updated, created)
VALUES
    ('${client_1_name}', '${client_1_token}', '${client_1_ip}', 1, NOW(), NOW()),
    ('${client_2_name}', '${client_2_token}', '${client_2_ip}', 1, NOW(), NOW());

CREATE TABLE IF NOT EXISTS \`messages\` (
    \`id\`      TINYINT(3) UNSIGNED             NOT NULL AUTO_INCREMENT,
    \`type\`    VARCHAR(16)                     NOT NULL DEFAULT 'info',
    \`message\` TEXT COLLATE utf8mb4_unicode_ci NOT NULL,
    \`created\` DATETIME                        NOT NULL,
    PRIMARY KEY (\`id\`)
)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS \`requests_allog\` (
    \`id\`              SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    \`http_user_agent\` VARCHAR(255)                  DEFAULT NULL,
    \`http_referer\`    VARCHAR(2000)                 DEFAULT NULL,
    \`remote_addr\`     CHAR(15)             NOT NULL,
    \`request_method\`  CHAR(16)             NOT NULL,
    \`request_uri\`     VARCHAR(2000)        NOT NULL,
    \`request_time\`    DATETIME                      DEFAULT NULL,
    \`get\`             TEXT COLLATE utf8mb4_unicode_ci,
    \`post\`            LONGTEXT COLLATE utf8mb4_unicode_ci,
    \`created\`         DATETIME             NOT NULL,
    PRIMARY KEY (\`id\`)
)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS \`requests_${client_1_name}\` (
    \`id\`              SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    \`http_user_agent\` VARCHAR(255)                  DEFAULT NULL,
    \`http_referer\`    VARCHAR(2000)                 DEFAULT NULL,
    \`remote_addr\`     CHAR(15)             NOT NULL,
    \`request_method\`  CHAR(16)             NOT NULL,
    \`request_uri\`     VARCHAR(2000)        NOT NULL,
    \`request_time\`    DATETIME                      DEFAULT NULL,
    \`get\`             TEXT COLLATE utf8mb4_unicode_ci,
    \`post\`            LONGTEXT COLLATE utf8mb4_unicode_ci,
    \`created\`         DATETIME             NOT NULL,
    PRIMARY KEY (\`id\`)
)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS \`requests_${client_2_name}\` (
    \`id\`              SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    \`http_user_agent\` VARCHAR(255)                  DEFAULT NULL,
    \`http_referer\`    VARCHAR(2000)                 DEFAULT NULL,
    \`remote_addr\`     CHAR(15)             NOT NULL,
    \`request_method\`  CHAR(16)             NOT NULL,
    \`request_uri\`     VARCHAR(2000)        NOT NULL,
    \`request_time\`    DATETIME                      DEFAULT NULL,
    \`get\`             TEXT COLLATE utf8mb4_unicode_ci,
    \`post\`            LONGTEXT COLLATE utf8mb4_unicode_ci,
    \`created\`         DATETIME             NOT NULL,
    PRIMARY KEY (\`id\`)
)
    ENGINE = InnoDB;

EOF
