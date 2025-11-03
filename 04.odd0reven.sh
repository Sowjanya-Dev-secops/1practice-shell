echo -e "Enter the number: \c"
read n
if [ n/2 -eq 0 ]; then
    echo "$n is even nuber"
else
    echo "$n is odd number"
fi