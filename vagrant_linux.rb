require 'chef_metal_vagrant'
with_driver 'vagrant'

vagrant_box 'centos65' do
    url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
end

# with_machine_options :vagrant_options => {
#     'vm.box' => 'centos65',
#     'vm.network' => "forwarded_port", guest: 443, host: 9443,
#     'vm.network' => "forwarded_port", guest: 8773, host: 9773,
#     'vm.network' => "forwarded_port", guest: 8774, host: 9774,
#     'vm.network' => "forwarded_port", guest: 4001, host: 4001
# }


with_machine_options :vagrant_options => { 'vm.box' => 'centos65' },
                     :vagrant_config => [ "config.vm.network \"forwarded_port\", guest: 443, host: 9443","config.vm.network \"forwarded_port\", guest: 8773, host: 9773" ]

      # "config.vm.network forwarded_port, guest: 8773, host: 9773"
      # "config.vm.network forwarded_port, guest: 8774, host: 9774"
      # "config.vm.network forwarded_port, guest: 4001, host: 4001"
