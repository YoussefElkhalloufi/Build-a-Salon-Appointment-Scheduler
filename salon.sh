#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?\n" 

DISPLAY_SERVICES(){

   if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi


  AVAILABLE_SERVICES=$($PSQL "select * from services")

  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo $SERVICE_ID")" $NAME 
  done
}

DISPLAY_SERVICES 

read SERVICE_ID_SELECTED 

SERVICE_AVAILABILITY=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

if [[ -z $SERVICE_AVAILABILITY ]]
then
  # Service not found
  DISPLAY_SERVICES "I could not find that service. What would you like today?"
else 
  # service found
  echo -e "\nWhat's your phone number?"

  read CUSTOMER_PHONE 

  echo -e "\nselect name from customers where phone = '$CUSTOMER_PHONE'"
  CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    # customer not found 

    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME 

    INSERT_CUSTOMER=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

    CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ /"/')

    echo -e "\nWhat time would you like your color, $CUSTOMER_NAME_FORMATTED?"
    read SERVICE_TIME
    

    CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME_FORMATTED'")

    INSERT_APPOIONTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED ;")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
  else 
    # customer found

    CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ /"/')

    echo -e "\nWhat time would you like your color, $CUSTOMER_NAME_FORMATTED?"
    read SERVICE_TIME
    

    CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME_FORMATTED'")

    INSERT_APPOIONTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  fi
fi



