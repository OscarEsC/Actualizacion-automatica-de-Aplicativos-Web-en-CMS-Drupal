#!/bin/bash
USR="$(whoami)"
#sudo chown -R $USR:$USR /var/www/sitio5/sitio5
sudo chown -R $USR:$USR $1
#cd /var/www/sitio5/sitio5
cd $1

drush --pm-force dl ctools
drush -y en ctools

drush --pm-force dl event_log
drush -y en event_log

drush --pm-force dl google_analytics
drush -y en googleanalytics

drush --pm-force dl entity
drush -y en entity

drush --pm-force dl workflow
drush -y en workflow

drush --pm-force dl ckeditor
drush -y en ckeditor

drush --pm-force dl jquery_update
drush -y en jquery_update

drush --pm-force dl variable
drush -y en variable

drush --pm-force dl i18n
drush -y en i18n

drush --pm-force dl site_map
drush -y en site_map

drush --pm-force dl token
drush -y en token

drush --pm-force dl panels
drush -y en panels

drush --pm-force dl rules
drush -y en rules

drush --pm-force dl captcha
drush -y en captcha

drush --pm-force dl views
drush -y en views

#sudo chown -R www-data:www-data /var/www/sitio5/sitio5
sudo chown -R www-data:www-data $1
