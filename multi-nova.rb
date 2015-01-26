require 'chef/provisioning'

controller_config = <<-ENDCONFIG
  config.vm.network "forwarded_port", guest: 443, host: 9443 # dashboard-ssl
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 6080, host: 6080
  config.vm.network "forwarded_port", guest: 8773, host: 8773 # compute-ec2-api
  config.vm.network "forwarded_port", guest: 8774, host: 8774 # compute-api
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "public_network", ip: "172.16.100.60", bridge: 'en0: Wi-Fi (AirPort)'
  config.vm.network "private_network", ip: "192.168.200.60"
ENDCONFIG

machine 'controller' do
  add_machine_options :vagrant_config => controller_config
  role 'os-compute-single-controller'
  recipe 'openstack-network::identity_registration'
  role 'os-network-dhcp-agent'
  role 'os-network-metadata-agent'
  role 'os-network-server'
  recipe 'openstack-common::openrc'
  chef_environment 'vagrant-multi-nova'
  file '/etc/chef/openstack_data_bag_secret',"#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret"
  converge true
end

machine_batch do
  [ ['compute1', 61], ['compute2', 62], ['compute3', 63] ].each do |name, ip_suff|
    machine name do
      add_machine_options :vagrant_config => <<-ENDCONFIG
config.vm.provider "virtualbox" do |v|
  v.memory = 2048
  v.cpus = 2
  v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
end
config.vm.network "public_network", ip: "172.16.100.#{ip_suff}", bridge: 'en0: Wi-Fi (AirPort)'
config.vm.network "private_network", ip: "192.168.200.#{ip_suff}"
ENDCONFIG
      role 'os-compute-worker'
      chef_environment 'vagrant-multi-nova'
      file '/etc/chef/openstack_data_bag_secret',"#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret"
      converge true
    end
  end
end
