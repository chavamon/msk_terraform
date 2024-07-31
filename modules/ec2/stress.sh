#!/bin/bash

# Install stress utility.
sudo amazon-linux-extras install epel -y
sudo yum install stress -y

# how to use stress
# stress --cpu 1 --timeout 60s
# stress --cpu 2 --timeout 60s
# stress --cpu 4 --timeout 60s
# stress --cpu 8 --timeout 60s
# stress --cpu 16 --timeout 60s
