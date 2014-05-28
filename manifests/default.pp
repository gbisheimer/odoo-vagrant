# odoo base system required packages
package { "python-dev": ensure => present }
package { "python-nltk": ensure => present }
package { "build-essential": ensure => present }
package { "python-setuptools": ensure => present }
package { "postgresql": ensure => present }
package { "bzr": ensure => present }
package { "graphviz": ensure => present }
package { "ghostscript": ensure => present }
package { "python-dateutil": ensure => present }
package { "python-feedparser": ensure => present }
package { "python-gdata": ensure => present }
package { "python-ldap": ensure => present }
package { "python-libxslt1": ensure => present }
package { "python-lxml": ensure => present }
package { "python-mako": ensure => present }
package { "python-openid": ensure => present }
package { "python-psycopg2": ensure => present }
package { "python-pybabel": ensure => present }
package { "python-pychart": ensure => present }
package { "python-pydot": ensure => present }
package { "python-pyparsing": ensure => present }
package { "python-reportlab": ensure => present }
package { "python-simplejson": ensure => present }
package { "python-tz": ensure => present }
package { "python-vatnumber": ensure => present }
package { "python-vobject": ensure => present }
package { "python-webdav": ensure => present }
package { "python-werkzeug": ensure => present }
package { "python-xlwt": ensure => present }
package { "python-yaml": ensure => present }
package { "python-imaging": ensure => present }
package { "python-matplotlib": ensure => present }
package { "python-docutils": ensure => present }
package { "python-unittest2": ensure => present }
package { "python-mock": ensure => present }
package { "python-jinja2": ensure => present }
package { "python-psutil": ensure => present }
package { "python-beautifulsoup": ensure => present }
package { "python-geoip": ensure => present }
package { "wkhtmltopdf": ensure => present }
package { "git": ensure => present }

# odoo_ar localization required packages
package { "python-geopy": ensure  => 'present' }

# Installs PostgreSQL 9.3 server from PGDG repository
class {'postgresql::globals':
  version => '9.3',
  manage_package_repo => true,
  encoding => 'UTF8',
  locale  => 'it_IT.utf8',
}->
class { 'postgresql::server':
  ensure => 'present',
  ip_mask_deny_postgres_user => '0.0.0.0/32', # Allows posgres user connection from any host
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses => '*',
  postgres_password => 'postgres',            # Sets default postgres user password
}

# Installs contrib modules
class { 'postgresql::server::contrib':
  package_ensure => 'present',
}

# Creates odoo user for postgresql login
postgresql::server::role { 'odoo':
  password_hash => postgresql_password('odoo', 'odoo'),
  createdb => true,
  login => true,
  replication => true,
}

# Adds odoo user to pg_hba.conf rules
postgresql::server::pg_hba_rule { 'allow odoo framework to access app database':
  description => "Allows md5 authentication to user odoo",
  type => 'host',
  address => '0.0.0.0/0',
  database => 'all',
  user => 'odoo',
  auth_method => 'md5',
}

vcsrepo { "/vagrant/odoo":
  ensure => latest,
  provider => git,
  source => 'https://github.com/odoo/odoo.git',
  revision => 'master',
}

file { "/home/vagrant/odoo":
  ensure => link,
	target => "/vagrant/odoo",
}

# Downloads wkhtmltopdf 0.12.0 and replaces the installed binary file
wget::fetch { 'http://hivelocity.dl.sourceforge.net/project/wkhtmltopdf/0.12.0/wkhtmltox-linux-amd64_0.12.0-03c001d.tar.xz':
  destination => '/tmp/wkhtmltox-linux.tar.xz',
  cache_dir   => '/var/cache',
	#cache_file  => 'wkhtmltox-linux.tar.xz',
	require => Package["wkhtmltopdf"],
}->
exec { 'tar -xf /tmp/wkhtmltox-linux.tar.xz':
  cwd => "/tmp",
	creates => "/tmp/wkhtmltox/bin/wkhtmltopdf",
	path => ["/bin", "/usr/bin", "/usr/sbin"],
}->
file { "/usr/bin/wkhtmltopdf":
	ensure => file,
	source => "/tmp/wkhtmltox/bin/wkhtmltopdf",
	source_permissions => ignore,
}