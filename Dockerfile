FROM ubuntu:22.04

ENV TEST_SERVER_URL=localhost:8080/

RUN apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -yq composer php php-zip php-dom php-gd php-mbstring php-curl php-xml php-sqlite3 git

RUN cd /var/www; \
    git clone --depth=1 https://github.com/nextcloud/server.git; \
    cd /var/www/server; \
    git submodule update --init; \
    mkdir data; \
    php occ maintenance:install --database=sqlite --database-name=nextcloud --database-host=127.0.0.1 --database-user=root --database-pass=rootpassword --admin-user admin --admin-pass admin

ADD files/log.config.php /var/www/server/config/
ADD files/run-test.sh /opt/

ENTRYPOINT /opt/run-test.sh
