require 'chef_metal_vagrant'
with_driver 'vagrant'

vagrant_box 'centos65' do
    url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
end

vagrant_box 'precise64' do
    url 'http://files.vagrantup.com/precise64.box'
end

