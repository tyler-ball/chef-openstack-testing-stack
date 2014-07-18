require 'chef_metal'

# with_driver 'vagrant'

# with_machine_options :vagrant_options => { 'vm.box' => 'centos65' },
#                      :vagrant_config =>
#       "config.vm.network forwarded_port, guest: 443, host: 9443"
#       "config.vm.network forwarded_port, guest: 8773, host: 9773"
#       "config.vm.network forwarded_port, guest: 8774, host: 9774"
#       "config.vm.network forwarded_port, guest: 4001, host: 4001"

machine 'mario' do
    tag 'itsa_me'
    converge true
end
