# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

box      = 'precise64'
url      = 'http://files.vagrantup.com/precise64.box'
hostname = 'vagrantdev-buildstep'
ram      = '256'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = url
  config.vm.synced_folder ".", "/root/buildstep"
  config.vm.network :public_network

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--name", hostname]
    v.customize ["modifyvm", :id, "--memory", ram]
  end

  $script = <<SCRIPT
echo provisioning...
export DEBIAN_FRONTEND=noninteractive
apt-get update
xargs apt-get install -y --force-yes < /root/buildstep/stack/packages.txt
apt-get install -y --force-yes python-setuptools
apt-get clean
easy_install pip
pip install s3cmd
cd /root/buildstep && make docker
SCRIPT

  config.vm.provision "shell", inline: $script
end
