desc "Vendor your cookbooks/"
task :berks_vendor do
  _setup
  sh %{chef exec berks vendor cookbooks}
end

desc "All-in-One Neutron build"
task :aio_neutron do
  _setup
  sh %{time chef exec chef-client -z vagrant_linux.rb aio-neutron.rb}
end

desc "All-in-One Nova-networking build"
task :aio_nova do
  _setup
  sh %{time chef exec chef-client -z vagrant_linux.rb aio-nova.rb}
end

desc "Multi-Neutron build"
task :multi_neutron do
  _setup
  sh %{time chef exec chef-client -z vagrant_linux.rb multi-neutron.rb}
end

desc "Multi-Nova-networking build"
task :multi_nova do
  _setup
  sh %{time chef exec chef-client -z vagrant_linux.rb multi-nova.rb}
end

desc "Destroy Cookbooks"
task :destroy_cookbooks do
  _setup
  sh %{rm -rf Berksfile.lock && rm -rf cookbooks/}
end

desc "Destroy Machines"
task :destroy_machines do
  _setup
  sh %{chef exec chef-client -z destroy_all.rb}
end

desc "blow everything away"
task :clean => [ :destroy_machines, :destory_cookbooks ]

# Setup the chef client logging level according to the Rake output level
def _setup
  ENV['CHEF_DRIVER'] = 'vagrant'
end
