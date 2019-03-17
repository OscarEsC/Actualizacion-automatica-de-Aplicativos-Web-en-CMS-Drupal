# Actualizacion-automatica-de-Aplicativos-Web-en-CMS-Drupal
Scripts que permiten la actualización automática del core y módulos de terceros en el CMS Drupal 7. Se hace uso de Drush para posteriores actualizaciones. Todos los scripts escriben los reportes de las acciones sobre el archivo "reporte.txt". Se recomienda la ejecucion de
los scripts en este orden en que aparecen.

menu.sh es el script principal. En este es donde se actualiza/restaura un sitio de drupal utilizando drush.

# Dependencias  
Las siguientes dependencias son necesarias y suponemos que ya están instaladas:  
 php-cli, php-zip, wget, unzip, php, php-gd, php-dom, php-pdo, php-mbstring, php-pgsql  
 También son necesarias politicas de sudo, de no contar con estas, es posible que haya errores inesperados e instalaciones sin configurar y no nos hacemos responsables de los daños que esto pueda provocar.  
 
### dependencias.sh
Instala dependencias necesarias para la correcta instalacion de composer, drush, drupal, postgres y apache.
Funciona tanto para Debian (8 y 9) y CentOs7, no para otro SO distinto.

### instalacion_herramientas.sh  
Verifica que git, composer y drush estén instalados en el equipo, de no ser así los instala.  
Ejecución:  
bash instalacion_herramientas.sh  

### menu.sh  
Lista los sitios drupal y puede actualizar uno o varios. Antes de hacer la actualización hace un respaldo de los sitios y al finalizar la actualización se tiene la posibilidad de restaurar el sitio hasta antes de actualizarlo.  
Ejecución:  
bash menu.sh

### vhost.sh
Crea un virtual host para el acceso a drupal, habilita el https y lo redirecciona a éste. <br>
<code> . ./vhost.sh [\<ServerName> \<directorio_abdoluto>]... </code>
