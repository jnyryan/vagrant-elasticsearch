#!/bin/bash

####################
# Prerequisites

cd ~
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


####################
# Install java
apt-get -y install openjdk-7-jre-headless # for OPEN Java
# apt-get install -y oracle-java7-installer # for ORACLE Java
java -version

#####################
# nstall nginx
apt-get install -y nginx
cp /vagrant/etc/nginx/nginx.conf /etc/nginx/sites-available/default
service nginx restart

####################
# Installing Elastic Search
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
dpkg -i elasticsearch-1.2.1.deb
#cd /usr/share/elasticsearch
#bin/plugin -install lmenezes/elasticsearch-kopf
#cd -

echo Starting ES Service
update-rc.d elasticsearch defaults 95 10
/etc/init.d/elasticsearch start

####################
# Install Kibana
Download Kibana to your home directory with the following command:

cd ~
wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip
unzip kibana-latest.zip
Open the Kibana configuration file for editing:

	#sudo vi ~/kibana-latest/config.js
	#In the Kibana configuration file, find the line that specifies the elasticsearch, and replace the port number (9200 by default) with 80:

   		#elasticsearch: "http://"+window.location.hostname+":80",
	#This is necessary because we are planning on accessing Kibana on port 80 (i.e. http://logstashserverpublic_ip/).

	#We will be using Nginx to serve our Kibana installation, so let's move the files into an appropriate location.

mkdir -p /var/www/kibana
cp -R ~/kibana-latest/* /var/www/kibana/
cp /vagrant/etc/kibana/config.js /var/www/kibana/config.js 


####################
# Installing logstash
apt-get install logstash=1.4.1-1-bd507eb
cp /vagrant/etc/logstash/10-syslog.conf /etc/logstash/conf.d/10-syslog.conf
service logstash restart

####################
# Testing 
sleep 5
curl http://localhost:9200

echo done

####################
# https://www.digitalocean.com/community/tutorials/how-to-use-logstash-and-kibana-to-centralize-and-visualize-logs-on-ubuntu-14-04
