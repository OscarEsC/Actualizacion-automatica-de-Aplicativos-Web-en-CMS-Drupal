#!/bin/bash

function main(){
        sudo yum -y update 2> /dev/null
        echo "Sistema actualizado." | tee -a reporte.txt
        sudo yum -y install php-cli php-zip wget unzip php php-gd php-dom php-pdo php-mbstring php-pgsql 2> /dev/null
        echo "Dependencias instaladas correctamente." | tee -a reporte.txt
}

main

