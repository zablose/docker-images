<?php

use Zablose\Allog\Config\Server as Config;
use Zablose\Allog\Server;

require __DIR__.'/../vendor/autoload.php';

(new Server((new Config())->read(__DIR__.'/../../.env')))->run();
