#!/bin/sh
log_dir=/tmp/log
copy_history=/home/ec2-user/shell/prev_copied_files
my_input=/home/ec2-user/shell/ram
tempfile=/home/ec2-user/shell/tempfile
private_key=/home/ec2-user/keys/key-copy
server=ubuntu@54.227.209.37
serverpath=/home/ubuntu/sunday
cd $log_dir
dname=`date +%Y%m%d\-%H%M%S`
echo `date +%Y%m%d%H%M%S`- Script started>>$log_dir/$dname
echo File Folder Name-$dname>>$log_dir/$dname

#comparing input directory files with previous copied files and storing uncopied files name into tempfile

for line in `ls -1 $my_input`
 do
     echo $line>>$tempfile
 done
 echo Following file names are copied to temporary file>>$log_dir/$dname  
 echo `cat $tempfile`>>$log_dir/$dname
 
 for file in `cat $copy_history`
 do
   for f in `ls -1 $my_input`
   do
     if [ "$f" == "$file" ]
     then
         sed -i "/\b$f\b/d" $tempfile
		 echo Removed this file $f from tempfile as it is previously copied.>>$log_dir/$dname
         continue
         fi
   done
 done

sudo ssh -i $private_key $server mkdir $serverpath/$dname

if [ "`echo $?`" == "0" ]
then
echo Directory $dname is created in $server:$serverpath>>$log_dir/$dname
else
echo Directory $dname is not created in $server:$serverpath>>$log_dir/$dname
fi

#copying uncopied files into output directory and updating previous copied file
file_count1=0
subdir_count=0

for i in `cat $tempfile`
do
sudo scp -i $private_key -r $my_input/$i $server:$serverpath/$dname
   if [ "`echo $?`" == "0" ]
   then
   echo File $i is copied into $server:$serverpath/$dname>>$log_dir/$dname
   else
   echo File $i is not copied into $server:$serverpath/$dname>>$log_dir/$dname
   fi
echo $i>>$copy_history
count=`file $my_input/$i|grep directory|wc -l`
echo $count

   if [ "$count" == "0" ]
   then
   echo $i is a file>>$log_dir/$dname
       ((file_count1++))
   else
   echo $i is a subdirectory>>$log_dir/$dname
       ((subdir_count++))
   fi
done

#listing out the count of newly copied files and subdirectories

echo `date +%Y%m%d\-%H%M%S`- Total files copied: $file_count1>>$log_dir/$dname
echo `date +%Y%m%d\-%H%M%S`- Total subdir copied: $subdir_count>>$log_dir/$dname

# deleting contents of tempfile and sending an email to recepient
echo Contents of tempfile before file names deletion>>$log_dir/$dname
echo `cat $tempfile`>>$log_dir/$dname
echo -n>$tempfile
echo Contents of tempfile after file names deletion>>$log_dir/$dname
echo `cat $tempfile`>>$log_dir/$dname
echo `date +%Y%m%d\-%H%M%S`- Script Ending>>$log_dir/$dname
echo `cat $log_dir/$dname|mailx siddharth16reddy@gmail.com`>>$log_dir/$dname

