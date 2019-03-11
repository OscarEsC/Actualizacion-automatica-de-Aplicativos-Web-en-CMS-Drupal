#!/bin/bash

#Script para realizar el respaldo del sitio
#Listamos los sitios alojados en /var/www, quitando el dir html/
#comprimimos todos los sitios dentro de respaldo_sitios.tar.gz
#eliminamos el archivo si existe

#Se reporta cada accion en el archivo reportes.txt

if [ -f /tmp/respaldo_sitios.tar.gz ]; then
	rm -f /tmp/respaldo_sitios.tar.gz

	if [ $? -ne 0 ]; then
		echo "No se elimino correctamente respaldos_sitios.tar.gz" | tee -a reporte.txt
	fi
fi

tar -C /var/www -czf /tmp/respaldo_sitios.tar.gz $(ls /var/www | grep -v html | grep -v drupal)

if [ $? -eq 0 ]; then
	echo "Compresion exitosa de los sitios de /var/www" | tee -a reporte.txt
else
	echo "No se comprimieron correctamente los sitios de /var/www" | tee -a reporte.txt
fi

#respaldo del proyecto de drupal
if [ -d /var/www/html/drupal ]; then
	#Necesitamos cambiarnos al directorio donde esta drupal para poder usar
	#el comando drush del proyecto
	cd /var/www/html/drupal
	drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_drupal.tar.gz
	
	if [ $? -eq 0 ]; then
		echo "Compresion exitosa del directorio drupal" | tee -a reporte.txt
	else
		echo "Compresion fallida del directorio drupal" | tee -a reporte.txt
	fi
fi	

if [ -d /var/www/drupal ]; then
	cd /var/www/drupal
	drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_drupal.tar.gz

        if [ $? -eq 0 ]; then
                echo "Compresion exitosa del directorio	drupal" | tee -a reporte.txt
        else
                echo "Compresion fallida del directorio	drupal"	| tee -a reporte.txt
        fi

fi
