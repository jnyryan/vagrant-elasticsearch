vagrant-elasticsearch
=================




``` bash

vagrant box add base http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box
vagrant init
vagrant up

#locate ssh
vagrant ssh-config | grep IdentityFile  | awk '{print $2}'
ssh -i /some/dir/.vagrant.d/insecure_private_key -l vagrant -p 22 192.168.*.*
ssh -i /Users/j/.vagrant.d/insecure_private_key -p 22 vagrant@192.168.192.36

```



