get_port() {
  local input_val
  read -p "Set $1 port[default: $2] -> " input_val
  if [ -z $input_val ] || [ $input_val == "" ]; then
    echo "It will set default port $2" > /dev/tty
    input_val=$2
  fi
  
  used="$(lsof -i -P -n | grep LISTEN | grep $input_val | wc -l)"
  echo "used" $used > /dev/tty
  if [ $used == 0 ]; then
    echo $input_val
  else
    echo "$input_val is used." > /dev/tty
    exit 1
  fi
  
}

get_require_data() {
  local input_val
  for (( c=1; c<3; c++ ))
  do
    if [ $2 == "true" ];then
      read -sp "Please write $1 -> " input_val
      echo > /dev/tty
    else
      read -p "Please write $1 -> " input_val
    fi

    if [ ! -z $input_val ]; then
      break
    fi

    if [ $c == 2 ] && [ -z $input_val ]; then
      echo "$1 is required" > /dev/tty
      exit 1
    fi
  done
  echo $input_val
}

check_input() {
  for e in "$@"
  do
    if [ -z $e ]; then
      return 1
    fi
  done
}