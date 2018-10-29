Vagrant.configure("2") do |config|

  # set VM specs
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
 
  # mysql db node
  config.vm.define "db" do |db|
    db.vm.box = "achuchulev/centos7_mysql"
    db.vm.hostname = "mysql01"
    db.vm.network "private_network", ip: "192.168.2.20"
    db.vm.network "forwarded_port", guest: 3306, host: 3306
    db.vm.provision :shell, :path => "scripts/setup_mysql.sh"
  end

  # vault node
  config.vm.define "vault" do |vault|
    vault.vm.box = "alvaro/xenial64"
    vault.vm.hostname = "node01"
    vault.vm.network "private_network", ip: "192.168.2.10"
    vault.vm.network "forwarded_port", guest: 8200, host: 8200
    vault.vm.provision :shell, :path => "scripts/provision.sh"
    vault.vm.provision :shell, :path => "scripts/vault.sh", run: "always"
  end
  
end
