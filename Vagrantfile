# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

# Directory where applications will be installed
APPS_HOME   = "/home/apps"
DOMAIN_NAME = "your app domain name"

# Vagrant configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.define "server" do |server|
    server.vm.hostname = "#{DOMAIN_NAME}"
    server.vm.network :private_network, ip: "172.16.0.90", :netmask => "255.255.0.0"
    server.vm.synced_folder "./resources",     "/resources"

    # App folders
    server.vm.synced_folder "./apps/bin",  "#{APPS_HOME}/#{DOMAIN_NAME}/bin"

    # Web stack provisioners
    server.vm.provision "shell", path: "provisioners/bootstrap.sh"
    server.vm.provision "shell", path: "provisioners/nginx.sh"
    #server.vm.provision "shell", path: "provisioners/node.sh"
    #server.vm.provision "shell", path: "provisioners/mongodb.sh"
    #server.vm.provision "shell", path: "provisioners/openports.sh", args: ["80","443"]
    #server.vm.provision "shell", path: "provisioners/app.sh", args: ["#{DOMAIN_NAME}"]
  end

end
