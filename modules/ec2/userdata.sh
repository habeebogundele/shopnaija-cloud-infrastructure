#!/bin/bash

yum update -y

yum install httpd -y

systemctl enable httpd

systemctl start httpd

INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

echo "<h1>ShopNaija Infrastructure</h1>" > /var/www/html/index.html

echo "<h2>$INSTANCE_ID</h2>" >> /var/www/html/index.html

