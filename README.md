# Single stack with chef-metal

```shell
$ vagrant add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
$ mkdir ~/code
$ cd ~/code
$ git clone https://github.com/opscode/chef-metal.git
$ git clone https://github.com/jjasghar/singlestack.git
$ cd singlestack
$ bundle install
$ cd ../chef-metal
$ bundle && rake install
$ cd ../singlestack
$ gem install chef-metal-vagrant
$ bundle exec berks vendor cookbooks
$ chef-client -z vagrant_linux.rb aio-nova.rb
$ cd ~/.chef/vms
$ vagrant ssh
```

This will eventually fail on glance restarting (https://bugs.launchpad.net/glance/+bug/1279000), this is due to a utf8 issue which we are working on, a quick fix is:
```shell
$ mysql -u root -pilikerandompasswords glance
mysql> alter table migrate_version convert to character set utf8 collate utf8_unicode_ci;
mysql> flush privileges;
mysql> quit
```

There has been a fix pushed up https://review.openstack.org/#/c/114407/ but as of me writing this it hasn't been merged. I'm going to do my best to push it along because
this works like a champ.

Here is a openrc file that you should add to `/root/openrc` and `source /root/openrc`, you'll want to do this inside the vm, like above. (vagrant ssh)
```python
export OS_AUTH_URL="http://127.0.0.1:5000/v2.0"
export HOST_IP="127.0.0.1"
export SERVICE_HOST="$HOST_IP"
export OS_TENANT_NAME="service"
export OS_USERNAME="nova"
export OS_PASSWORD="mypass"
export GLANCE_HOST="$HOST_IP"
```

How to test the machine is set up correctly, after you source the above:
```shell
# nova service-list && nova hypervisor-list && nova image-list
```

Boot that image!
```shell
# nova boot test --image cirros --flavor 1 --poll
```

If you want to destroy everything, run this from the repo.
```shell
$ chef-client -z destroy_all.rb
```
