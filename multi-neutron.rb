require 'chef/provisioning'

controller_config = <<-ENDCONFIG
  config.vm.box = "centos65"
  config.vm.network "forwarded_port", guest: 443, host: 9443 # dashboard-ssl
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
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
  config.vm.network "private_network", ip: "192.168.100.60"
  config.vm.network "private_network", ip: "172.16.10.60"
ENDCONFIG

machine 'controller' do
  machine_options :vagrant_config => controller_config
  role 'os-compute-single-controller-no-network'
  recipe 'openstack-network::identity_registration'
  role 'os-network-openvswitch'
  role 'os-network-dhcp-agent'
  role 'os-network-metadata-agent'
  role 'os-network-server'
  chef_environment 'vagrant-multi-neutron'
  file '/etc/chef/openstack_data_bag_secret','#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret'
  converge true
end

compute1_config = <<-ENDCONFIG
  config.vm.box = "centos65"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.61"
  config.vm.network "private_network", ip: "172.16.10.61"
ENDCONFIG

machine 'compute1' do
  machine_options :vagrant_config => compute1_config
  role 'os-compute-worker'
  chef_environment 'vagrant-multi-neutron'
  file '/etc/chef/openstack_data_bag_secret','#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret'
  converge true
end

compute2_config = <<-ENDCONFIG
  config.vm.box = "centos65"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.62"
  config.vm.network "private_network", ip: "172.16.10.62"
ENDCONFIG

machine 'compute2' do
  machine_options :vagrant_config => compute2_config
  role 'os-compute-worker'
  chef_environment 'vagrant-multi-neutron'
  file '/etc/chef/openstack_data_bag_secret','#{File.dirname(__FILE__)}/.chef/encrypted_data_bag_secret'
  converge true
end
