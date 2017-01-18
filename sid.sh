#!/bin/sh
#list of directories and file addresses
log_dir=/tmp/log
#out_dir=/home/ec2-user/shell
copy_history=/home/ec2-user/shell/prev_copied_files
my_input=/home/ec2-user/shell/ram
tempfile=/home/ec2-user/shell/tempfile
private_key=/home/ec2-user/keys/key-copy
cd $log_dir
dname=`date +%Y%m%d\-%H%M%S`
echo $dname


cd /tmp/log
r1=`date +%Y%m%d\-%H%M%S`
echo $r1 

echo `date +%Y%m%d%H%M%S`- script started>>$r1
cd /home/ec2-user/shell
r=`date +%Y%m%d\-%H%M`
mkdir $r
#echo `date +%Y%m%d\-%H%M%S`- new $r created>>/tmp/log/$r1

 
cp -rf ram/* $r
a=`ls -l ram|grep ^-|wc -l`
echo $a
cd /tmp/log
echo `date +%Y%m%d\-%H%M%S`- $a files copied>>$r1

echo `date +%Y%m%d\-%H%M%S`- script ending>>$r1
cat /tmp/log/$r1|mailx siddharth16reddy@gmail.com, rahul.varakala@gmail.com 

#creating output directory
echo `date +%Y%m%d%H%M%S`- script started>>$dname
#cd $out_dir
#mkdir $dname

#comparing input directory files with previous copied files and storing uncopied files name into tempfile

for line in `ls -1 $my_input`
 do
     echo $line>>$tempfile
 done
 echo $tempfile
 echo $my_input
 cat $tempfile
 for file in `cat $copy_history`
 do
   for f in `ls -1 $my_input`
   do
     if [ "$f" == "$file" ]
     then
         sed -i "/\b$f\b/d" $tempfile
         continue
         fi
   done
 done

sudo ssh -i $private_key ubuntu@54.227.209.37 mkdir /home/ubuntu/sunday/$dname

#sudo scp -i $private_key -r $my_input/$i ubuntu@54.227.209.37:/home/ubuntu/sunday/$dname/

#copying uncopied files into output directory and updating previous copied file
file_count1=0
subdir_count=0

for i in `cat $tempfile`
do
sudo scp -i $private_key -r $my_input/$i ubuntu@54.227.209.37:/home/ubuntu/sunday/$dname
ec=`echo $?`
if [ "$ec" == "0" ]
then
echo executed
else
echo not executed
fi

 # cp -rf $my_input/$i $out_dir/$dname
  echo $i>>$copy_history

count=`file $my_input/$i|grep directory|wc -l`
echo $count

  if [ "$count" == "0" ]
  then
       ((file_count1++))
  else
       ((subdir_count++))
  fi
done
#echo $file_count1
#echo $subdir_count
#cat1 =`cat $tempfile`
#echo $cat1
#input =`echo $cat`
#cat $input
#sudo scp -i $private_key $my_input/$input ubuntu@54.82.61.119:/home/ubuntu/sunday/$dname

#listing out the count of newly copied files and subdirectories
#file_count=`ls -l $out_dir/$dname |grep ^-|wc -l`
#subdir_count=`ls -l $out_dir/$dname |grep ^d|wc -l`
#echo $a
cd $log_dir
echo `date +%Y%m%d\-%H%M%S`- $file_count1 files copied>>$dname
echo `date +%Y%m%d\-%H%M%S`- $subdir_count subdir copied>>$dname
echo `date +%Y%m%d\-%H%M%S`- script ending>>$dname

# deleting contents of tempfile and sending an email to recepient
cat $tempfile
echo -n>$tempfile
cat $log_dir/$dname|mailx siddharth16reddy@gmail.com
