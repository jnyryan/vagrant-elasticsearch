#!/bin/bash

####################
# Prerequisites

SRC=${APPSOURCE:-/vagrant/}

#add-apt-repository ppa:chris-lea/node.js
#apt-get install -y oracle-java7-installer # for ORACLE Java
# import the Elasticsearch public GPG key into apt
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
# Create the Elasticsearch source list
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.1/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
# Create the LogStash source list
echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list

apt-get update
apt-get install -y git curl make unzip

#####################
# Install docker
sudo apt-get install -y docker.io
sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io

#####################
# Install nginx
echo Installing nginx
apt-get install -y nginx

cp ${SRC}etc/nginx/kibana.conf /etc/nginx/sites-available/kibana.conf
ln -sf /etc/nginx/sites-available/kibana.conf /etc/nginx/sites-enabled/kibana.conf 

cp ${SRC}etc/nginx/testsite.conf /etc/nginx/sites-available/testsite.conf
ln -sf /etc/nginx/sites-available/testsite.conf /etc/nginx/sites-enabled/testsite.conf 

service nginx restart

####################
# Set up Test-Site 
echo Installing Test Web Site
mkdir -p /var/www/test-site
cp -R ${SRC}web/* /var/www/test-site/

####################
# Install java
echo Installing Java
#apt-get -y install openjdk-7-jre-headless # for OPEN Java
apt-get install -y oracle-java7-installer # for ORACLE Java
java -version

####################
# Installing logstash
echo Installing Logstash
apt-get install -y logstash=1.4.1-1-bd507eb
#mkdir -p /etc/pki
#cp /vagrant/etc/pki/* /etc/pki 
#cp ${SRC}etc/logstash/logstash.conf /opt/logstash.conf
cp ${SRC}etc/logstash/logstash.conf /etc/logstash/conf.d/logstash.conf
service logstash start

####################
# Installing Elastic Search
echo Installing Elastic Search
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
dpkg -i elasticsearch-1.2.1.deb
cd /usr/share/elasticsearch
bin/plugin -install lmenezes/elasticsearch-kopf
cd -
echo Starting ES Service
update-rc.d elasticsearch defaults 95 10
/etc/init.d/elasticsearch start

####################
# Install Kibana
echo Installing Kibana
cd ~
wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip
unzip kibana-latest.zip
mkdir -p /var/www/kibana
cp -R ~/kibana-latest/* /var/www/kibana/
cp ${SRC}etc/kibana/config.js /var/www/kibana/config.js
cd -

####################
# Install RabbitMq
#https://github.com/mikaelhg/docker-rabbitmq
#mkdir -p /tmp/rabbitmq/mnesia
#chmod 777 /tmp/rabbitmq/mnesia
docker pull jnyryan/rabbitmq
docker run -d -h rabbithost -p 5672:5672 -p 15672:15672 jnyryan/rabbitmq

####################
# Run Logstash Manually
#sudo /opt/logstash/bin/logstash -f /opt/logstash.conf
echo done

#####################
# Install redis
#apt-get install -y redis-server
#cp ${SRC}etc/redis/redis.conf /etc/redis/redis.conf
#/etc/init.d/redis-server start

####################
# https://www.digitalocean.com/community/tutorials/how-to-use-logstash-and-kibana-to-centralize-and-visualize-logs-on-ubuntu-14-04
# https://gist.github.com/shadabahmed/5486949



