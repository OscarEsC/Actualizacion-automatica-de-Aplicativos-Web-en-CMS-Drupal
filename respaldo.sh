#!/bin/bash
#Script para realizar el respaldo del sitio
#Listamos los sitios alojados en /var/www, quitando el dir html/
for d in $(ls  /var/www | grep -v html); do
	echo dir: $d
done
#comprimimos todos los sitios dentro de respaldo.tar.gz
#tambien agregamos el directorio de drupal en caso de encontrarse
#dentro de /html en lugar de /var/www/
tar -C /var/www -czf /tmp/respaldo.tar.gz $(ls /var/www | grep -v html & 
if [ -d /var/www/html/drupal ]; then
	#aprovechamos el cambio de directorio dado a tar con -C
	#asi solo escribimos la ruta relativa desde /var/www
	echo dir: html/drupal
fi)
