#!/bin/bash

# This script copies the block log from squidguard to another computer and then sees if their were any blocked websites found for the current day. 
# Then it sends an email with all the websites that were blocked plus their IP address and date/time. 

# Input the username and IP for your squidguard server and the email that you want the information to go to.

username=""
server=""
email=""

cd /home/testubuntu																	# change to home directory. Needed if going to run script through cron
date +"%T" > squidguardemail-start.txt												# send start time to squidguardemail-start.txt
rm blockedtoday.txt																	# remove old blockedtoday.txt
scp -r -P 1256 $username@$server:/var/squidGuard/log/block.log /home/testubuntu/	# copy block.log from remote server on port 1256 to local computer
DATE=`date +%Y-%m-%d`																# save current date in Year-Month-Day format to variable DATE
grep -i "$DATE.*blk_" block.log >> blockedtoday.txt									# take lines with the current date and have "blk" in them and put in blockedtoday.txt
if [ ! -s /home/testubuntu/blockedtoday.txt ]; then									# if no file called blockedtoday.txt was created then exit script
	echo "file is empty"
	exit 1
fi
mail -s "Blocked Websites Today" $email < blockedtoday.txt							# email the result to your email with "Blocked Websites Today" as the subject
date +"%T" > squidguardemail-end.txt												# send end time to squidguardemail-end.txt
