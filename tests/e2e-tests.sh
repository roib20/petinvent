#! /bin/bash

# ------- PetBuddy tests ------ #
IP="http://localhost"
TESTING_PORT="5000"
#----------------------------------------------------------------
#Health check
#--------------------------------------------------------------

sleep 30s

echo "--Health check--"
connect=$(curl --silent --location --request GET "${IP}:${TESTING_PORT}"'/health' | cut -f5 -d " " )
if [ "${connect}" = "200" ]
then
    echo "Success - Health check"
    true
elif [ "${connect}" = "500" ]
then
    echo "Health check - 500 - bad connection to DB" >> /dev/stderr
    exit 1
else
    echo "Health check - Unknown error" >> /dev/stderr
    exit 2
fi

echo "Log exit 0"
exit 0