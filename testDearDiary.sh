#!/bin/bash

GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Arguments in order of: [errMessage] [test number] [errCode]
getErrMessage () {
    case $3 in
        1)
            errMessage="$1 Usage error."
            ;;
        2)
            errMessage="$1 Desired text editor failed to open."
            ;;
        3)
            errMessage="$1 Timeout occurred when expecting eof"
            ;;
        4)
            errMessage="$1 OS level error."
            ;;
        255)
            errMessage="$1 Feature not implemented."
            ;;
        *)
            errMessage="$1 Uncaught Error."
            ;;
    esac

    echo -e $errMessage
}

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
    errMessage=$(getErrMessage "Test 1: ${RED}ERROR${RESET} ($errCode):" 1 $errCode)
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
