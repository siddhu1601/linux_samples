#!/bin/sh
#list of directories and file addresses
log_dir=/tmp/log
out_dir=/home/ec2-user/shell
copy_history=/home/ec2-user/shell/prev_copied_files
my_input=/home/ec2-user/shell/ram
tempfile=/home/ec2-user/shell/tempfile

cd $log_dir
dname=`date +%Y%m%d\-%H%M%S`
echo $dname

#creating output directory
echo `date +%Y%m%d%H%M%S`- script started>>$dname
cd $out_dir
mkdir $dname

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
#copying uncopied files into output directory and updating previous copied file
for i in `cat $tempfile`
do
  cp -rf $my_input/$i $out_dir/$dname
  echo $i>>$copy_history
done
#listing out the count of newly copied files and subdirectories
file_count=`ls -l $out_dir/$dname |grep ^-|wc -l`
subdir_count=`ls -l $out_dir/$dname |grep ^d|wc -l`
echo $a
cd $log_dir
echo `date +%Y%m%d\-%H%M%S`- $file_count files copied>>$dname
echo `date +%Y%m%d\-%H%M%S`- $subdir_count subdir copied>>$dname
echo `date +%Y%m%d\-%H%M%S`- script ending>>$dname

# deleting contents of tempfile and sending an email to recepient
echo $tempfile
echo -n>$tempfile
cat $log_dir/$dname|mailx siddharth16reddy@gmail.com
