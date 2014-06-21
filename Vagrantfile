# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "vagrant.example.com"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.network "forwarded_port", guest: 8069, host: 8069
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  config.vm.network "forwarded_port", guest: 4200, host: 4200

  config.vm.provision :shell, :path => "shell/main.sh"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "default.pp"
	puppet.options = "--verbose"
  end
end
