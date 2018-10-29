Vagrant.configure("2") do |config|
  
  config.vm.define "vault" do |vault|
    config.vm.box = "alvaro/xenial64"
      
    vault.vm.hostname = "node01"
    vault.vm.network "private_network", ip: "192.168.2.10"
    vault.vm.network "forwarded_port", guest: 8200, host: 8200
    vault.vm.provision :shell, :path => "scripts/provision.sh"
    vault.vm.provision :shell, :path => "scripts/vault.sh", run: "always"
    
    # set VM specs
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end  
  end
  
  config.vm.define "db" do |db|
    db.vm.box = "achuchulev/centos7_mysql"
    db.vm.hostname = "mysql01"
    db.vm.network "private_network", ip: "192.168.2.20"
    db.vm.network "forwarded_port", guest: 3306, host: 3306
    
    # set VM specs
    config.vm.provider "virtualbox" do |v2|
      v2.memory = 1024
      v2.cpus = 2
    end
  end

end
