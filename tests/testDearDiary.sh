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

    printf $errMessage
}

clearFiles () {
    if [[ -f $1 ]]
    then
        rm $1
    fi
    if [[ -f "$1.drd" ]]
    then
        rm "$1.drd"
    fi
    if [[ -f "tmp.txt" ]]
    then
        rm tmp.txt
    fi
}

if [[ -d test/ ]]
then
    printf "${RED}ERROR!${RESET} Directory named 'test/' exists. Please remove or rename directory.\n"
    exit 1
fi

mkdir test/
cp ./dear-diary.sh test/
cp ./test1.exp test/test1.exp
cp ./test2.exp test/test2.exp
cp ./test3.exp test/test3.exp
cp ./test5.exp test/test5.exp
cp ./test6.exp test/test6.exp
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
#   4) File in directory. File is not .drd. File is edited and saved. Password is created. Password is confirmed. (Similar to test 2 but file already exists).
#   5) File in directory. File is .drd file. Password is inputted correctly.File is decrypted and edited. File is encrypted using old password.
#   6) File in directory. File is .drd file. Password is inputted incorrectly.

# TEST: 1.
errNum=0
./test1.exp $FILE "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 1: ${RED}ERROR${RESET} ($errCode):" 1 $errCode)
    ((++errNum))
    printf $errMessage
fi

# Check file still does not exist:
if [[ -f $FILE ]]
then
    ((++errNum))
    printf "Test 1: ${RED}ERROR${RESET} File should not persist in directory.\n"
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 1: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 1: ${RED}FAILED${RESET} $errNum tests.\n"
fi


# TEST: 2:
clearFiles $FILE
errNum=0
./test2.exp $FILE "$PASSWORD" "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 2: ${RED}ERROR${RESET} ($errCode):" 2 $errCode)
    ((++errNum))
    printf $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    printf "Test 2: ${RED}ERROR${RESET} $FILE.drd not in directory.\n"
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        printf "Test 2: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged.\n"
    fi
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 2: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 2: ${RED}FAILED${RESET} $errNum tests.\n"
fi

# TEST: 3:
clearFiles $FILE
errNum=0
./test3.exp $FILE "$PASSWORD" "$MESSAGE" 1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 3: ${RED}ERROR${RESET} ($errCode):" 3 $errCode)
    ((++errNum))
    printf $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    printf "Test 3: ${RED}ERROR${RESET} $FILE.drd not in directory.\n"
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        printf "Test 3: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged.\n"
    fi
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 3: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 3: ${RED}FAILED${RESET} $errNum tests.\n"
fi

# TEST: 4:
clearFiles $FILE
echo "Pre-existing file for test 4." > $FILE
errNum=0
./test2.exp $FILE "$PASSWORD" "$MESSAGE"  1>/dev/null # Reuse test script for test 2.
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 4: ${RED}ERROR${RESET} ($errCode):" 4 $errCode)
    ((++errNum))
    printf $errMessage
fi

if [[ ! -f $FILE.drd ]]
then
    ((++errNum))
    printf "Test 4: ${RED}ERROR${RESET} $FILE.drd not in directory.\n"
else
    echo $MESSAGE > tmp.txt
    if cmp -s tmp.txt "$FILE.drd";
    then
        ((++errNum))
        printf "Test 4: ${RED}ERROR${RESET} No encryption occurred, file contents are unchanged.\n"
    fi
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 4: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 4: ${RED}FAILED${RESET} $errNum tests.\n"
fi

# TEST: 5:
clearFiles $FILE
# Create .drd file:
t5_message="Pre-existing file for test 5."
echo "$t5_message" > $FILE
gpg --batch --yes --passphrase "$PASSWORD" --cipher-algo AES256 --symmetric -o "$FILE.drd" $FILE > /dev/null 2>&1
errNum=0
./test5.exp "$FILE.drd" "$PASSWORD" "$MESSAGE"  1>/dev/null
errCode=$?
if [[ $errCode != 0 ]] 
then
    errMessage=$(getErrMessage "Test 5: ${RED}ERROR${RESET} ($errCode):" 5 $errCode)
    ((++errNum))
    printf $errMessage
fi

if [[ ! -f "$FILE.drd" ]]
then
    ((++errNum))
    printf "Test 5: ${RED}ERROR${RESET} $FILE.drd not in directory.\n"
else
    gpg --batch --yes --passphrase "$PASSWORD" --decrypt -o $FILE "$FILE.drd" > /dev/null 2>&1
    gpgErrCode=$?
    if [[ $gpgErrCode != 0 ]]
    then
        ((++errNum))
        printf "Test 5: ${RED}ERROR${RESET} gpg decryption failed with expected passkey.\n"
    else
        echo "${t5_message}${MESSAGE}" > tmp.txt
        if cmp -s tmp.txt $FILE;
        then
            ((++errNum))
            printf "Test 5: ${RED}ERROR${RESET} Unexpected file contents. Decryption and modification failed.\n"
        fi
    fi
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 5: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 5: ${RED}FAILED${RESET} $errNum tests.\n"
fi

# TEST: 6:
clearFiles $FILE
# Create .drd file:
t6_message="Pre-existing file for test 6."
echo "$t6_message" > $FILE
gpg --batch --yes --passphrase "$PASSWORD" --cipher-algo AES256 --symmetric -o "$FILE.drd" $FILE > /dev/null 2>&1
errNum=0
./test6.exp "$FILE.drd" "$PASSWORD" "$MESSAGE"  1>/dev/null
errCode=$?
if [[ $errCode != 2 ]] 
then
    errMessage=$(getErrMessage "Test 6: ${RED}ERROR${RESET} ($errCode):" 6 $errCode)
    ((++errNum))
    printf $errMessage
fi

if [[ ! -f "$FILE.drd" ]]
then
    ((++errNum))
    printf "Test 6: ${RED}ERROR${RESET} $FILE.drd not in directory.\n"
fi

gpg --batch --yes --passphrase "$PASSWORD" --decrypt -o $FILE "$FILE.drd" > /dev/null 2>&1
gpgErrCode=$?
if [[ $gpgErrCode != 0 ]]
then
    ((++errNum))
    printf "Test 6: ${RED}ERROR${RESET} gpg decryption failed with expected passkey.\n"
else
    echo "${t5_message}" > tmp.txt
    if cmp -s tmp.txt $FILE;
    then
        ((++errNum))
        printf "Test 6: ${RED}ERROR${RESET} Unexpected file contents. File was unexpectedly modified.\n"
    fi
fi

if [[ errNum -eq 0 ]]
then
    printf "Test 6: ${GREEN}PASSED${RESET}\n"
else
    ((++failNum))
    printf "Test 6: ${RED}FAILED${RESET} $errNum tests.\n"
fi


cd ../
rm -r test/

exit $failNum
