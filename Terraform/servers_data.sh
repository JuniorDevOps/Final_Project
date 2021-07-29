#!/bin/bash -v
sudo apt-get update -y
sudo apt-get install docker.io -y > /tmp/docker.log
sudo usermod -aG docker ubuntu >> /tmp/docker.log
newgrp docker
sudo systemctl start docker
sudo systemctl enable --now docker
sudo chown ubuntu:docker /var/run/docker.sock

sudo apt-get install -y ansible > /tmp/ansible.log


