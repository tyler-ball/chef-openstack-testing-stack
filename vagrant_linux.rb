require 'chef/provisioning/vagrant_driver'

vagrant_box 'centos7' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7_chef-provisionerless.box'
end

vagrant_box 'centos65' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
end

vagrant_box 'ubuntu14' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
end

with_driver "vagrant:#{File.dirname(__FILE__)}/vms"
with_machine_options :vagrant_options => {
  'vm.box' => 'centos7'
}
