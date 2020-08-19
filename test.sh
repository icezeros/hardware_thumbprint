#!/usr/bin/env bash
trim()
{
    trimmed=$*
    trimmed=${trimmed%% }
    trimmed=${trimmed## }
    echo $trimmed
   
}

baseFun()
{
    str=$*
    # base=$(base64 -i <<< "$str" )
    base=$(echo -n $str | base64 )
    echo $base
}

if [ $(uname) == "Darwin" ]
then
   echo "Platform: Mac os"
   serial=`system_profiler SPHardwareDataType | grep -e Serial`
   uuid=`system_profiler SPHardwareDataType | grep -e UUID`
#    cmd=`system_profiler SPHardwareDataType | grep -e Serial -e UUID`
   serialTrim=`trim $serial`
   uuidTrim=`trim $uuid`
   strall="${serialTrim/: /:}|${uuidTrim/: /:}"
   base=`baseFun $strall`
#    echo $strall
   echo "hardware_thumbprint: $base"

elif [ "$(expr substr $(uname -s) 1 5)"=="Linux" ]
then
   echo "Platform: Linux"
   serial=`dmidecode -t system | grep -e Serial`
   uuid=`dmidecode -t system | grep -e UUID`
#    cmd=`dmidecode -t system | grep -e Serial -e UUID`
   serialTrim=`trim $serial`
   uuidTrim=`trim $uuid`
   strall="${serialTrim/: /:}|${uuidTrim/: /:}"
#    echo $strall
   base=`baseFun $strall`
   echo "hardware_thumbprint: $base"

elif [ "$(expr substr $(uname -s) 1 10)"=="MINGW32_NT" ]
then
   echo "windows 不兼容"
else
   echo "没有符合的条件"
fi

