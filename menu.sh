#!/bin/bash

function main(){
	# Busca directorios qye contengan la carpeta sites
	BUSQUEDA=$(find /var/www -name "sites" | sed -e 's/\/sites//')
	DIRS=(${BUSQUEDA// / })
	VERS=()
	#echo ${DIRS[@]}

	# Elimina las rutas que no sean de Drupal y añade la version de los que si
	for dir in ${DIRS[@]}
	do
		cd $dir
		DRUPAL=`drush status | grep "Drupal version"`
		if [ ${#DRUPAL} -eq 0 ]
		then
			DIRS=(${DIRS[@]/$dir})
		else
			VERSION=(${DRUPAL//':'/ })
			VERS+=(${VERSION[2]})
		fi
	done

	# Muestra el menú principal
	echo -e "\n\tMENU PRINCIPAL"
	CONT=1	
	for dir in ${DIRS[@]}
	do
		echo -e "\t$CONT) $dir (${VERS[CONT-1]})"
		(( CONT++ ))
	done
	echo -ne "\nIngresa el numero del VH de Drupal a actualizar (-1 para todos): "
	read OPC

	# Actualiza
	echo -e "\nActualizando... ${DIRS[$OPC-1]}"
	# Funcion apara actualizar
	# actualizar ${DIRS[$OPC-1]} ${VERS[$OPC-1]}
}

main	
