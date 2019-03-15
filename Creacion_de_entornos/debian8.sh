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
	cd /usr/lib/postgresql/9.4/bin/
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
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

        ServerName $SN
        DocumentRoot $DIR/$SN
        ErrorLog $DIR/error.log
        CustomLog $DIR/requests.log combined
        <Directory $DIR/$SN>
                AllowOverride All
                Order Deny,Allow
        </Directory>
</VirtualHost>

<VirtualHost *:443>
        ServerName $SN
        SSLEngine On
        SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

		DocumentRoot $DIR/$SN
        ErrorLog $DIR/error.log
        CustomLog $DIR/requests.log combined
        <Directory $DIR/$SN>
                AllowOverride All
                Order Deny,Allow
        </Directory>
</VirtualHost>
" > "/etc/apache2/sites-available/$SN.conf"

			apt install libxml2 libapache2-modsecurity -y
			cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
			sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' "/etc/modsecurity/modsecurity.conf"
			touch /var/log/apache2/modsec_audit.log
			chown root:adm /var/log/apache2/modsec_audit.log
			chmod 0640 /var/log/apache2/modsec_audit.log

			sed -i 's/ServerTokens OS/ServerTokens ProductOnly/g' "/etc/apache2/conf-available/security.conf"
			sed -i 's/ServerSignature On/#ServerSignature On/g' "/etc/apache2/conf-available/security.conf"
			sed -i 's/#ServerSignature Off/ServerSignature Off/g' "/etc/apache2/conf-available/security.conf"

			a2ensite "$SN.conf"
			a2enmod ssl
			a2ensite default-ssl
			a2enmod rewrite
			a2enmod security2
			a2enmod unique_id
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
	crearSitios $*
	echo "Sitios creados"
	#drupal $*
	echo "Drupal instalado"
}

main $*
