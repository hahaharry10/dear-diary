#!/bin/bash

GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Arguments in order of: [errMessage] [test number] [errCode]
getErrMessage () {
    case $3 in
        1)
            errMessage="$1 Usage error. Command, function, or file was called incorrectly."
            ;;
        2)
            errMessage="$1 Desired text editor failed to open."
            ;;
        3)
            errMessage="$1 Timeout occurred when expecting pattern."
            ;;
        4)
            errMessage="$1 Operating system returned an error when spawning process."
            ;;
        5)
            errMessage="$1 eof detected prematurely."
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
cp ./test2.exp test/test2.exp
cp ./test3.exp test/test3.exp
cd test/

failNum=0 # Track number of tests that have failed.
FILE="test.txt"
PASSWORD="TeStPaSsWoRd"
MESSAGE="Hello World!"

######################## Test MVP: ##########################
# NOTE: Tests...
#   1) File not in directory. And nothing saved (file still does not exist).
#   2) File not in directory. And text is inserted and saved. Password is created. Password is confirmed successfully. Encryption is tested.
#   3) File not in directory. And text is inserted and saved. Password is created. Password fails confirmation. Password is then created and confirmed incorrectly 3 more times before confirmed correctly. Encryption is tested.
#   4) File in directory. File is not .drd. File is eddited and saved. Password is created. Password is confirmed. (Similar to test 2 but file already exists).

# TEST: 1.
errNum=0
./test1.exp $FILE "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
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


# TEST: 2:
if [[ -f $FILE ]]
then
    rm $FILE
fi
errNum=0
./test2.exp $FILE "$PASSWORD" "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 2: ${RED}ERROR${RESET} ($errCode):" 2 $errCode)
    ((++errNum))
    echo -e $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    echo -e "Test 2: ${RED}ERROR${RESET} $FILE.drd not in directory."
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        echo -e "Test 2: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged."
    fi
fi

# TEST: 3:
if [[ -f $FILE ]]
then
    rm $FILE
fi
errNum=0
./test3.exp $FILE "$PASSWORD" "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 3: ${RED}ERROR${RESET} ($errCode):" 3 $errCode)
    ((++errNum))
    echo -e $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    echo -e "Test 3: ${RED}ERROR${RESET} $FILE.drd not in directory."
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        echo -e "Test 3: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged."
    fi
fi

# TEST: 4:
#   4) File in directory. File is not .drd. File is eddited and saved. Password is created. Password is confirmed.
if [[ -f $FILE ]]
then
    rm $FILE
fi
if [[ -f "$FILE.drd" ]]
then
    rm "$FILE.drd"
fi
echo "Pre-existing file for test 4." > $FILE
errNum=0
./test2.exp $FILE $PASSWORD $MESSAGE # Reuse test script for test 2.
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 4: ${RED}ERROR${RESET} ($errCode):" 4 $errCode)
    ((++errNum))
    echo -e $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    echo -e "Test 4: ${RED}ERROR${RESET} $FILE.drd not in directory."
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        echo -e "Test 4: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged."
    fi
fi

if [[ errNum = 0 ]]
then
    echo -e "Test 4: ${GREEN}PASSED${RESET}"
else
    ((++failNum))
    echo -e "Test 4: ${RED}FAILED${RESET} $errNum tests."
fi


cd ../
rm -r test/

exit $failNum
