#!/bin/bash

function main()
{
	command -v git
	if [ $? -eq 0 ];
	then
		echo "git instalado" | tee -a reporte.txt
	else
		echo "Instalando git" | tee -a reporte.txt
		sudo yum -y install git
		if [ $? -eq 0 ];
		then
			echo "git se instalo correctamente" | tee -a reporte.txt
		else
			echo "Hubo un problema con la instalacion de git" | tee -a reporte.txt
		fi
	fi
	
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
main
echo -e "\n Reinicia tu terminal\n"
