#!/bin/bash

function entorno(){
	# Instalar dependencias
	apt install git php5 php5-curl php5-gd php5-pgsql postgresql
	# Instalar composer
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer
	composer global require consolidation/cgr
	PATH="$(composer config -g home)/vendor/bin:$PATH"
	echo 'export PATH="$(composer config -g home)/vendor/bin:$PATH"' >> ~/.bashrc
	# instalar drush
	cgr drush/drush
}

function postgres(){
	# Instalar postgresql
	export LC_CTYPE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	systemctl start postgresql
	systemctl enable postgresql
	sudo mkdir -p /usr/local/pgsql/data
	sudo chown -R postgres:postgres /usr/local/pgsql/
	sudo su - postgres
	cd /usr/lib/postgresql/9.3/bin/
	./initdb -D /usr/local/pgsql/data
	./postgres -D /usr/local/pgsql/data
}

function crearSitios(){
	echo $*
	if [ `echo "$# % 2" | bc` -eq 0 ]
	then
		while [ `echo "$#" | bc` -gt 1 ]
		do
			SN=$1
			shift
			DIR=$1
			shift

			if [ ! -d $DIR ]
			then
				mkdir -p $DIR
			fi

			echo "<VirtualHost *:80>
        #RewriteEngine On
        #RewriteCond %{HTTPS} !=on
        #RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

        ServerName $SN
        DocumentRoot $DIR/$SN
        ErrorLog $DIR/error.log
        CustomLog $DIR/requests.log combined
        <Directory $DIR/$SN>
                AllowOverride All
        </Directory>
</VirtualHost>
" > "/etc/apache2/sites-available/$SN.conf"

			a2ensite "$SN.conf"
			service apache2 restart
		done
	fi
}

function drupal(){
	if [ `echo "$# % 2" | bc` -eq 0 ]
	then
		while [ `echo "$#" | bc` -gt 1 ]
		do
			SN=$1
			shift
			DIR=$1
			shift

			mkdir $DIR
			cd $DIR
			composer create-project drupal-composer/drupal-project:7.x-dev . --no-dev --no-interaction --no-install
			sed -i 's/"drupal\/drupal": "\^7\.62",/"drupal\/drupal": "7\.59",/g' "./composer.json"
			composer install
			mv web $SN
		done
	fi
}

function main(){
	entorno
	echo "Entorno creado"
	postgres
	echo "Postgres instalado."
	crearSitios $*
	echo "Sitios creados"
	drupal $*
	echo "Drupal instalado"
}

main $*

