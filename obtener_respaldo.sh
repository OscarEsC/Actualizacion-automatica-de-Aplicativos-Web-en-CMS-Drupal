#!/bin/bash

#Script para recuperar el respaldo de los sitios 
#Si el directorio ya existe, se elimina para crearlo de nuevo
#Todos los reportes se escriben en reporte.txt

if [ -d /tmp/respaldo_sitios ]; then 
	rm -fR /tmp/respaldo_sitios
	if [ $? -eq 0 ]; then
		echo "Se elimino correctamente el directorio /tmp/respaldos_sitios" | tee -a reporte.txt
	else
		echo "Hubo un error al eliminar el directorio /tmp/respaldos_sitios" | tee -a reporte.txt
	fi

fi

if [ -d /tmp/respaldo_drupal ]; then
	rm -fR /tmp/respaldo_drupal

        if [ $?	-eq 0 ]; then
                echo "Se elimino correctamente el directorio /tmp/respaldos_sitios" | te$
        else
                echo "Hubo un error al eliminar el directorio /tmp/respaldos_sitios" | t$
        fi

fi

mkdir /tmp/respaldo_sitios
mkdir /tmp/respaldo_drupal

#Descomprime el archivo de respaldo dentro del directoio creado
tar -xf /tmp/respaldo_sitios.tar.gz -C /tmp/respaldo_sitios

if [ $? -eq 0 ]; then
	echo "Se realizo correctamente la restauracion del respaldo_sitios.tar.gz" | tee -a reporte.txt
else
	echo "No se pudo restaurar los archivos de /tmp/respaldo_sitios.tar.gz" | tee -a reporte.txt
fi

#tar -xf /tmp/respaldo_drupal.tar.gz -C /tmp/respaldo_drupal

#Copiamos todos los sitios que se respaldaron
cp -R $(ls -d /tmp/respaldo_sitios/*) -t /var/www/

if [ $? -eq 0 ]; then
	echo "Se han copiado todos los sitios restaurados a /var/www satisfactoriamente" | tee -a reporte.txt
else
	echo "No se han podido copiar totalmente los sitios restaurados a /var/www" | tee -a reporte.txt
fi
