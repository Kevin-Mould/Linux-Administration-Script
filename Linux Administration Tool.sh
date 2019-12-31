#!/bin/bash

clear

while true ; do

echo "0. Exit script"
echo "1. Add a user to the system."
echo "2. Remove a user from the system."
echo "3. Change a user's password."
echo "4. Find a file on the system."
echo "5. List of currently logged in users."
echo "6. Display disk usage statistics."
echo "7. Show active network connections."
echo "8. Show failed login attempts."
echo "9. Perform a local directory backup using rsync."
echo "10. Perform a port scan of this computer using nmap."
echo


echo -n "Select an option between [0-10] to continue: "
read option
clear
echo

backupDirectory(){
        echo "Checking for required packages Rsync..."
	if rpm -qa | grep rsync; then
		echo "Rsync is installed."
	else
		echo "Rsync is not installed. Install it y/n?"
		read "userOption"
		if [ "$userOption" = "y" ]; then
			sudo yum -y install rsync
		else
			echo "This option requires Rsync, returning to main menu"
			return
		fi
	fi
	userName=$(logname)
	echo "What directory would you like to backup? Example: /home/$userName"
	read "source"
	echo "Where should the backup be saved? Example: /home/$userName/backup"
	read "destination"
	mkdir "$destination"
	echo "Backing up directory..."
	sudo rsync -av --delete /"$source"/ /"$destination"/
}

checkNmapPackage() {
	echo "Checking for required package Nmap..."
	if rpm -qa | grep nmap; then
		echo "Nmap is installed."
	else
		echo "Nmap is not installed. Install it y/n?"
		read "userOption"
		if [ "$userOption" = "y" ]; then
			sudo yum -y install nmap
		else
			return
		fi
	fi
	echo "I'm using your IP address to perform a port scan using nmap..."
	MYIP=$(ip -o addr show up primary scope global | while read -r num dev fam addr rest; do echo ${addr%/*}; done)
	nmap -Pn -T4 -A -p- $MYIP
}		

case $option in

    0)
	echo "Exited Script."
	exit
	;;
    1)
        echo "Type a username to add to the system."
        read userName

	: '
	if statement flow:
	if grep finds something
		do this
	else grep does not find anything
		do this
	'

	if grep -qw "$userName" /etc/passwd; then
        	echo "$userName has already been created. No action taken."
	else
		sudo useradd $userName
        	echo "$userName has been created."
	fi
        ;;
    2)
        echo "Type a username to remove it from the system."
        read userName
	
	if grep -qw "$userName" /etc/passwd; then
        	sudo userdel -r $userName
        	echo "$userName has been removed from the system."
	else
		echo "$userName does not exist, no action taken."
	fi
        ;;
    3)
        echo "To change/add a password, type the account's username."
        read userName
	
	if grep -qw "$userName" /etc/passwd; then
        	sudo passwd $userName
        	echo "Password of account $userName has been modified."
	else
		echo "$userName does not exist, can not change password."
        fi
	;;
    4)
	echo "Type the filename to search the system."
	read fileName
	sudo find / -name "$fileName" 
	;;
    5)
        echo "These users are currently logged in: "
        who | awk '{print $1}' | less
        ;;
    6)
        echo "Disk usage statistics: "
        df -h | awk '{print $4, $5, $6}' | less
        ;;
    7)
        echo "Displaying active network connections"
        netstat -atu | less
        ;;
    8)
        echo "Displaying failed login attempts"
        sudo lastb | less
        ;;
    9)
	backupDirectory
        ;;
   10)
	checkNmapPackage
	;;
    *)
        echo "Incorect value, please type a number between 1 and 10, or 'exit' to exit the script."
        ;;

esac


echo
echo "End of command, press any button to return to the menu."
read option
clear


done
