#vagrant-elasticsearch
=================

An all in one Virtual Machine set-up for loggging using ElasticSearch, Logstash and Kibana with a Test Web Site running under nGinx.

## get up and running

1. Install VagrantUp

instructions at http://www.vagrantup.com/

2. Clone the Repository

Download this repository to you local machine

3. Run VagrantUp
	
CD to the code you dopwnloaded and run

	vagrant up

This will download the Virtual Machine image, and run the install.sh to get all the components installed
Give the it a few minutes to spin up.

4. Play with the components

	[http://localhost:58080](http://localhost:58080)

Cleanup

``` bash
sudo bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)
exit
```

# References
https://library.linode.com/databases/redis/ubuntu-12.04-precise-pangolin
https://medium.com/devops-programming/shipping-nginx-access-logs-to-logstash-b01bd0876e82
