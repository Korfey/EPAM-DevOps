#!/bin/bash
for item in `ip a | awk -F " " '/UP/||/inet / {print $2}'`
do
    if [[ $item == *"/"* ]]
    then
        echo $item | awk -F "/" '{ORS=""} {print "\t" "\033[33m" $1}'
        if [[ *"$previous"* == *"`ip ro | grep default | awk '{print $5}'`"* ]]
        then    
            echo "default " | awk '{print "\t" "\033[34m" $0}'
        fi
        echo
        continue
    fi
    echo "$item" | awk '{ORS=""} {print "\033[32m" $0}'
    previous=$item
done