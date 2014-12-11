#task default: ["test"]


task :destroy_all do
  sh %{bundle exec chef-client -z destroy_all.rb}
end

desc "Centos 65 All-in-One Neutron build"
task :centos65_aio_neutron do
  sh %{time bundle exec chef-client -z vagrant_linux.rb aio-neutron.rb}
end

desc "Centos 65 All-in-One Nova-networking build"
task :centos65_aio_nova do
  sh %{time bundle exec chef-client -z vagrant_linux.rb aio-nova.rb}
end

desc "Centos 65 Multi-Neutron build"
task :centos65_multi_neutron do
  sh %{time bundle exec chef-client -z vagrant_linux.rb multi-neutron.rb}
end

desc "Centos 65 Multi-Nova-networking build"
task :centos65_multi_nova do
  sh %{time bundle exec chef-client -z vagrant_linux.rb multi-nova.rb}
end

desc "blow everything away"
task :clean => [ :destroy_all ]
