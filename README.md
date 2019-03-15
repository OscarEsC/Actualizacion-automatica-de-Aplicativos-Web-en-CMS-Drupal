# Actualizacion-automatica-de-Aplicativos-Web-en-CMS-Drupal
Scripts que permiten la actualización automática del core y módulos de terceros en el CMS Drupal 7. Se hace uso de Drush para posteriores actualizaciones  

# Dependencias  
Las siguientes dependencias son necesarias y suponemos que ya están instaladas:
 php-cli, php-zip, wget, unzip, php, php-gd, php-dom, php-pdo, php-mbstring, php-pgsql  
 También son necesarias politicas de sudo, de no contar con estas, es posible que haya errores inesperados e instalaciones sin configurar y no nos hacemos responsables de los daños que esto pueda provocar.  
 
### instalacion_herramientas.sh  
Verifica que git, composer y drush estén instalados en el equipo, de no ser así los instala
Se ejecuta de la siguiente manera:
bash 
### vhost.sh
Crea un virtual host para el acceso a drupal, habilita el https y lo redirecciona a éste. <br>
<code> . ./script.sh [\<ServerName> \<directorio_abdoluto>]... </code>

### dep.h
Instala dependencias necesarias para la correcta isntalacion de composer, drush, drupal, postgres y apache.
