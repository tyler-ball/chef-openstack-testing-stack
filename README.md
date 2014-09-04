# Single stack with chef-metal

If you want a tl;dr here's a [youtube video](https://www.youtube.com/watch?v=GBtIRfvLzW0) of me converging this repo.

```shell
$ vagrant add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
$ mkdir ~/code
$ cd ~/code
$ git clone https://github.com/jjasghar/singlestack.git
$ cd singlestack
$ bundle install
$ bundle exec berks vendor cookbooks
```

Then you'll want to add a `validation.pem` to `.chef/`. If you don't have one you can set up a free account at
[hosted chef](https://manage.opscode.com/signup) and just jack that. Copy the `chef-validator.pem` and edit the local
`knife.rb` to fit the set up you have. :grin: This is all transient data and not important, it's just needs a `.pem`
for chef-zero to be happy.

You need four databags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*. I have a already created
the `data_bags/` directory, so you shouldn't need to make them, if you do something's broken.

After the data_bags are created you'll want to open up the `aio-nova.rb` or `aio-neutron.rb` to have it point to your
 `encrypted_data_bag_secret` like how I did here: `/Users/jasghar/repo/singlestack/.chef/encrypted_data_bag_secret`

Now you should be good to start up `chef-client`!

```bash
$ chef-client -z vagrant_linux.rb aio-nova.rb OR chef-client -z vagrant_linux aio-neutron.rb
```

This will eventually fail on glance restarting (https://bugs.launchpad.net/glance/+bug/1279000), this is due to a UTF8
issue which we are working on, a quick fix is:

```bash
$ cd ~/.chef/vms
$ vagrant ssh mario
$ mysql -u root -pilikerandompasswords glance
mysql> alter table migrate_version convert to character set utf8 collate utf8_unicode_ci;
mysql> flush privileges;
mysql> quit
```

There has been a fix pushed up https://review.openstack.org/#/c/114407/ but as of me writing this it hasn't been merged.
I'm going to do my best to push it along because this works like a champ.

NOTE: If you want to fix this so it works out of the get-go you can also edit
`singlestack/cookbooks/openstack-common/libraries/database.rb` at line 94 and add `encoding 'utf8'`. I only suggest
doing this if you know what you're doing.

Here is a openrc file that you should add to `/root/openrc` and `source /root/openrc`, you'll want to do this
inside the vm, like above.

```bash
$ cd ~/.chef/vms
$ vagrant ssh mario
```

Here's a template:

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

TODO: create automated serverspec or something around this

```bash
# nova service-list && nova hypervisor-list && nova image-list 
```

Boot that image! (as root)

```bash
# nova boot test --image cirros --flavor 1 --poll
```

If you would like to use the dashboard you should go to https://localhost:9443 and the username password is `admin/mypass`.


If you want to destroy everything, run this from the `single-stack/` repo.

```bash
$ chef-client -z destroy_all.rb
```
