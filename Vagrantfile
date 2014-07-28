# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

url      = 'http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
box      = 'ubuntu/trusty64'
hostname = 'vagrantdev-buildstep'
ram      = '512'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = url
  config.vm.synced_folder ".", "/root/buildstep"
  config.vm.network :public_network
  config.vm.hostname = hostname

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--name", hostname]
    v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    v.customize ["modifyvm", :id, "--memory", ram]
  end

  $script = <<SCRIPT
echo provisioning...
sed --in-place -e "s:post-up route del default dev \\$IFACE$:post-up route del default dev \\$IFACE || true:g" /etc/network/interfaces
export DEBIAN_FRONTEND=noninteractive
apt-get update
xargs apt-get install -y --force-yes < /root/buildstep/stack/packages.txt
apt-get install -y --force-yes python-setuptools
apt-get clean
easy_install pip
pip install awscli
cd /root/buildstep && make docker
SCRIPT

  config.vm.provision "shell", inline: $script
end
