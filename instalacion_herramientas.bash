#!/bin/bash
function verifica()
{
	es_centos=2
	uname -r | grep 4.9.0-8-amd64 > /dev/null
	if [ $? -eq 0 ]; then
		es_centos=1
		return es_centos
	fi
	uname -r | grep "3.10.0-\(.*\).el7.x86_64" > /dev/null
	if [ $? -eq 0 ]; then
		es_centos=0
	fi
	uname -r | grep 3.16.0-6-amd64
	if [ $? -eq 0 ]; then
		es_centos=1
	fi
	if [ $es_centos -eq 2 ]; then
		echo "Sistema operativo no soportado"
		exit 1
	else
		return es_centos
	fi
}


function git_g()
{
	command -v git
	if [ $? -eq 0 ];
	then
		echo "git instalado" | tee -a reporte.txt
	else
		echo "Instalando git" | tee -a reporte.txt
		if [ $es_centos -eq 0 ]; then
			sudo yum -y install git
		else
			sudo apt install git
		fi
		if [ $? -eq 0 ];
		then
			echo "git se instalo correctamente" | tee -a reporte.txt
		else
			echo "Hubo un problema con la instalacion de git" | tee -a reporte.txt
		fi
	fi
}
function composer_g()
{	
	command -v composer
	if [ $? -eq 0 ];
	then
		echo "composer instalado" | tee -a reporte.txt
	else
		echo "Instalando composer" | tee -a reporte.txt
		sudo yum install php-cli php-zip wget unzip
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
		sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
		composer global require consolidation/cgr
		PATH="$(composer config -g home)/vendor/bin:$PATH"
		echo 'export PATH="$(composer config -g home)/vendor/bin:$PATH"' >> ~/.bashrc
		command -v composer
		if [ $? -eq 0 ];
		then
			echo "composer se instalo correctamente" | tee -a reporte.txt
		else
			echo "Hubo un problema con la instalacion de composer" | tee -a reporte.txt
		fi
	fi
}
function drush_g()
{
	command -v drush
	if [ $? -eq 0 ];
	then
		echo "drush instalado" | tee -a reporte.txt
	else
		echo "Instalando drush" | tee -a reporte.txt
		cgr drush/drush
		if [ $? -eq 0 ];
		then
			echo "drush se instalo correctamente" | tee -a reporte.txt
		else
			echo "Hubo un problema con la instalacion de drush" | tee -a reporte.txt
		fi
	fi
}
verifica
git_g
composer_g
drush_g
echo -e "\n Reinicia tu terminal\n"
