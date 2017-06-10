#!/bin/sh

set -x

WORKDIR=/var/www/html

echo 'Building composer repository'
satis -v -n --no-html-output --no-ansi build /app/satis.json ${WORKDIR}

echo 'Ensure webdir has the right permissions'
chown -Rf www-data: ${WORKDIR}

