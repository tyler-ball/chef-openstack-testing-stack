

vagrant add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
vagrant add precice64


cd ~/repo/chef-metal && bundle && rake install && cd ~/vagrant/singlestack
gem install chef-metal-vagrant
bundle exec berks vendor cookbooks
cd ~/repo/chef-metal && bundle && rake install # need to rebuild it due to the forwarding error must be bulit from master

chef-client -z destroy_all.rb
chef-client -z vagrant_linux.rb test.rb


bundle exec berks vendor cookbooks
