#!/bin/sh

apt-get update
(puppet module list | grep puppetlabs-postgresql ) || (mkdir -p /etc/puppet/modules; puppet module install puppetlabs/postgresql)
(puppet module list | grep puppetlabs-vcsrepo ) || (mkdir -p /etc/puppet/modules; puppet module install puppetlabs/vcsrepo)
(puppet module list | grep maestrodev-wget ) || (mkdir -p /etc/puppet/modules; puppet module install maestrodev-wget)