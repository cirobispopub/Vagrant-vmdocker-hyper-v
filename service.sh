#!/bin/bash

sudo docker service create --name app-apache --replicas 10 -d -p 80:80 httpd

