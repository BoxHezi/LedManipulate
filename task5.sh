#!/bin/bash

#get available event
get_led_system_event() {
    cat /sys/class/leds/$ledName/trigger
}

#print out event menu
print_event_menu() {
    #create a file to store all available events
    declare -r eventFile="availableEvent.txt"

    declare -a eventList=( $(get_led_system_event) )

    while true
    do
        echo -e "\nAssociate Led [$ledName] with a system Event" >> $eventFile
        echo ================================== >> $eventFile

        eventCount=${#eventList[@]}

        startNum=0;

        for i in ${eventList[@]}
        do

            if [[ $i = *"["* ]]
            then
                #remove "[]" and add a "*" to the end of associated event
                eventLength=${#i}
                staredEvent=${i:1:$((eventLength-2))}
                outputMsg=$((startNum+1)).\ $staredEvent"*"
                echo $outputMsg >> $eventFile
            else
                outputMsg=$((startNum+1)).\ $i
                echo $outputMsg >> $eventFile
            fi

            startNum=$((startNum+1))
        done

        outputMsg=$((eventCount+1)).\ "Quit to previous menu"
        echo $outputMsg >> $eventFile

        #use less to make options in different pages
        cat $eventFile | less

        #output the file again as text will not stay after quit from less
        cat $eventFile
        echo -n "Please select an option: (1-$((eventCount+1))): "

        #remove all events in case user select other devices
        rm -f $eventFile

        get_user_input $((eventCount+1))

        inputResult=$?

        if [[ $inputResult == $((eventCount+1)) ]]
        then
            break
        fi

        if [[ $inputResult < $((eventCount+1)) ]]
        then
            eventIndex=$((inputResult-1))
            eventName=${eventList[$eventIndex]}

            change_trigger_event $ledName $eventName
            break
        fi
    done
}

#change the event is currently handled by the LED selected
change_trigger_event() {
    sudo echo $2 > /sys/class/leds/$1/trigger
    echo "Successfully associate [$1] with [$2]"
}

print_event_menu
