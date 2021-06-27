#!/bin/bash

my_list=(a b c d e f)

echo ${my_list[0]}
echo "This is  value at index 4:  ${my_list[4]}"

echo ${my_list[@]}

#echo $(ls)

echo {0..5}
