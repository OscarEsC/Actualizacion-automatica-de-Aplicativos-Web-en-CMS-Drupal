#!/bin/sh

#Funcion que restaura un sitio con el respaldo asignado a este sitio
function restoreSite (){
	#dname= `echo $1 | sed 's/\/var\/www\///g' | grep -v \/`
	dd=$(echo /var/www/drupal | sed 's/\/var\/www\///g' | grep -v \/)
	if [ $? -eq 0 ]; then	
		dname= $(echo $dd)
		echo "Dir $dname"
		if [ -f /tmp/respaldo_$dname ]; then
			drush archive-restore /tmp/respaldo_$dname.tar.gz
		else
			echo "No existe un archivo de backup asociado a este sitio"
		fi
	else
		if [ -f /tmp/respaldo_$1 ];then
			drush archive-restore /tmp/respaldo_$1.tar.gz
		else
			echo "No existe	un archivo de backup asociado a	este sitio"
		fi
	fi
}

# Función que obtiene la versión instalada de Drupal
function obtenerVersion(){
        cd $1
	DRUPAL=`drush status | grep "Drupal version"`
        if [ ${#DRUPAL} -eq 0 ]
        then
            	DIRS=(${DIRS[@]/$dir})
        else
            	VERS=(`echo $DRUPAL | sed -e 's/Drupal version : //'`)
                echo $VERS
        fi
	echo ""
}


function main (){
	echo -e "\nEscribe la ruta absoluta del sitio que deseas restaurar"
	read dir

	VERS_DIR=$(obtenerVersion $dir)
	if [ ${#VERS_DIR} -eq 0 ]; then
		restoreSite $dir
	else
		echo "Este no es un sitio con Drupal instalado"
	fi
}

main
