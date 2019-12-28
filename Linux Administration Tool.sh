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
echo "9. Display the system hostname."
echo "10. Perform a port scan of this computer using nmap."
echo


echo -n "Select an option between [0-10] to continue: "
read OPTION
clear
echo

checkNmapPackage() {
	echo "Checking for required package Nmap..."
	if rpm -qa | grep {nmap}; then
		echo "Nmap is installed."
	else
		echo "Nmap is not installed. Install it y/n?"
		read "TEST"
		if [ "$TEST" = "y" ]; then
			sudo yum install nmap
		else
			return
		fi
	fi
	echo "I'm using your IP address to perform a port scan using nmap..."
	MYIP=$(ip -o addr show up primary scope global | while read -r num dev fam addr rest; do echo ${addr%/*}; done)
	nmap -Pn -T4 -A -p- $MYIP
}		

case $OPTION in

    0)
	echo "Exited Script."
	exit
	;;
    1)
        echo "Type a username to add to the system."
        read USERNAME

	: '
	grep statement evulates to boolean True if the inputed USERNAME does not exist.
	grep statement evulates to boolean False if the inputed USERNAME exists.
	'

	if grep -qw "$USERNAME" /etc/passwd; then
        	echo "$USERNAME has already been created. No action taken."
	else
		sudo useradd $USERNAME
        	echo "$USERNAME has been created."
	fi
        ;;
    2)
        echo "Type a username to remove it from the system."
        read USERNAME
	
	if grep -qw "$USERNAME" /etc/passwd; then
        	sudo userdel -r $USERNAME
        	echo "$USERNAME has been removed from the system."
	else
		echo "$USERNAME does not exist, no action taken."
	fi
        ;;
    3)
        echo "To change/add a password, type the account's username."
        read USERNAME
	
	if grep -qw "$USERNAME" /etc/passwd; then
        	sudo passwd $USERNAME
        	echo "Password of account $USERNAME has been modified."
	else
		echo "$USERNAME does not exist, can not change password."
        fi
	;;
    4)
	echo "Type the filename to search the system."
	read FILENAME
	sudo find / -name "$FILENAME" 
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
        echo "The system hostname is: "
        hostname
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
read OPTION
clear


done
