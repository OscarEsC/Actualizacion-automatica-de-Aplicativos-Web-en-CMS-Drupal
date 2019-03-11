#!/bin/bash

function main(){
	`yum -y update`
	`yum -y install php php-gd php-dom php-pdo php-mbstring php-pgsql postgresql postgresql-server postgresql-contrib`
}

main
