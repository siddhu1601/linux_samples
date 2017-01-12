#!/bin/sh

cd /tmp/log
r1=`date +%Y%m%d\-%H%M%S`
echo $r1 

echo `date +%Y%m%d%H%M%S`- script started>>$r1
cd /home/ec2-user/shell
r=`date +%Y%m%d\-%H%M`
mkdir $r
#echo `date +%Y%m%d\-%H%M%S`- new $r created>>/tmp/log/$r1
cp -rf ram/* $r
cd /tmp/log
echo `date +%Y%m%d\-%H%M%S`- 4 files copied>>$r1

echo `date +%Y%m%d\-%H%M%S`- script ending>>$r1
 
