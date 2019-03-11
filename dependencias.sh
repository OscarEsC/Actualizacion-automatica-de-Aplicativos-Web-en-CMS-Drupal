#!/bin/bash

function main(){
        `yum -y update 2> /dev/null`
        echo "Sistema actualizado." | tee -a reporte.txt
        `yum -y install php php-gd php-dom php-pdo php-mbstring php-pgsql postgresql postgresql-server postgresql-contrib 2> /dev/null`
        echo "Dependencias instaladas correctamente." | tee -a reporte.txt
}

main

