#!/bin/sh
cd /tmp/log
r1=`date +%Y%m%d\-%H%M%S`
echo $r1

echo `date +%Y%m%d%H%M%S`- script started>>$r1
cd /home/ec2-user/shell
r=`date +%Y%m%d\-%H%M`
mkdir $r
#echo `date +%Y%m%d\-%H%M%S`- new $r created>>/tmp/log/$r1

cp -rf /home/ec2-user/shell/ram/* /home/ec2-user/shell/ram2
for file in `ls /home/ec2-user/shell/ram1`
do
for f in `ls /home/ec2-user/shell/ram`
do
if [ "$f" == "$file" ]
then
rm -f /home/ec2-user/shell/ram2/$file
continue
fi
done
done



cp -rf /home/ec2-user/shell/ram2/* $r
a=`ls -l ram2|grep ^-|wc -l`
echo $a
cd /tmp/log
echo `date +%Y%m%d\-%H%M%S`- $a files copied>>$r1

echo `date +%Y%m%d\-%H%M%S`- script ending>>$r1
echo `ls /home/ec2-user/shell/ram2`
cp -rf /home/ec2-user/shell/ram2/* /home/ec2-user/shell/ram1
rm -rf /home/ec2-user/shell/ram2/*
cat /tmp/log/$r1|mailx siddharth16reddy@gmail.com, rahul.varakala@gmail.com 
