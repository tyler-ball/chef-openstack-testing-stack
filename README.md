# Single stack with chef-metal

If you want a tl;dr here's a [youtube video](https://www.youtube.com/watch?v=GBtIRfvLzW0) of me converging this repo.

```shell
$ vagrant add centos65 http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
$ mkdir ~/code
$ cd ~/code
$ git clone https://github.com/jjasghar/chef-openstack-testing-stack.git shortstack
$ cd shortstack
$ bundle install
$ bundle exec berks vendor cookbooks
$ ruby -e "require 'openssl'; puts OpenSSL::PKey::RSA.new(2048).to_pem" > .chef/validation.pem
```

You need four databags : *user_passwords*, *db_passwords*, *service_passwords*, *secrets*. I have a already created
the `data_bags/` directory, so you shouldn't need to make them, if you do something's broken.

After the data_bags are created you'll want to open up the `aio-nova.rb` or `aio-neutron.rb` to have it point to your
 `encrypted_data_bag_secret` like how I did here: `/Users/jasghar/repo/singlestack/.chef/encrypted_data_bag_secret`

Now you should be good to start up `chef-client`!

```bash
$ chef-client -z vagrant_linux.rb aio-nova.rb
```
OR
```bash
$ chef-client -z vagrant_linux aio-neutron.rb
```

There is a possibility on a failure of glance restarting (https://bugs.launchpad.net/glance/+bug/1279000) during the
initial converge, this is due to a UTF8 issue, a quick fix is:

```bash
$ cd ~/.chef/vms
$ vagrant ssh mario
$ mysql -u root -pilikerandompasswords glance
mysql> alter table migrate_version convert to character set utf8 collate utf8_unicode_ci;
mysql> flush privileges;
mysql> quit
```

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
nova service-list && nova hypervisor-list && nova image-list
```

Boot that image! (as root)

```bash
nova boot test --image cirros --flavor 1 --poll
```

If you would like to use the dashboard you should go to https://localhost:9443 and the username password is `admin/mypass`.


If you want to destroy everything, run this from the `single-stack/` repo.

```bash
$ chef-client -z destroy_all.rb
```
