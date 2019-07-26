#!/bin/bash

PRINTERS=$(lpstat -p | awk '{print $2}' ) # get list of printers
echo -e "\e[96m**********************************************************\e[39m"
echo -e "\e[96m$(date)\e[39m" # show current date and time
IS_PRINTER_DISABLED="FALSE"
for PRINTER in ${PRINTERS[@]}; do

    PRINTER_STATUS=$(lpstat -p ${PRINTER}| awk '{print $3}'); # get printer status
    if [ "$PRINTER_STATUS" == "disabled" ]; then # check if printer disabled
      IS_PRINTER_DISABLED="TRUE"
      echo -e "$PRINTER \e[91m$PRINTER_STATUS.\e[39m"  # print printer name and status

      echo -ne "\e[94mEnabling printer\e[39m $PRINTER\e[39m..."
      cupsenable $PRINTER && echo -e "\e[92m[SUCCESS]"
    fi
done

# Restarting CUPS Sheduler
if [ "$IS_PRINTER_DISABLED" == "TRUE" ]; then
  echo -ne "\e[94mRestarting CUPS Sheduler\e[39m...\e[91m"
  service cups restart && echo -e "\e[92m[SUCCESS]\e[39m"
fi

# add two new line for more readable log
echo -e "\e[96m**********************************************************\e[39m"
echo " "
