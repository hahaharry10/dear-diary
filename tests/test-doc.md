# Testing dear-diary
dear-diary was created using test driven development. The following does not relate to the implementation of [additional features](../README.md#Additional-Features).

## Operation Flow:
The commands operations are described in the following flowchart:
![Flowchart showing operations of dear-diary MVP](https://github.com/user-attachments/assets/f371f4e9-19f4-4f1f-93b7-24706027ecf7)

## Test Design:
Testing of the command will use bash and expect scripts. 

The main testing logic are written in `testDearDiary.sh` and will call the expect scripts for automated user interaction. These scripts are outlined in the files named `test<number>.exp`.

## Running the tests:
1. Make sure you have ![expect](https://linux.die.net/man/1/expect) installed.
2. Check the location of bash and expect in your system using:
    ```
    $ which bash
    $ which expect
    ```
    - The repos default location is:
        - Bash: `/bin/bash`
        - Expect: `/bin/expect`
3. If the bash location is different to the repos default, change the shebang in the bash script with:
    ```
    $ sed -i "s|^#\!/.*|#\!$(which bash)|" testDearDiary.sh
    ```
4. If the expect location is different to the repos default, change the shebang in the expect scritps with:
    ```
    $ sed -i "s|^#\!/.*|#\!$(which bash)|" *.sh
    ```

Once these steps are completed run the test using `./testDearDiary.sh`.

## Error Codes:
Each of the expect scripts return an error code. The below table describes the meanings behind the error codes.

Error Code | Description
---|---
0|Successful execution.
1|Usage error. Command, function, or file was called incorrectly.
2|Desired text editor failed to open.
3|Timeout occurred when expecting pattern.
4|The operating system returned an error when spawning process.
5|`eof` detected prematurely.
255|Feature being tested has not yet been implemented.
