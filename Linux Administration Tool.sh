#!/bin/bash

clear

while true ; do

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


echo -n "Select an option between 1-10 to continue, or 'exit' to exit the script: "
read OPTION
clear
echo


case $OPTION in

    1)
        echo "Type the user's username to add them to the system."
        read USERNAME
        sudo useradd $USERNAME
        echo "User has been created."
        ;;
    2)
        echo "Type the user's username to remove them from the system."
        read USERNAME
        sudo userdel -r $USERNAME
        echo "User has been removed from the system."
        ;;
    3)
        echo "Changing password. Please specify the user's account"
        read USERNAME
        sudo passwd $USERNAME
        echo "password changed."
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
    exit | EXIT)
        echo "Exited Script."
        exit
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
