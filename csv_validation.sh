#!/bin/bash
file=/home/ec2-user/ard.csv
grep -v '#' $file| sed 1d|awk -F"," '{if(NF>5||NF<5) print NR,$0}'
