<?php

declare(strict_types=1);

use Zablose\Allog\Config\Server as Config;
use Zablose\Allog\Db;
use Zablose\Allog\Table;
use Zablose\DotEnv\Env;

require __DIR__.'/vendor/autoload.php';

$config = (new Config())->read(dirname(__DIR__).'/.env');
$table = new Table($config);

$db = (new Db($config))
    ->createTables()
    ->createRequestsTable($table->requestsClient(Env::string('ALLOG_CLIENT_1_NAME')))
    ->createRequestsTable($table->requestsClient(Env::string('ALLOG_CLIENT_2_NAME')));

$db->addClient(Env::string('ALLOG_CLIENT_1_NAME'), Env::string('ALLOG_CLIENT_1_TOKEN'));
$db->addClient(Env::string('ALLOG_CLIENT_2_NAME'), Env::string('ALLOG_CLIENT_2_TOKEN'));
