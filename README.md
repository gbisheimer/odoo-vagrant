odoo-vagrant
============

Definición de una máquina virtual Vagrant para ejecutar ODOO (ex OpenERP) en modo desarrollo.

Pasos para poder utilizarla:
* Instalar VirtualBox [https://www.virtualbox.org/wiki/Downloads]
* Instalar Vagrand [https://www.vagrantup.com/downloads.html]
* Clonar este repositorio
* En caso de tener una copia local de la rama de odoo [https://github.com/odoo/odoo.git], copiarla/moverla a la carpeta del repositiorio. Sino, se bajará automáticamente durante la instalación
* Abrir una consola en la carpeta del repositorio y ejecutar `vagrant up`
* Esperar a que se baje el archivo de la VM (por defecto la instalación se realiza sobre un ubuntu/trusty64-clouding) y se instalen y configuren todos los paquetes correspondientes.
* Al finalizar la instalación, se puede acceder a la VM mediante ssh en el puerto 2222 de la máquina local.
* usuario y password por defecto = 'vagrant'
* Abrir la carpeta /home/vagrant/oodo y ejecutar `python ./openerp-server -s --db_user=odoo --db_password=odoo --db_host=localhost --addons-path=addons`
* Esto crea un archivo de configuración con los valores por defecto en ~/.openerp_serverrc. Luego se puede invocar este archivo desde la línea de comando mediante `python ./openerp-server -c ~/.openerp_serverrc`
 
