#!/bin/bash

GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

if [[ -d test/ ]]
then
    echo -e "${RED}ERROR!${RESET} Directory named 'test/' exists. Please remove or rename directory."
    exit 1
fi
    

mkdir test/
cp ./dear-diary.sh test/
cp ./test1.exp test/test1.exp
cd test/

failNum=0 # Track number of tests that have failed.

######################## Test MVP: ##########################
# NOTE: Tests...
#   1) File not in directory. and nothing saved (file still does not exist).
#   2) File not in directory. And text is inserted and saved. Password is created. Password is confirmed successfully. Encryption is tested.
#   3) File not in directory. And text is inserted and saved. Password is created. Password fails confirmation. Password is then created and confirmed correctly. Encryption is tested.

# TEST: 1.
#   Requirements for passing:
#       - expect script spawns and interacts with dear-diary successfully.
#       - The file does not get created in the end (file does not exist before or after execution).
#
errNum=0
FILE="test.txt"
./test1.exp $FILE 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage="Test 1: ${RED}ERROR${RESET} ($errCode):"
    if [[ $errCode = 1 ]]
    then
        errMessage="$errMessage test1.exp called without a file."
    elif [[ $errCode = 2 ]]
    then
        errMessage="$errMessage Desired text editor failed to open."
    elif [[ $errCode = 3 ]]
    then
        errMessage="$errMessage Timeout occurred when expecting eof"
    elif [[ $errCode = 4 ]]
    then
        errMessage="$errMessage OS level error."
    elif [[ $errCode = 255 ]]
    then
        errMessage="$errMessage Feature not implemented."
    else
        errMessage="$errMessage Uncaught Error."
    fi
    ((++errNum))
    echo -e $errMessage
fi

# Check file still does not exist:
if [[ -f $FILE ]]
then
    ((++errNum))
    echo -e "Test 1: ${RED}ERROR${RESET} File should not persist in directory."
fi

if [[ errNum = 0 ]]
then
    echo -e "Test 1: ${GREEN}PASSED${RESET}"
else
    ((++failNum))
    echo -e "Test 1: ${RED}FAILED${RESET} $errNum tests."
fi

cd ../
rm -r test/

exit $failNum
