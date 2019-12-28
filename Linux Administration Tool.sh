#!/bin/bash

clear

while true ; do

echo "0. Exit script"
echo "1. Add a user to the system. (Sudo required)"
echo "2. Remove a user from the system. (Sudo required)"
echo "3. Change a user's password.(Sudo required)"
echo "4. List of currently logged in users."
echo "5. Display disk usage statistics."
echo "6. Show active network connections."
echo "7. Show failed login attempts. (Sudo required)"
echo "8. Display the current date and time."
echo "9. Display the system hostname."
echo "10. Print the current working directory."
echo


echo -n "Select an option between [0-10] to continue: "
read OPTION
clear
echo


case $OPTION in

    0)
	echo "Exited Script."
	exit
	;;
    1)
        echo "Type a username to add to the system."
        read USERNAME

	: '
	grep statement evulates to boolean True if the inputed USERNAME does not 	exist.
	grep statement evulates to boolean False if the inputed USERNAME exists.
	'

	if grep -qw "$USERNAME" /etc/passwd; then
        	echo "$USERNAME has already been created. No action taken."
	else
		sudo useradd $USERNAME
        	echo "User has been created."
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
        echo "These users are currently logged in: "
        who | awk '{print $1}' | less
        ;;
    5)
        echo "Disk usage statistics: "
        df -h | awk '{print $4, $5, $6}' | less
        ;;
    6)
        echo "Displaying active network connections"
        netstat -atu | less
        ;;
    7)
        echo "Displaying failed login attempts"
        sudo lastb | less
        ;;
    8)
        echo "The current date and time is: "
        date
        ;;
    9)
        echo "The system hostname is: "
        hostname
        ;;
    10)
        echo "The current working directory is: "
        pwd
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
