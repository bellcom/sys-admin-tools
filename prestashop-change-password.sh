#!/bin/bash
# Changes Prestashops password
set -o nounset
set -o errexit

SITEDIR=$1
NEW_PASSWD=$2
EMAIL=$3

if [[ ! -f "$SITEDIR/public_html/config/settings.inc.php" ]]; then
  echo "$SITEDIR/public_html/config/settings.inc.php" does not exist
  exit 1
fi

COOKIE_KEY=$(php -r "include '$SITEDIR/public_html/config/settings.inc.php'; echo _COOKIE_KEY_;")
DB_NAME=$(php -r "include '$SITEDIR/public_html/config/settings.inc.php'; echo _DB_NAME_;")
DB_USER=$(php -r "include '$SITEDIR/public_html/config/settings.inc.php'; echo _DB_USER_;")
DB_PASSWD=$(php -r "include '$SITEDIR/public_html/config/settings.inc.php'; echo _DB_PASSWD_;")

mysql -u $DB_USER --password="$DB_PASSWD" $DB_NAME -e "UPDATE ps_employee SET passwd = md5( '${COOKIE_KEY}${NEW_PASSWD}' ) WHERE email = '${EMAIL}';"
