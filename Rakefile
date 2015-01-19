#task default: ["test"]


task :destroy_all do
  sh %{bundle exec chef-client -z destroy_all.rb}
end

desc "All-in-One Neutron build"
task :aio_neutron do
  sh %{time bundle exec chef-client -z vagrant_linux.rb aio-neutron.rb}
end

desc "All-in-One Nova-networking build"
task :aio_nova do
  sh %{time bundle exec chef-client -z vagrant_linux.rb aio-nova.rb}
end

desc "Multi-Neutron build"
task :multi_neutron do
  sh %{time bundle exec chef-client -z vagrant_linux.rb multi-neutron.rb}
end

desc "Multi-Nova-networking build"
task :multi_nova do
  sh %{time bundle exec chef-client -z vagrant_linux.rb multi-nova.rb}
end

desc "blow everything away"
task :clean => [ :destroy_all ]
