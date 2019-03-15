#!/bin/bash
USR="$(whoami)"
sudo chown -R $USR:$USR /var/www/sitio2
cd /var/www/sitio2

drush dl ctools
drush -y en ctools

drush dl event_log
drush -y en event_log

drush dl google_analytics
drush -y en googleanalytics

drush dl workflow
drush -y en workflow

drush dl ckeditor
drush -y en ckeditor

drush dl jquery_update
drush -y en jquery_update

drush dl i18n 
drush -y en i18n

drush dl site_map
drush -y en site_map

drush dl token
drush -y en token

drush dl panels
drush -y en panels

drush dl rules
drush -y en rules

drush dl captcha
drush -y en captcha

drush dl views
drush -y en views

sudo chown -R www-data:www-data /var/www/sitio2
