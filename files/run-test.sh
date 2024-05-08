#!/usr/bin/env bash
cd /var/www/server/
php occ app:enable --force tables

PHP_CLI_SERVER_WORKERS=4 php -S localhost:8080 &

cd /var/www/server/apps/tables
composer i --no-dev

cd /var/www/server/apps/tables/tests/integration
composer install

./run.sh
