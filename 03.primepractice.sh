#!/bin/bash
echo -e "Enter the number: \c"
read n
for (( i=2; i<=n/i; i++ ))
do
    ans=$( n%i )
    if [ $ans -eg 0 ]; then
        echo "$n is not prime number"
        exit 0
    fi
done
echo "$n is prime number"