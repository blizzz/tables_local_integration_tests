#!/usr/bin/env bash
cd /var/www/server/
php occ app:enable --force user_saml

PHP_CLI_SERVER_WORKERS=4 php -S localhost:8080 &

cd /var/www/server/apps/user_saml
composer i --no-dev

cd /var/www/server/apps/user_saml/tests/integration
composer install
sed -i 's/localhost:4443/sso:8443/g' /var/www/server/apps/user_saml/tests/integration/features/Shibboleth.feature
./vendor/bin/behat --colors
sed -i 's/sso:8443/localhost:4443/g' /var/www/server/apps/user_saml/tests/integration/features/Shibboleth.feature
