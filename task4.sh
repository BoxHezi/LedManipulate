#!/bin/bash

#get user selection and apply to function
read_user_selection() {
    if [ $1 == 1 ]
    then
        turn_on_led
    elif [ $1 == 2 ]
    then
        turn_off_led
    fi

    return
}

#turn on selected led device
turn_on_led() {
    echo 1 > /sys/class/leds/$ledName/brightness
}

#turn off selected led device
turn_off_led() {
    echo 0 > /sys/class/leds/$ledName/brightness
}

read_user_selection "$1"
