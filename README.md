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
![image](https://github.com/user-attachments/assets/ea2e4b62-88ca-45d1-9640-5b413c3c1f70)

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
