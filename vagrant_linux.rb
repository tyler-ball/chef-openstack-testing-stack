require 'chef/provisioning/vagrant_driver'

vagrant_box 'centos65' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
end

vagrant_box 'precise64' do
  url 'http://files.vagrantup.com/precise64.box'
end

vagrant_box 'trusty64' do
  url 'http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
end
