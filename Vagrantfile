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
echo "*** hack to 'fix' https://github.com/mitchellh/vagrant/issues/3860 ***"
sed --in-place -e "s:post-up route del default dev \\$IFACE$:post-up route del default dev \\$IFACE || true:g" /etc/network/interfaces
echo "*** end hack ***"
export DEBIAN_FRONTEND=noninteractive
cd /root/buildstep && make docker
apt-get install -y --force-yes python-setuptools
easy_install pip
pip install awscli
SCRIPT

  config.vm.provision "shell", inline: $script
end
