#!/bin/bash
#Script para recuperar el respaldo de los sitios 
#Si el directorio ya existe, se elimina para crearlo de nuevo

if [ -d /tmp/respaldo_sitios ]; then 
	rm -fR /tmp/respaldo_sitios
fi

if [ -d /tmp/respaldo_drupal ]; then
	rm -fR /tmp/respaldo_drupal
fi

mkdir /tmp/respaldo_sitios
mkdir /tmp/respaldo_drupal

#Descomprime el archivo de respaldo dentro del directoio creado
tar -xf /tmp/respaldo_sitios.tar.gz -C /tmp/respaldo_sitios
#tar -xf /tmp/respaldo_drupal.tar.gz -C /tmp/respaldo_drupal

#Copiamos todos los sitios que se respaldaron
cp -R $(ls -d /tmp/respaldo_sitios/*) -t /var/www/


