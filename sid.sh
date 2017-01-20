#!/bin/sh
log_dir=/tmp/log
copy_history=/home/ec2-user/shell/prev_copied_files
my_input=/home/ec2-user/shell/ram
private_key=/home/ec2-user/keys/key-copy
server=ubuntu@54.227.209.37
serverpath=/home/ubuntu/sunday

export TZ="US/Central"
dname=`date +%Y\:%m:\%d-\%H%M%S`
echo `date +%Y\:%m:\%d-\%H%M%S`- Script started>>$log_dir/$dname
echo File Folder Name-$dname>>$log_dir/$dname

#comparing input directory files with previous copied files and storing uncopied files name into new_files array

declare -a prev_copied;
declare -a input_dir;
declare -a new_files;

prev_copied=($(cat $copy_history))
input_dir=($(ls -1 $my_input))
new_files=(`echo ${prev_copied[@]} ${input_dir[@]} | tr ' ' '\n' | sort | uniq -u`)
if [ "`echo $?`" == "0" ]
then
    echo Storing of uncopied file names Success!! >>$log_dir/$dname
else
    echo Storing of uncopied file names Failed!!>>$log_dir/$dname
fi

for j in ${new_files[@]}
do
    echo Files/Subdirectories to be copied:$j>>$log_dir/$dname
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

for i in ${new_files[@]}
do
sudo scp -i $private_key -r $my_input/$i $server:$serverpath/$dname
   if [ "`echo $?`" == "0" ]
   then
       echo File $i is copied into $server:$serverpath/$dname>>$log_dir/$dname
   else
       echo File $i is not copied into $server:$serverpath/$dname>>$log_dir/$dname
   fi
echo $i>>$copy_history
count=`ls -l $my_input|awk '{if($9=="'"$i"'") print $0;}'|grep ^d|wc -l`
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

echo `date +%Y:\%m:\%d\-%H%M%S`- Total files copied: $file_count1>>$log_dir/$dname
echo `date +%Y:\%m:\%d\-%H%M%S`- Total subdir copied: $subdir_count>>$log_dir/$dname

#Sending a log file as an email to recepient

echo `date +%Y:\%m:\%d\-%H%M%S`- Script Ending>>$log_dir/$dname
echo `cat $log_dir/$dname|mail -s "$dname log" siddharth16reddy@gmail.com`>>$log_dir/$dname
