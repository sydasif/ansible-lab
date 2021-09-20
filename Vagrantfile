# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"

boxes = [

    {
        :name => "centos",
        :eth1 => "192.168.200.10",
        :mem => "1024",
	:cpu => "1",
        :image => "centos/7"
    },
    {
        :name => "ubuntu",
        :eth1 => "192.168.200.11",
        :mem => "1024",
	:cpu => "1",
        :image => "ubuntu/focal64"
    },
    {
        :name => "debian",
        :eth1 => "192.168.200.12",
        :mem => "1024",
	:cpu => "1",
        :image => "debian/jessie64"
    }
]

Vagrant.configure(2) do |config|
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.box = opts[:image]
      config.vm.hostname = opts[:name]
      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end
      config.vm.network :private_network, ip: opts[:eth1]
    end
  end
end
