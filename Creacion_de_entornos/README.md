### debian8.sh
Crea un entorno virtual en debian 8 (instala postgres --no crea las bases de datos--, composer, drush, crea los sitios con Drupal, y añade los sitios a apache como VirtualHosts <br>
<code> . ./debian8.sh [\<ServerName> \<directorio_abdoluto>]... </code> <br>
Ejemplo <br>
<code> ./debian8.sh sitio1 /var/www/sitio1 </code> <br>
  
  ###modulos.sh
  Instala y habilita los modulos para el sitio drupal especificado como argumento. Se ejecuta de la siguiente manera:
  <code> ./modulos.sh /var/www/sitio1/sitio1 </code>
