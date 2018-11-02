#!/bin/bash

#get all name of led devices in the leds directory
get_led_device_list() {
    sudo ls /sys/class/leds
}

#print menu for script program
print_menu() {

    #declare an array variable
    declare -a ledList=( `get_led_device_list` )

    while true;
    do

        echo -e "\nWelcome to LED_Konfigurator!"
        echo "============================"

        #variable to indicate the index position of ledList
        index=0

        #for loop to iterate through array to generate menu
        for i in ${ledList[@]}
        do
            outputMsg=$((index+1)).\ $i
            echo $outputMsg

            index=$((index+1))
        done

        #add quit option when all led devices are read
        outputMsg=$((ledCount+1)).\ Quit
        echo $outputMsg

        get_user_input "$((ledCount+1))"

        inputResult=$?
        while [ $inputResult == 0 ];
        do
            print_menu
            break
        done

        if [[ $inputResult == $((ledCount+1)) ]]
        then
            #kill background script before quiting program
            ./task7.sh
            echo -e "Exiting...\n"
            break
        else
            ledIndex=$((inputResult-1))
            ledName=${ledList[$ledIndex]}
            export ledName
            ./task3.sh
        fi
    done
}

print_menu

