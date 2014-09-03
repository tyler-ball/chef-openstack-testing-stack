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
```

You'll need to create some Databags to make this work:

You need to have some databags when you run the stackforge without the `developer_mode: true`.

You need four databags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*.

Each data bag need the following item to be created.

### user_passwords 
ITEM example :
```js
{"id" : "admin", "admin" : "mypass"}
```

 - admin
 - guest

```bash
# make sure you're in your singlestack/ directory
$ for item in admin guest ; do
>  knife data bag create user_passwords $item --secret-file .chef/openstack_data_bag_secret;
> done
```

### db_passwords
ITEM example :
```js
{"id" : "nova", "nova" : "mypass"}
```

 - nova
 - horizon
 - keystone
 - glance
 - ceilometer
 - neutron
 - cinder
 - heat
 - dash

```bash
# make sure you're in your singlestack/ directory
$ for item in nova horizon keystone glance ceilmeter neutron cinder heat dash ; do
>  knife data bag create db_passwords $item --secret-file .chef/openstack_data_bag_secret;
> done
```

### service_passwords
ITEM example :
```js
{"id" : "openstack-image", "openstack-image" : "mypass"}
```

 - openstack-image
 - openstack-compute
 - openstack-block-storage
 - openstack-orchestration
 - openstack-network
 - rbd

```bash
# make sure you're in your singlestack/ directory
$ for item in openstack-image openstack-compute openstack-block-storage openstack-orchestration openstack-network rbd ; do
>  knife data bag create service_passwords $item --secret-file .chef/openstack_data_bag_secret;
> done
```

### secrets
ITEM example :
```js
{"id" : "openstack_identity_bootstrap_token", "openstack_identity_bootstrap_token" : "mytoken"}
```

 - openstack_identity_bootstrap_token
 - neutron_metadata_secret

```bash
# make sure you're in your singlestack/ directory
$ for item in openstack_identity_bootstrap_token neutron_metadata_secret ; do
>  knife data bag create secrets $p --secret-file ~/.chef/openstack_data_bag_secret;
> done
```

## Kick off chef-client

Now you should be good to start up `chef-client`!

```bash
$ chef-client -z vagrant_linux.rb aio-nova.rb
$ cd ~/.chef/vms
$ vagrant ssh
```

This will eventually fail on glance restarting (https://bugs.launchpad.net/glance/+bug/1279000), this is due to a utf8 issue which we are working on, a quick fix is:
```bash
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

How to test the machine is set up correctly, after you source the above: (as root)
```bash
# nova service-list && nova hypervisor-list && nova image-list
```

Boot that image! (as root)
```bash
# nova boot test --image cirros --flavor 1 --poll
```

If you want to destroy everything, run this from the `singlestack/` repo.
```bash
$ chef-client -z destroy_all.rb
```
