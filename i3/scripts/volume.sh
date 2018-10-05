#! /bin/bash
if [[ $# -eq 1 ]]; then
  if [[ $( pacmd list-sinks | grep 'device.bus = "bluetooth"' ) ]]
  then
    if [[ $1 == "inc" ]]
    then
      value=$( pacmd list-sinks | grep "front-left:" | head -n 2 | tail -n 1 | tr -s " " | cut -f 5 -d " " | tr -d "%" )
      if [[ $value -le 115 ]]
      then
        pactl set-sink-volume 1 +5% #increase sound volume
      fi
    elif [[ $1 == "dec" ]]; then
      value=$( pacmd list-sinks | grep "front-left:" | head -n 2 | tail -n 1 | tr -s " " | cut -f 5 -d " " | tr -d "%" )
      if [[ $value -gt 0 ]]; then
        pactl set-sink-volume 1 -5% #decrease sound volume
      fi
    fi
  else
    if [[ $1 == "inc" ]]
    then
      value=$( pacmd list-sinks | grep "front-left:" | head -n 1 | tr -s " " | cut -f 5 -d " " | tr -d "%" )
      if [[ $value -le 115 ]]
      then
        pactl set-sink-volume 0 +5% #increase sound volume
      fi
    elif [[ $1 == "dec" ]]; then
      value=$( pacmd list-sinks | grep "front-left:" | head -n 1 | tr -s " " | cut -f 5 -d " " | tr -d "%" )
      if [[ $value -gt 0 ]]; then
        pactl set-sink-volume 0 -5% #decrease sound volume
      fi
    fi
  fi
fi
