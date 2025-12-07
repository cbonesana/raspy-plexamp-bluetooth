#!/bin/bash

DEVICE="AA:BB:CC:DD:EE:FF" # bluetooth speaker mac address

bluetoothctl
sleep 10

echo "connect ${DEVICE}" | bluetoothctl

sleep 12

echo "connect ${DEVICE}" | bluetoothctl

exit

