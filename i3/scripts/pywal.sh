#! /bin/bash
if [[ $# -eq 1 ]]; then
  if [[ $1 == "next" ]]; then
    wal -i ~/Pictures &
    ~/.local/bin/intellijpywal/intellijPywalGen.sh ~/.IntelliJIdea2018.2/config &
    sleep 1
    pic=$( cat $HOME/.cache/wal/wal )
    folder_name=$( basename $pic | cut -f 1 -d "." )
    folder=$HOME/.cache/i3lock/$folder_name
    if [ ! -d $folder ]; then
      echo "folder $folder not found, creating it"
      betterlockscreen -u $pic &
    fi
  fi
  exit 0
fi

wal -R

if pidof -o %PPID -x "pywal.sh">/dev/null; then
        exit -1
fi
while true
do
  sleep 10m
  wal -i ~/Pictures > /dev/null &
  ~/.local/bin/intellijpywal/intellijPywalGen.sh ~/.IntelliJIdea2018.2/config > /dev/null &
  sleep 1
  pic=$( cat $HOME/.cache/wal/wal )
  folder_name=$( basename $filename | cut -f 1 -d "." )
  folder=$HOME/.cache/i3lock/$folder_name
  if [ ! -d $folder ]; then
    betterlockscreen -u $pic &
  fi
done
