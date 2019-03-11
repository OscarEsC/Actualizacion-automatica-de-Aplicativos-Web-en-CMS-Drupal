#!/bin/bash

#Script para inicializacion del DBMS PostgreSQL y poder usarlo con Drupal

#Primero se revisa si se tiene instalado ya postgresql, de ser asi se asume que ya se ha
#inicializado la bd y se ha iniciado el servicio con systemctl
yum list installed | grep postgresql >/dev/null
#Si ya se tiene instalado, solo se crea el usuario y la bd necesarias para drupal
if [ $? -eq 0 ];then
	echo "PostgreSQL ya esta instalado en esta maquina" | tee -a reporte.txt

	su postgres -c "createuser --pwprompt --encrypted --no-createrole --no-createdb drupaluser"
        
	if [ $? -eq 0 ];then
	        echo "Se ha creado el usuario para drupal  en PostgreSQL correctamente" | tee -a reporte.txt
        else
        	echo "Ocurrio un error creando el usuario para drupal en PostgreSQL" | tee -a reporte.txt
        fi

	su postgres -c "createdb --encoding=UTF8 --owner=username drupaldb"
        if [ $? -eq 0 ];then
	        echo "Se ha creado la BD para drupal  en PostgreSQL correctamente" | tee -a reporte.txt
        else
        	echo "Ocurrio un error creando la BD para drupal en PostgreSQL" | tee -a reporte.txt
        fi

#Si no se tiene instalado, se instala, se inicializa y se habilita el servicio postgresql
else
	yum install postgresql postgresql-server postgresql-contrib >/dev/null
	if [ $? -eq 0 ]; then
		echo "PostgreSQL se ha instalado correctamente" | tee -a reporte.txt

		#Se inicializa la BD de postgreSQL
		postgresql-setup initdb >/dev/null

		if [ $? -eq 0 ];then
			echo "Se inicializo correctamente la BD de PostgreSQL" | tee -a reporte.txt
		else
			echo "Ocurrio un error al inicializar la BD de PostgreSQL" | tee -a reporte.txt
		fi

		#Se habilita el servicio
		systemctl start postgresql
		systemctl enable postgresql

		if [ $? -eq 0 ];then
			echo "Se inicio correctamente el servicio de PostgreSQL" | tee -a reporte.txt
		else
			echo "Ocurrio un error al iniciar el servicio de PostgreSQL" | tee -a reporte.txt
		fi

		#Se crea el usuario necesario para Drupal
		su postgres -c "createuser --pwprompt --encrypted --no-createrole --no-createdb drupaluser"
		if [ $? -eq 0 ];then
			echo "Se ha creado el usuario para drupal  en PostgreSQL correctamente" | tee -a reporte.txt
		else
			echo "Ocurrio un error creando el usuario para drupal en PostgreSQL" | tee -a reporte.txt
		fi

		#Se crea la bd necesaria para Drupal
		su postgres -c "createdb --encoding=UTF8 --owner=username drupaldb"
		if [ $?	-eq 0 ];then
        	        echo "Se ha creado la BD para drupal  en PostgreSQL correctamente" | tee -a reporte.txt
	        else
        	        echo "Ocurrio un error creando la BD para drupal en PostgreSQL" | tee -a reporte.txt
	        fi


	else
		echo "Ocurrio un error al instalar PostgreSQL" | tee -a reporte.txt
	fi

fi
