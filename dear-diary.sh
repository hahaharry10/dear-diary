#!/bin/bash

# Functions:
createNewPassword () {
    while :
    do
        echo -en "Password:"
        read -s PASSWORD
        echo -en "Confirm Password:"
        read -s CONFIRMED_PASSWORD

        if [[ $PASSWORD = $CONFIRMED_PASSWORD ]]
        then
            break
        else
            echo -en "Passwords Do not match.\n"
        fi
    done

    echo $PASSWORD
}

if [[ $# != 1 ]]
then
    echo "Usage: $ dear-diary file"
    exit 0
elif [[ -d $1 ]]
then
    echo "ERROR: Input is directory. Must be a file."
    exit 1
fi

FILE=$1
EXTENSION=${FILE##*.}

if [[ $EXTENSION != "drd" ]]
then
    vim $FILE
    if [[ ! -f $FILE ]]
    then
        exit 0;
    fi

    # Get password:
    PASSWORD="$(createNewPassword)"

    # Encrypt file:
    gpg --batch --yes --passphrase "$PASSWORD" --cipher-algo AES256 --symmetric -o "$FILE.drd" $FILE > /dev/null 2>&1
    errCode=$?

    if [[ $errCode -ne 0 ]]
    then
        if [[ -f "$FILE.drd" ]]
        then
            rm "$FILE.drd"
        fi
        echo -en "Failed to encrypt file. gpg error code $errCode.\n"
        exit $errCode
    fi
    shred -u $FILE
else
    read -s PASSWORD
    gpg --batch --yes --passphrase "$PASSWORD" --decrypt -o "${FILE%.*}" $FILE
    errCode=$?

    if [[ $errCode -ne 0 ]]
    then
        if [[ -f "$FILE.drd" ]]
        then
            rm "$FILE.drd"
        fi
        echo -en "Failed to decrypt file. gpg error code $errCode.\n"
        exit $errCode
    fi
    
    shred -u $FILE # Delete the encrypted file.

    FILE=${FILE%.*}
    vim $FILE

    # Re-encrypt file using old password:
    gpg --batch --yes --passphrase "$PASSWORD" --cipher-algo AES256 --symmetric -o "$FILE.drd" $FILE > /dev/null 2>&1
    errCode=$?

    if [[ $errCode -ne 0 ]]
    then
        if [[ -f "$FILE.drd" ]]
        then
            rm "$FILE.drd"
        fi
        echo -en "Failed to encrypt file. gpg error code $errCode.\n"
        exit $errCode
    fi

    shred -u $FILE # Delete plaintext file.
fi

exit 0
