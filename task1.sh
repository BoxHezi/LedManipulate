#!/bin/bash

#check if uesr using sudo or not
check_permission() {
    if [[ $EUID -ne 0  ]]
    then
        echo "You can't run this without sudo"
        exit
    fi
}

#handle user input
get_user_input() {
    echo -n "Please enter a number (1-$1) to select a option or quit: "

    read userInput

    upperLimit=$1

    if  [[ $userInput -le "0" ]]
    then
        echo "Invalid, try again!"
        return 0
    elif [[ $userInput -gt $upperLimit ]]
    then
        echo "Invalid, try again!"
        return 0
    fi

    return $userInput
}

#get amount of led devices in /sys/class/leds directory
get_led_device_count() {
    sudo ls /sys/class/leds | wc -l
}

check_permission

ledCount=$(get_led_device_count)

export ledCount

export -f get_user_input

./task2.sh
