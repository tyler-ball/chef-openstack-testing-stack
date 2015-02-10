#task default: ["test"]


task :destroy_all do
  sh %{chef exec chef-client -z destroy_all.rb && rm -rf Gemfile.lock && rm -rf Berksfile.lock && rm -rf cookbooks/}
end

desc "Destroy Machines"
task :destroy_machines do
  sh %{chef exec chef-client -z destroy_all.rb}
end

desc "Vendor your cookbooks/"
task :berks_vendor do
  sh %{chef exec berks vendor cookbooks}
end

desc "All-in-One Neutron build"
task :aio_neutron do
  sh %{chef exec chef-client -z vagrant_linux.rb aio-neutron.rb}
end

desc "All-in-One Nova-networking build"
task :aio_nova do
  sh %{chef exec chef-client -z vagrant_linux.rb aio-nova.rb}
end

desc "Multi-Neutron build"
task :multi_neutron do
  sh %{chef exec chef-client -z vagrant_linux.rb multi-neutron.rb}
end

desc "Multi-Nova-networking build"
task :multi_nova do
  sh %{chef exec chef-client -z vagrant_linux.rb multi-nova.rb}
end

desc "blow everything away"
task :clean => [ :destroy_all ]
