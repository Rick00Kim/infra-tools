###################################################################
# GET Port                                                        #
###################################################################
get_port() {
  local input_val
  # Input port
  read -p "Set $1 port[default: $2] -> " input_val
  if [ -z $input_val ] || [ $input_val == "" ]; then
    echo "It will set default port $2" > /dev/tty
    input_val=$2
  fi
  # Check used port
  used="$(lsof -i -P -n | grep LISTEN | grep $input_val | wc -l)"
  echo "used" $used > /dev/tty
  if [ $used == 0 ]; then
    echo $input_val
  else
    echo "$input_val is used." > /dev/tty
    exit 1
  fi
  
}

###################################################################
# GET REQUIRE DATA                                                #
###################################################################
get_require_data() {
  local input_val
  # Request input to user max 2 times
  for (( c=1; c<3; c++ ))
  do
    # Control Second argument(No show flag)
    if [ $2 == "true" ];then
      read -sp "Please write $1 -> " input_val
      echo > /dev/tty
    else
      read -p "Please write $1 -> " input_val
    fi

    # When get input, break loop
    if [ ! -z $input_val ]; then
      break
    fi

    # When not exists input while 2 times, exit function
    if [ $c == 2 ] && [ -z $input_val ]; then
      echo "$1 is required" > /dev/tty
      exit 1
    fi
  done

  # Return
  echo $input_val
}

###################################################################
# CHECK INPUT                                                     #
###################################################################
check_input() {
  # Loop all arguments
  for e in "$@"
  do
    # When exists any empty argument, return 1(Failure)
    if [ -z $e ]; then
      return 1
    fi
  done
}