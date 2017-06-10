#!/bin/sh
set -e

if [ -z ${SATIS_REPO} ]; then
  echo ">> Using default /app/satis.json"
else
  echo ">> Creating satis.json from ${SATIS_REPO}"
  cp -Rf ${SATIS_REPO} /app/satis.json
fi
echo ""
cat /app/satis.json
echo ""

mkdir -p ~/.ssh
if [ ! -z ${SATIS_ID_RSA} ]; then
  echo ">> Copying host ssh key from $SATIS_ID_RSA to /root/.ssh/id_rsa"
  cp $SATIS_ID_RSA  ~/.ssh/id_rsa
  chmod 400  ~/.ssh/id_rsa
fi

if [ ! -z ${GITHUB_OAUTH_TOKEN} ]; then
  echo ">> Copying git oauth token"
  composer config --global github-oauth.github.com $GITHUB_OAUTH_TOKEN
fi

if [ ! -z ${PRIVATE_REPO_DOMAIN_LIST} ]; then
  echo ">> Creating the known_hosts file"
  touch ~/.ssh/known_hosts
  while [ "$PRIVATE_REPO_DOMAIN_LIST" ]; do
    iter=${PRIVATE_REPO_DOMAIN_LIST%%,*}
    [ "$PRIVATE_REPO_DOMAIN_LIST" = "$iter" ] && \
      PRIVATE_REPO_DOMAIN_LIST='' || \
      PRIVATE_REPO_DOMAIN_LIST="${PRIVATE_REPO_DOMAIN_LIST#*,}"
    ssh-keyscan -t rsa,dsa $iter >> /root/.ssh/known_hosts
  done
fi

echo ">> Building Satis for the first time"
satis-build.sh

CRONTAB_JOB='satis-build.sh'
CRONTAB_FREQUENCY=${CRONTAB_FREQUENCY:='* * * * *'}
echo ">> Crontab frequency set to: ${CRONTAB_FREQUENCY}"
echo "${CRONTAB_FREQUENCY} ${CRONTAB_JOB}" > crontab.tmp
echo "" >> crontab.tmp

crontab crontab.tmp
rm crontab.tmp

exec "$@"
