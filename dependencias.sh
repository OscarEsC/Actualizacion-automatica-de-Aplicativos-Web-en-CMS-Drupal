#!/bin/bash

#Instalador de las dependencias necesarias para el programa
#Dependiendo si el SO es CentOs o Debian, se ejecuta el gestor de paquetes debido

#IMPORTANTE
#Se necesitan permisos de sudo sobre el gestor de paquetes


#Funcion de instalacion de dependencias en distribuciones Red Hat y Debian
function dependencias(){
    #ejecutamos el comando asociado a la variable de entorno pm
    sudo $pm -y update 2> /dev/null
    echo "Sistema actualizado." | tee -a reporte.txt
    sudo $pm -y install php-cli php-zip wget unzip php php-gd php-dom php-pdo php-mbstring php-pgsql 2> /dev/null
    echo "Dependencias instaladas correctamente." | tee -a reporte.txt
}

#Funcion que revisa la distribucion base
function revisa_distro (){
	#Si es Debian 9
	uname -r | grep "4.9.0-\(.*\)-amd64" > /dev/null
	if [ $? -eq 0 ]; then
		echo "Debian 9 detectado" | tee -a reporte.txt
		#pm es una variable de entorno
		pm=apt
		dependencias
	else
		#Si es CentOs 7
		uname -r | grep "3.10.0-\(.*\).el7.x86_64" > /dev/null
		if [ $? -eq 0 ]; then
			echo "CentOs 7 detectado" | tee -a reporte.txt
			#pm es una variable de entorno
			pm=yum
			dependencias
		else
			#Si es Debian 8
			uname -r | grep "3.16.0-\(.*\)-amd64"
			if [ $? -eq 0 ]; then
				echo "Debian 8 detectado" | tee -a reporte.txt
				pm=apt
				dependencias
			#Si no se detecto ninguno, no se instala nada
			#Termina la ejecucion con error
			else
				echo "No se soporta esta distribucion de GNU/Linux" | tee -a reporte.txt
				exit 1
			fi
		fi
	fi
}

revisa_distro
