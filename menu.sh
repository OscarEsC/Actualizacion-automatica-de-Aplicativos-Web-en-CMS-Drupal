#!/bin/bash

#Funcion que hace el respaldo del sitio dado como argumento
function respaldo (){
	dname= `echo $1 | sed 's/\/var\/www\///g' | grep -v \/`
	if [ ${#dname} -eq 0 ]; then
		echo "Nombre /tmp/respaldo_$dname.tar.gz"
		drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_$dname.tar.gz
	else
		echo "nombre /tmp/respaldo_$1.tar.gz"
		drush archive-dump --tar-options="--exclude=%files --exclude=.git" --preserve-symlinks --overwrite --destination=/tmp/respaldo_$1.tar.gz
	fi
}

# Funcion que actualiza Drupal
function actualizarDrupal(){ 
	cd $1
	#Se hace el respaldo del sitio antes de actualizar
	respaldo $1
	drush vset --exact maintenance_mode 1 
	drush cache-clear all
	drush rf
	drush pm-update drupal
	drush vset --exact maintenance_mode 0
	drush cache-clear all
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

# Función que verifica si hay actualizaciones disponibles para la versión instalada de Drupal
function verificaActualizacion(){
	cd $1
	V=`drush ups | grep "Drupal"`
	VERS_MAX=(${V// / })
	echo ${VERS_MAX[2]}
}

# Función que llama a la funcion que actualiza Drupal o informa si ya está en la última versión.
function actualizarVH(){
	# Verifica ultima version disponible
	ACT=$(verificaActualizacion $1)
	
	# Actualiza
	if [ ${#ACT} -eq 0 ]
	then
		echo "Actualizacion de Drupal en ${DIRS_SITES[$OPC-1]}. El sitio ya cuenta con la última versión."
	else
		echo "Actualizacion de Drupal en ${DIRS_SITES[$OPC-1]}. ${DIRS_VERS[$OPC-1]} -> $ACT"  | tee -a reporte.txt
		actualizarDrupal $1
	fi
}

function main(){
	# Busca directorios qye contengan la carpeta sites
	SITES=$(find /var/www -name "sites" | sed -e 's/\/sites//')
	DIRS_SITES=(${SITES// / })
	DIRS_VERS=()

	# Elimina las rutas que no sean de Drupal y añade la version de los que si
	for dir in ${DIRS_SITES[@]}
	do
		VERS_DIR=$(obtenerVersion $dir)
		if [ ${#VERS_DIR} -eq 0 ]
		then
			DIRS_SITES=(${DIRS_SITES[@]/$dir})
		else
			DIRS_VERS+=($VERS_DIR)
		fi
	done

	# Muestra el menú principal
	echo -e "\n\tMENU PRINCIPAL"
	CONT=1	
	for dir in ${DIRS_SITES[@]}
	do
		echo -e "\t$CONT) $dir (${DIRS_VERS[CONT-1]})"
		(( CONT++ ))
	done
	echo -ne "\nIngresa el numero del VH de Drupal a actualizar (-1 todos, 0 otra ruta): "
	read OPC

	# Analisis de opción elegida
	if [ $OPC -eq -1 ] # Actualiza todos los sitios
	then
		for dir in ${DIRS_SITES[@]}
		do
			actualizarVH $dir
		done
	elif [ $OPC -eq 0 ] # Actualiza otra ruta (si no se aloja en /var/www)
	then
		echo -ne "Introduce ruta absoluta del directorio con Drupal a actualizar: "
		read dir
		VERS_DIR=$(obtenerVersion $dir)
		if [ ${#VERS_DIR} -eq 0 ]
		then
			echo "directorio $dir no tiene Drupal instalado."
		else
			actualizarVH $dir
		fi
	elif [ $OPC -gt 0 ] && [ $OPC -lt $CONT ] # Actualiza una opción elegida
	then
		actualizarVH ${DIRS_SITES[$OPC-1]}
	else # Opcion no valida
		echo "Opcion no valida."
	fi		
}

main
