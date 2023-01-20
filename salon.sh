#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


echo -e "\n\n~~ BarBar Adam Salutes  ~~\n"

MAIN_MENU(){
  if [[ ! -z $1 ]]
  then
    echo -e "\n$1"
  fi
  GET_OPTIONS=$($PSQL "select * from services" )

  echo "$GET_OPTIONS" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done


  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then 

      MAIN_MENU "Please enter a number :)"

  else

  SELECTED_SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED" )
    if [[ -z $SELECTED_SERVICE_NAME ]]
      then 

        MAIN_MENU "I could not find that service. What would you like today?"

        else

        echo -e "\nWhat's your phone number?"
        
        read CUSTOMER_PHONE
        CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'" )
      
      if [[ -z $CUSTOMER_NAME ]]
        then
        #Create Costumer
        echo -e "\nI don't have a record for that phone number, what's your name?"

        read CUSTOMER_NAME
        CREATE_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name , phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE') " )
        
      else
        echo -e "\nhg $CUSTOMER_NAME buyur"
      fi
      echo -e "\nWhen is it ok? (FORMAT HH:MM)"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" )
      MAKE_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments( customer_id, service_id, time ) VALUES( $CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME' )" )
      
      echo -e "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi
  fi
# =$($PSQL "" )
}


MAIN_MENU "How can Barbar Adam help you?"