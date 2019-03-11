#!/bin/bash

function crearSitios(){
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

			`echo "<VirtualHost *:80>
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

        ServerName $SN
        DocumentRoot $DIR
        ErrorLog $DIR/error.log
        CustomLog $DIR/requests.log combined
        <Directory $DIR>
                AllowOverride All
        </Directory>
</VirtualHost>

<VirtualHost *:443>
        ServerName $SN
        SSLEngine On
        SSLCertificateFile /etc/pki/tls/certs/ca.crt
        SSLCertificateKeyFile /etc/pki/tls/private/ca.key
        DocumentRoot $DIR
        ErrorLog $DIR/error.log
        CustomLog $DIR/requests.log combined
        <Directory $DIR>
                AllowOverride All
        </Directory>
</VirtualHost>
" > "/etc/httpd/sites-available/$SN.conf"`

	`ln -s "/etc/httpd/sites-available/$SN.conf" "/etc/httpd/sites-enabled/$SN.conf" 2> /dev/null`
		done
	fi
}

function crearCarpetas(){
	DIRECTORY="/etc/httpd/sites-available"
	if [ ! -d $DIRECTORY ]
	then
		mkdir $DIRECTORY
	fi
	DIRECTORY="/etc/httpd/sites-enabled"
	if [ ! -d $DIRECTORY ]
	then
		mkdir $DIRECTORY
	fi
}

function habilitarSSL(){
	`echo "IncludeOptional sites-enabled/*.conf" | tee -a /etc/httpd/conf/httpd.conf`
	`openssl genrsa -out ca.key 2048`
	`openssl req -new -key ca.key -out ca.csr`
	`openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt`
	`cp ca.crt /etc/pki/tls/certs/`
	`cp ca.key /etc/pki/tls/private/`
	`cp ca.csr /etc/pki/tls/private/`
	`sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile \/etc\/pki\/tls\/certs\/ca.crt/g' "/etc/httpd/conf.d/ssl.conf"`
	`sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/ca.key/g' "/etc/httpd/conf.d/ssl.conf"`
	`apachectl restart`
}

function main(){
	crearCarpetas
	habilitarSSL
	crearSitios $*	
}

main $*
