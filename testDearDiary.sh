#!/bin/bash

mkdir test/
cp ./dear-diary.sh
cd test/

for fileNum in {0..5}; do
    echo "This is File number $fileNum" > "File$fileNum.drd"
done

######################## Test MVP: ##########################
# NOTE: Tests...
#   1) File not in directory. and nothing saved (file is empty).
#   2) File not in directory. And text is inserted and saved. Password is created. Password is confirmed successfully. Encryption is tested.
#   3) File not in directory. And text is inserted and saved. Password is created. Password fails confirmation. Password is then created and confirmed correctly. Encryption is tested.
spawn ./dear-diary.sh

cd ../
rm -r test/

# Test the creation of the files:
