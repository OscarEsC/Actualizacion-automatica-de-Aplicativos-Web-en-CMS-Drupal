#!/bin/bash

#EJECUTAR COMO ROOT!
#Instalador de las dependencias necesarias para el programa
#Dependiendo si el SO es CentOs o Debian, se ejecuta la funcion adecuada

#Funcion de instalacion de dependencias en distribuciones Red Hat
function dependencias_rh(){
    yum -y update 2> /dev/null
    echo "Sistema actualizado." | tee -a reporte.txt
    yum -y install php-cli php-zip wget unzip php php-gd php-dom php-pdo php-mbstring php-pgsql 2> /dev/null
    echo "Dependencias instaladas correctamente." | tee -a reporte.txt
}

#Funcion de instalacion de dependencias en distribuciones Debian
function dependencias_dev(){
	apt -y update 2> /dev/null
	echo "Sistema actualizado." | tee -a reporte.txt
    apt -y install php-cli php-zip wget unzip php php-gd php-dom php-pdo php-mbstring php-pgsql 2> /dev/null
    echo "Dependencias instaladas correctamente." | tee -a reporte.txt
}

#Funcion que revisa la distribucion base
function main (){
	#Si es Debian 9
	uname -r | grep 4.9.0-8-amd64 > /dev/null
	if [ $? -eq 0 ]; then
		echo "Debian 9 detectado" | tee -a reporte.txt
		dependecias_dev
	else 
		#Si es CentOs 7
		uname -r | grep 3.10.0-862.el7.x86_64 > /dev/null
		if [ $? -eq 0 ]; then
			echo "CentOs 7 detectado" | tee -a reporte.txt
			dependencias_rh
		else
			#Si es Debian 8
			uname -r | grep 3.16.0-6-amd64
			if [ $? -eq 0 ]; then
				echo "Debian 8 detectado" | tee -a reporte.txt
				dependencias_dev
			#Si no se detecto ninguno, no se instala nada
			#Termina la ejecucion con error
			else
				echo "No se soporta esta distribucion de GNU/Linux" | tee -a reporte.txt
				exit 1
			fi
		fi
	fi
}

main
