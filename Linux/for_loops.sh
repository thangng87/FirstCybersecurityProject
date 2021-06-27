#!/bin/bash

provs=('Quebec' 'Ontario' 'Alberta' 'Saskatchewan' 'BC' )

for province in ${provs[@]}

do

if [ $province == 'Alberta' ];
then

echo "this is ALberta"
else
echo "I'm not a fan of Alberta"
fi

done


nums=$(echo{0..9})

echo $nums

#second way(recommended for easier to remember)

nums2=$(seq 0 9)
echo $nums2

for num in ${nums2[@]}

do
if [ $num == 3 ] || [ $num == 5 ] || [ $num == 7 ]
then
echo $num
fi
done


#variable hold the output ls

for output in  $(ls)

do
echo $output

done


#super bonus question

