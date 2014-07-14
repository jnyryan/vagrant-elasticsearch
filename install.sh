#!/bin/bash

####################
# Prerequisites

add-apt-repository ppa:chris-lea/node.js
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
# Install redis
apt-get install -y redis-server
cp /vagrant/etc/redis/redis.conf /etc/redis/redis.conf
/etc/init.d/redis-server start

#####################
# Install nginx
echo Installing nginx
apt-get install -y nginx
cp /vagrant/etc/nginx/nginx.conf /etc/nginx/sites-available/default
service nginx restart

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
mkdir -p /etc/pki
cp /vagrant/etc/pki/* /etc/pki 
cp /vagrant/etc/logstash/logstash.conf /opt/logstash.conf

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
cp /vagrant/etc/kibana/config.js /var/www/kibana/config.js
cd -

####################
# Set up Test-Site 
echo Installing Test Web Site
mkdir -p /var/www/test-site
cp -R /vagrant/web/* /var/www/test-site/

####################
# Run Logstash
#sudo /opt/logstash/bin/logstash -f /opt/logstash.conf
echo done

####################
# https://www.digitalocean.com/community/tutorials/how-to-use-logstash-and-kibana-to-centralize-and-visualize-logs-on-ubuntu-14-04
# https://gist.github.com/shadabahmed/5486949



