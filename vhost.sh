#!/bin/bash

function main(){
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
	`echo '<VirtualHost *:80>
        RewriteEngine On
        RewriteCond %{HTTPS} !=on
        RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

        ServerName drupal
        DocumentRoot /var/www/drupal/drupal-7.59
        ErrorLog /var/www/drupal/drupal-7.59/error.log
        CustomLog /var/www/drupal/drupal-7.59/requests.log combined
        <Directory /var/www/drupal/drupal-7.59>
                AllowOverride All
        </Directory>
</VirtualHost>

<VirtualHost *:443>
        ServerName drupal
        SSLEngine On
        SSLCertificateFile /etc/pki/tls/certs/ca.crt
        SSLCertificateKeyFile /etc/pki/tls/private/ca.key
        DocumentRoot /var/www/drupal/drupal-7.59
        ErrorLog /var/www/drupal/drupal-7.59/error.log
        CustomLog /var/www/drupal/drupal-7.59/requests.log combined
        <Directory /var/www/drupal/drupal-7.59>
                AllowOverride All
        </Directory>
</VirtualHost>
' > /etc/httpd/sites-available/drupal.conf`

	`ln -s /etc/httpd/sites-available/drupal.conf /etc/httpd/sites-enabled/drupal.conf`
	`echo "IncludeOptional sites-enabled/*.conf" | tee -a /etc/httpd/conf/httpd.conf`
	`yum install mod_ssl openssl`
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

main
