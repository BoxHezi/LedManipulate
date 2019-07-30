#!/usr/bin/bash

#print option for each led device
print_option() {
    while true;
    do
        echo -e "\n[$ledName]"
        echo "========================="

        echo "What would you like to do with this led?"
        echo "1) turn on"
        echo "2) turn off"
        echo "3) associate with a system event"
        echo "4) associate with the performance of a process"
        echo "5) stop association with a process' performance"
        echo "6) quit to main menu"

        get_user_input "6"

        inputResult=$?
        if [[ $inputResult == 6 ]]
        then
            break
        else
            handle_user_input $inputResult
        fi
    done
}

#handle user input and go to different script due to user input
#accept one argument as user input
handle_user_input() {
    if [[ $1 == 1 || $1 == 2 ]]
    then
        ./task4.sh $1
    elif [[ $1 == 3 ]]
    then
        ./task5.sh
    elif [[ $1 == 4 ]]
    then
        ./task6.sh
    elif [[ $1 == 5 ]]
    then
        ./task7.sh
    fi
}

print_option

