#!/bin/bash

if [[ -z "$1" ]]; then
  echo "No parameter passed";
  exit 1;
fi

if [[ ! -f "$1" ]]; then
  echo "Please pass a valid path to an sql file";
  exit 1;
fi

string_to_cut=$(head -n 1 "$1"| cut -d' ' -f1-5)

sed -i '1s/Insert into/INSERT INTO/' "$1"
sed -i '1s/values/VALUES\n/' "$1"
sed -i "s/$string_to_cut//" "$1"
sed -i 's/);/),/' "$1"
sed -i '$s/),/);/' "$1"

