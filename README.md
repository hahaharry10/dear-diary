# dear-diary

### Aim:
Dear-diary is a bash script that will act as a command line secret journal. The user will be able to call the command and create and edit a text file that is then encrypted and password protected
upon closing.

This project aims to apply a few programming practices:
1) Test Driven Development (TDD):
	- Test scripts will be written before feature implementation.
 2) Automated Testing:
	- Bash scripts will be created to automate the testing of the command.
 3) Bash:
	- The command script and all test scripts will be written in bash.

### Minimum Viable Product (MVP):
The MVP will be called as follows:
```
$ dear-diary [file]
```

And will have the following design:
![Flowchart showing operations of dear-diary MVP](https://github.com/user-attachments/assets/f371f4e9-19f4-4f1f-93b7-24706027ecf7)


### Additional Features:
Additional features contribute to the final product but are beyond the MVP.

Additional Features:
- Execution options:
	- `Usage: dear-diary [options] [file]`
	- `-h` Display help.
	- `-l` Encrypt (lock) the file.
		- Input: `fileName.txt`
		- Output: `fileName.drd`
		- `fileName.txt` must exist.
	- `-u` Decrypt (unlock) the file.
		- Input: `fileName.drd`
		- Output: `fileName.txt`
		- `fileName.drd` must exist.
	- `-n` Create new password before encryption.
		- Input: `fileName[.drd|.txt]`
		- Output: `fileName[.txt|.drd]`
		- If file does not exist, operation will be be identical to MVP.
	- `-nvim` Open file using neovim (if installed) instead of vim.
	- `-v` Verbose; output log to terminal.

**Note: Test scripts will be written at the start of the features development but before its implementation.**

### Error Codes:
These error codes are added when their handlers are added. So the order may be iffy but that will be changed at the end.

Error Code | Description
---|---
0|Successful execution.
1|Usage error. Command, function, or file was called incorrectly.
2|Desired text editor failed to open.
3|Timeout occurred when expecting pattern.
4|The operating system returned an error when spawning process.
5|`eof` detected prematurely.
255|Feature being tested has not yet been implemented.

### Changing shebang:
The location of `bash` and `expect` may be different on your system. Therefore you may have to check the shebang. The repo's default is:
- Bash: `/bin/bash`
- Expect: `/bin/expect`

To change the shebang, you can either:
- Execute `which expect` or `which bash` and modify files manually using desired text editor.
- Use `sed`:
    - `sed -i "s|^#\!/.*|#\!$(which expect)|" *.exp` changes expect script shebang.
    - `sed -i "s|^#\!/.*|#\!$(which bash)|" *.sh` changes bash script shebang.

### Execution:
To execute `dear-diary` as a command, follow these steps:
1. Create a `bin/` directory in `.local`:
	```
	$ mkdir ~/.local/bin/
	```
	- It is advised to have a different directory to your systems `bin/` directory for custom commands.
	- If you want a different location, then follow the below steps but change the directory to your chosen one.


2. Add directory to `PATH`:
	```
	$ export PATH="$HOME/.local/bin/:$PATH"
	```
	- If using different directory change `$HOME/.local/bin/` to the directory your chosen directory.


3. Copy `dear-diary.sh` into the directory:
	```
	$ cp /path/to/dear-diary.sh ~/.local/bin/dear-diary
	```
	- Do not include the `.sh` file extendion in the name of the copied file.

Now you should be able to run the `dear-diary` anywhere.

NOTE:
- If you want to keep this feature in all future sessions, append `export PATH="$HOME/.local/bin/:$PATH"` to your shell configuration file.
- If changes are made to `dear-diary.sh`, you must re-copy the file to `~/.local/bin/` to implement the changes.

### Dependencies:
- gpg
- expect
