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
			VERS+=(`echo $DRUPAL | sed -e 's/Drupal version : //'`)
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
	echo -ne "\nIngresa el numero del VH de Drupal a actualizar: "
	read OPC

	# Verifica ultima version disponible
	cd ${DIRS[$OPC-1]}
	V=`drush ups | grep "Drupal"`
	VERS=(${V// / })

	# Actualiza
	if [[ ${VERS[$OPC-1]} == ${VERS[2]} ]]
	then
		echo "El sitio ya cuenta con la última versión de Drupal."
	else
		echo "Actualizando Drupal..."
		# actualizar ${DIRS[$OPC-1]} ${VERS[$OPC-1]}
	fi
}

main
