#!/bin/bash

source_file=/home/ubuntu/sid.sh
dest_file=/home/ec2-user

sudo scp -i key_copy $source_file ec2-user@54.88.249.94:$dest_file