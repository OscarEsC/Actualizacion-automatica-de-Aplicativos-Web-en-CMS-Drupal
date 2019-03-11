#!/bin/bash
#Script para realizar el respaldo del sitio
#Listamos los sitios alojados en /var/www, quitando el dir html/
#comprimimos todos los sitios dentro de respaldo_sitios.tar.gz
#eliminamos el archivo si existe
if [ -f /tmp/respaldo_sitios.tar.gz ]; then
	rm -f /tmp/respaldo_sitios.tar.gz
fi

#Hacemos el respaldo de los sitios en /var/www
tar -C /var/www -czf /tmp/respaldo_sitios.tar.gz $(ls /var/www | grep -v html | grep -v drupal)

#respaldo del proyecto de drupal, dependiendo de la ruta donde se encuentre
if [ -d /var/www/html/drupal ]; then
	#Necesitamos cambiarnos al directorio donde esta drupal para poder usar
	#el comando drush del proyecto
	cd /var/www/html/drupal
	drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_drupal.tar.gz
fi

if [ -d /var/www/drupal ]; then
	cd /var/www/drupal
	drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_drupal.tar.gz
fi
