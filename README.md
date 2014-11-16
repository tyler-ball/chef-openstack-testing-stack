# Openstack-cluster with chef-provisioning

If you want a tl;dr a [youtube video](https://www.youtube.com/watch?v=GBtIRfvLzW0) of me converging this repo, for a nova all
in one node.

```shell
$ vagrant add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
$ mkdir ~/code
$ cd ~/code
$ git clone https://github.com/jjasghar/chef-openstack-testing-stack.git shortstack
$ cd shortstack
$ bundle install
$ bundle exec berks vendor cookbooks
$ ruby -e "require 'openssl'; puts OpenSSL::PKey::RSA.new(2048).to_pem" > .chef/validator.pem
$ export CHEF_DRIVER=vagrant
```

You need four databags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*. I have a already created
the `data_bags/` directory, so you shouldn't need to make them, if you do something's broken.

After the data_bags are created you'll want to open up the `aio-nova.rb`, `aio-neutron.rb`, or `multi-nova.rb` to have it point to your
`encrypted_data_bag_secret` like how I did here: `/Users/jasghar/repo/shortstack/.chef/encrypted_data_bag_secret`.

You may also need to change the networking options around the `aio-nova.rb`, `aio-neutron.rb`, or `multi-nova.rb` files. I wrote this on
my MacBook Pro with an `en0` you're mileage may vary.

Now you should be good to start up `chef-client`!

```bash
$ bundle exec chef-client -z vagrant_linux.rb aio-nova.rb
```
OR
```bash
$ bundle exec chef-client -z vagrant_linux.rb aio-neutron.rb
```
OR if you want a multi-node nova cluster:
```bash
$ bundle exec chef-client -z vagrant_linux.rb multi-nova.rb
```

If you spin up the `multi-nova` build, you'll have three machines `controller`,`compute1`,`compute2`, and `compute3`. They all live on the
`192.168.100.x` network so keep that in mind. If you'd like to take this and change it around, whatever you decide your controller
node to be change anything that has the `192.168.100.60` address to that.

```bash
$ cd ~/.chef/vms
$ vagrant ssh controller
$ sudo su -
# source openrc
```

How to test the machine is set up correctly, after you source the above: (as root)

```bash
# nova service-list && nova hypervisor-list && nova image-list
```

Boot that image! (as root)

```bash
# nova boot test --image cirros --flavor 1
```

If you would like to use the dashboard you should go to https://localhost:9443 and the username password is `admin/mypass`.

If you want to destroy everything, run this from the `shortstack/` repo.

```bash
$ chef-client -z destroy_all.rb
```
