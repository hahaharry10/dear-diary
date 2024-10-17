#!/bin/bash

mkdir test/
cp ./dear-diary.sh test/
cd test/

GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

######################## Test MVP: ##########################
# NOTE: Tests...
#   1) File not in directory. and nothing saved (file is empty).
#   2) File not in directory. And text is inserted and saved. Password is created. Password is confirmed successfully. Encryption is tested.
#   3) File not in directory. And text is inserted and saved. Password is created. Password fails confirmation. Password is then created and confirmed correctly. Encryption is tested.

errCode=$(./test1 test.txt)
if [[ $errCode = 0 ]] 
then
    echo -e "Test 1: ${GREEN}PASSED${RESET}\n"
else
    echo -e "Test 1: ${RED}FAILED${RESET} ($errCode). "
    if [[ $errCode = 1 ]]
    then
        echo -e "Invalid usage of test1.\n"
    else
        echo -e "Unknown Error\n"
    fi
fi

cd ../
rm -r test/

# Test the creation of the files:
