odoo-vagrant
============

Definición de una máquina virtual Vagrant para ejecutar ODOO (ex OpenERP) en modo desarrollo.

### Pasos para poder utilizarla:
* Instalar [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Instalar [Vagrand](https://www.vagrantup.com/downloads.html)
* Clonar este repositorio
* En caso de tener una copia local de la rama de [ODOO](https://github.com/odoo/odoo.git), copiarla/moverla a la carpeta del repositiorio. Sino, se bajará automáticamente durante la instalación. Por defecto se baja el branch MASTER. En caso de querer trabajar en otra rama, modificar el archivo [manifests/default.pp](https://github.com/gbisheimer/odoo-vagrant/blob/master/manifests/default.pp#L92).
* Abrir una consola en la carpeta del repositorio y ejecutar `vagrant up`
* Esperar a que se baje el archivo de la VM (por defecto la instalación se realiza sobre un ubuntu/trusty64-clouding) y se instalen y configuren todos los paquetes correspondientes.
* Al finalizar la instalación, se puede acceder a la VM mediante SSH en el puerto 2222 de la máquina local. El usuario y password por defecto es 'vagrant'
* Vagrant monta automáticamente la carpeta del repositorio en la carpeta `/vagrant` de la máquina virtual, por lo que la edición del código fuente lo podemos hacer directamente en la máquina host y estos cambios se veran reflejados en la VM automáticamente.
* Al ejecutar ODOO por primera vez, abrir una conexión ssh a la VM, abrir la carpeta /vagrant/oodo y ejecutar `python ./openerp-server -s --db_user=odoo --db_password=odoo --db_host=localhost --addons-path=addons`. Esto crea un archivo de configuración con los valores por defecto en ~/.openerp_serverrc.
* Para ejecuciones posteriores se correr el servidor mediante `python ./openerp-server`. Odoo cargará automáticamente el archivo de configuración por defecto creado en el punto anterior.

### Modo Debug
Para realizar la depuración del código se puede utilizar [Eclipse](http://www.eclipse.org/downloads/) e instalar el paquete [PyDev](http://pydev.org/manual_101_install.html). En el repositorio se agregó el paquete necesario para realizar el debug remoto en la carpeta `pysrc`. En el archivo `openerp-server-pydev.py` se incluyó la configuración por defecto para conectarse a la máquina host donde corra el depurador. En caso de ser necesario, editar este archivo para ajustar la dirección ip de la máquina host y para redireccionar la salida de la consola a eclipse (por defecto está deshabilitada). Los pasos para configurar Eclipse para correr ODOO en forma remota seguir estos [pasos](http://pydev.org/manual_adv_remote_debugger.html).
