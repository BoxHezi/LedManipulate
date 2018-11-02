# usap-a2
leds configuration in raspberry pi

# one global function is used
* get\_user\_input which take 1 parameter as the upper limit that user can input and do the validation

* the background script is named "task6-background.sh"

# Instruction
* task1.sh is the startup script. All other script will be ran during the runtime
* root permission is **NEEDED**, run task1.sh with sudo

# Each Script
* task1.sh
    * startup script
    * check user permission
    * get amount of leds
    * get\_user\_input return 0 if user input is invalid
    * get\_user\_input is exported as not only one place need it
    
* task2.sh
    * print out the main menu which contains all leds
    * run task3.sh when user input is valid
    
* task3.sh
    * menu that use can associate with user selected led
    
* task4.sh
    * turn on or turn off user selected led based on user input
    
* task5.sh
    * interface that allow user to select system event to associate with selected led
    * a lot of events are able to be chosen, in order to make it act as a real paging system, all events will be written to a file first and print out to user, after user make a selection, delete the file
    
* task6.sh
    * interface that allow user to input which program to monitor to
    * conflict problem will be outputted and let user to select one of conflict program
    * user can't input 1 for memory and 2 for cpu in the memory/cpu selection page
    
* task6-background.sh
    * task6 background script
    * script will check the CPU or memory(due to user selection) usage every 5 second
    
* task7.sh
    * kill task6 background script