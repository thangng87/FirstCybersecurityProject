#!/bin/bash

months=(
'january'
'february'
'march'
'april'
'may'
'june'
'july'
'august'
'september'
'october' 
'novmeber'
'december'
)

days=('mon' 'tues' 'wed' 'thur' 'fri' 'sat' 'sun' )
for month in ${months[@]} 
#<list>
do

	echo $month
	
done

for day in ${days[@]}
do
if [ $day = 'sun' ] || [ $day = 'sat' ]
then
echo "it's  $day! take it easy"
else
echo "it's $day! you need to work "
fi
#echo $day

done

# print out the detail of  file or directory from  command ls
for entry in $(ls)

do 
ls -lah $entry
#echo "this file folder is call $entry "
done

#make a loop to print out a number if is 1 or 4 from a list
for num in {0..5}

do
if [ $num = 1 ] || [$num = 4 ]
then
echo $num
fi
done


