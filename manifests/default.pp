# odoo base system required packages
$python_libs_base = [ 
"python-dev",
"python-nltk",
"build-essential",
"python-setuptools",
"postgresql",
"bzr",
"graphviz",
"ghostscript",
"python-dateutil",
"python-feedparser",
"python-gdata",
"python-ldap",
"python-libxslt1",
"python-lxml",
"python-mako",
"python-openid",
"python-psycopg2",
"python-pybabel",
"python-pychart",
"python-pydot",
"python-pyparsing",
"python-reportlab",
"python-simplejson",
"python-tz",
"python-vatnumber",
"python-vobject",
"python-webdav",
"python-werkzeug",
"python-xlwt",
"python-yaml",
"python-imaging",
"python-matplotlib",
"python-docutils",
"python-unittest2",
"python-mock",
"python-jinja2",
"python-psutil",
"python-beautifulsoup",
"python-geoip",
"wkhtmltopdf",
"git",
]

package { $python_libs_base:
  ensure  => present,
}

# odoo_ar localization required packages
$python_libs_odoo_ar = [
"python-geopy",
]

package { $python_libs_odoo_ar:
  ensure  => present,
}

# Installs PostgreSQL 9.3 server from PGDG repository
class {'postgresql::globals':
  version => '9.3',
  manage_package_repo => true,
  encoding => 'UTF8',
  locale  => 'it_IT.utf8',
}->
class { 'postgresql::server':
  ensure => 'present',
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses => '*',
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
  description => "Allows peer authentication to user odoo",
  type => 'local',
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
    #cache_dir   => '/var/cache/wget',
	#cache_file  => 'wkhtmltox-linux.tar.xz',
	require => Package["wkhtmltopdf"],
}->
exec { 'tar -xf /tmp/wkhtmltox-linux.tar.xz':
    cwd => "/tmp",
	creates => "/tmp/wkhtmltox/bin/wkhtmltopdf",
	path => ["/usr/bin", "/usr/sbin"],
}->
file { "/usr/bin/wkhtmltopdf":
	ensure => file,
	source => "/tmp/wkhtmltox/bin/wkhtmltopdf",
	source_permissions => ignore,
}