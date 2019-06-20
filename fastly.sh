#!/bin/bash

function finish() {
  stty echo
  stty -igncr
  echo " bye bye!"
  tput cnorm
  tput cup 16 0
  exit 0
}

trap finish SIGINT

clear
while :;do
 start=$(( $(tput cols) + $(tput lines) ))
 tput cup 0 0 

fastly=$(curl -s -POST -H "Fastly-Key:************************" \
https://rt.fastly.com/v1/channel/**************/**/h/limit/1)

 requests=$(echo $fastly|jq .Data[].aggregated.requests)
 status_2=$(echo $fastly|jq .Data[].aggregated.status_2xx)
 status_3=$(echo $fastly|jq .Data[].aggregated.status_3xx)
 status_4=$(echo $fastly|jq .Data[].aggregated.status_4xx)
     hits=$(echo $fastly|jq .Data[].aggregated.hits)
     miss=$(echo $fastly|jq .Data[].aggregated.miss)
     pass=$(echo $fastly|jq .Data[].aggregated.pass)
   errors=$(echo $fastly|jq .Data[].aggregated.errors)
hits_time=$(echo $fastly|jq .Data[].aggregated.hits_time)
miss_time=$(echo $fastly|jq .Data[].aggregated.miss_time)
pass_time=$(echo $fastly|jq .Data[].aggregated.pass_time)

status_2p=$(( $status_2 * 100 / $requests ))
status_3p=$(( $status_3 * 100 / $requests ))
status_4p=$(( $status_4 * 100 / $requests ))
   hits_g=$(( $hits + $miss + $pass ))
   hits_p=$(( $hits * 100 / $hits_g ))
   miss_p=$(( $miss * 100 / $hits_g ))
   pass_p=$(( $pass * 100 / $hits_g ))

for a in {1..51}; do  
echo -n " "
done
echo -e "\e[33;41m[Fastly]\e[0m"

## 2xx
old="$status_2p"
with=${#status_2p}
count="$status_2p"
echo -en "  \e[1m2xx    ["
while [ $status_2p -gt 0 ];do 
  if [ $old -gt 60 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi
  : $((status_2p--))
done
count=$(( 100 - $count ))
while [ $count -gt 0 ];do 
  echo -n " ";: $((count--))
done   

case "$with" in
"1")
   echo -e "\e[0;1m   $old %]"
   ;;
"2")
   echo -e "\e[0;1m $old %]"
   ;;
"3")
   echo -e"\e[0;1m$old %]"
  ;;
esac

## 3xx
with=${#status_3p}
old="$status_3p"
count="$status_3p"
echo -en "  \e[1m3xx    ["
while [ $status_3p -gt 0 ];do 
  if [ $old -lt 10 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi 
  : $((status_3p--))
done
count=$(( 100 - $count ))
while [ $count -gt 0 ];do 
  echo -n " ";: $((count--))
done   

case "$with" in
"1")
   echo -e "\e[0;1m  $old %]"
   ;;  
"2")
   echo -e "\e[0;1m $old %]"
   ;;  
"3")
   echo -e "\e[0;1m$old %]"
  ;;                                                                                                                    
esac

## 4xx
with=${#status_4p}
old="$status_4p"
count="$status_4p"
echo -en "  \e[1m4xx    ["
while [ $status_4p -gt 0 ];do 
  if [ $old -lt 10 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi  
  : $((status_4p--))
done
count=$(( 100 - $count ))
while [ $count -gt 0 ];do 
  echo -n " ";: $((count--))
done   

case "$with" in
"1")
   echo -e "  \e[0;1m$old %]"
   ;;  
"2")
   echo -e " \e[0;1m$old %]"
   ;;  
"3")
   echo -e "\e[0;1m$old %]"
  ;;                                                                                                                    
esac

## hit 
with=${#hits_p}
old="$hits_p"
count="$hits_p"
echo -en "  \e[1mHits   ["
while [ $hits_p -gt 0 ];do
  if [ $old -gt 50 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi  

  : $((hits_p--))
done
count=$(( 100 - $count ))
while [ $count -gt 0 ];do
  echo -n " ";: $((count--))
done

case "$with" in
"1")
   echo -e "  \e[0;1m$old %]"
   ;;
"2")
   echo -e " \e[0;1m$old %]"
   ;;
"3")
   echo -e "\e[0;1m$old %]"
  ;;
esac

## miss
with=${#miss_p}
old="$miss_p"
count="$miss_p"
echo -en "  \e[1mMiss   ["
while [ $miss_p -gt 0 ];do
  if [ $old -lt 30 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi 
: $((miss_p--))
done  
count=$(( 100 - $count ))
while [ $count -gt 0 ];do
  echo -n " ";: $((count--))
done  

case "$with" in
"1")
   echo -e "  \e[0;1m$old %]"
   ;;  
"2")   
   echo -e " \e[0;1m$old %]"
   ;;  
"3")   
   echo -e "\e[0;1m$old %]"
  ;;   
esac 

## pass
with=${#pass_p}
old="$pass_p"
count="$pass_p"
echo -en "  \e[1mPass   ["
while [ $pass_p -gt 0 ];do
  if [ $old -lt 50 ];then
    echo -en "\e[32m|"
  else
    echo -en "\e[31m|"
  fi 
  : $((pass_p--))
done  
count=$(( 100 - $count ))
while [ $count -gt 0 ];do
  echo -n " ";: $((count--))
done  

case "$with" in
"1")
   echo -e "  \e[0;1m$old %]"
   ;;  
"2")   
   echo -e " \e[0;1m$old %]"
   ;;  
"3")   
   echo -e "\e[0;1m$old %]"
  ;;   
esac 
echo

## miss_time und pass_time ist aufsummiert
## und muss noch runter gerechnet werden
miss_time=$(echo "scale=4; $miss_time / $miss "| bc | sed 's/^\./0./')
pass_time=$(echo "scale=4; $pass_time / $pass "| bc | sed 's/^\./0./')

## hits_time scale 4
hits_time=${hits_time::6}

if [[ $requests -gt 800 ]]; then
    requests_status="\e[31m"
  else
    requests_status="\e[32m"
fi

if (( $(echo "$hits_time > 1" |bc -l) )); then
    hits_time_status="\e[31m"
  else
    hits_time_status="\e[32m"
fi

if (( $(echo "$miss_time > 42" |bc -l) )); then
    miss_time_status="\e[31m"
  else
    miss_time_status="\e[32m"
fi

if (( $(echo "$pass_time > 17" |bc -l) )); then
    pass_time_status="\e[31m"
  else
    pass_time_status="\e[32m"
fi

if [[ $error -gt 10 ]];then
    error_status="\e[31m"
  else
    error_status="\e[32m"
fi

echo -e "  \e[1mRequests:  ${requests_status}$requests\e[0;1m  p/sec          "
echo -e "  \e[1mHits Time: ${hits_time_status}$hits_time\e[0;1m sec           "
echo -e "  \e[1mMiss Time: ${miss_time_status}$miss_time\e[0;1m sec           "
echo -e "  \e[1mPass Time: ${pass_time_status}$pass_time\e[0;1m sec           "
echo -e "  \e[1mErrors: ${error_status}$errors\e[0;1m                         "
echo

echo -e "\e[7m  Exit with ctrl + c                     \e[0m"
 tput civis; sleep 1
 end=$(( $(tput cols) + $(tput lines) ))
 if [[ $start -ne $end ]];then
   clear
 fi

 tput civis; sleep 1
 end=$(( $(tput cols) + $(tput lines) ))
 if [[ $start -ne $end ]];then
   clear
 fi
done 
