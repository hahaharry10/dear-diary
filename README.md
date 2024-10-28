# dear-diary
dear-diary is a command-line tool allowing secure journalling directly from the terminal. Files are password protected and secured using ![GnuPG](https://gnupg.org) and currently only supports the ![vim](https://www.vim.org) text editor.

# Installation
## Supported platofrms:
- Linux
- MacOS
## Dependencies
- ![GnuPG](https://gnupg.org)
- ![vim](https://www.vim.org)

### Installation guide:
1. Clone the repository in a local directory.
<a id="step-2"></a>
2. Create a `bin/` subdirectory within `~/.local/` with
    ```
    $ mkdir -p ~/.local/bin/
    ```
    - `~/.local/bin/` is recommended however any directory is sufficient.
3. If the above directory (or your chosen directory) is not already present, add it to `PATH` using
    ```
    $ export PATH="$HOM£/.local/bin/:$PATH"
    ```
    - You can check the directories in `PATH` with `echo $PATH`
4. `cd` into the cloned repo and copy `dear-diary.sh` into the directory using:
    ```
    $ cp dear-diary.sh ~/.local/bin/dear-diary
    ```
    - Make sure the copied file does not include the `.sh` file extension.
    - If using a different directory, change the second directory accordingly.

NOTE:
- If you want to keep this feature in all future sessions, append `export PATH="$HOME/.local/bin/:$PATH"` to your shell configuration file.
- Changes to `dear-diary.sh` will not be applied unless re-copied into the binary directory chosen in [step 2](#step-2).

## Usage
```
$ dear-diary file
```

### Additional Features:
Additional features contribute to the final product but are beyond the MVP.
- [ ] Support for windows
- Execution options: `Usage: dear-diary [flags] file`
	- [ ] `Usage: dear-diary [options] [file]`
	- [ ] `-h` Display help.
	- [ ] `-l` Encrypt (lock) the file.
		- Input: `fileName.txt`
		- Output: `fileName.drd`
		- `fileName.txt` must exist.
	- [ ] `-u` Decrypt (unlock) the file.
		- Input: `fileName.drd`
		- Output: `fileName.txt`
		- `fileName.drd` must exist.
	- [ ] `-n` Create new password before encryption.
		- Input: `fileName[.drd|.txt]`
		- Output: `fileName[.txt|.drd]`
		- If file does not exist, operation will be be identical to MVP.
	- [ ] `-nvim` Open file using neovim (if installed) instead of vim.
	- [ ] `-v` Verbose; output log to terminal.
