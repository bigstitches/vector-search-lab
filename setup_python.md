
1. Download the latest Python version suitable for your operating system.  Follow instructions on python.org
1. Verify Python is in the PATH 
Open a new command prompt (Windows) or terminal (macOS/Linux) and type the following command: 
Raspberry Pi Projects
Raspberry Pi Projects
 +4
bash
python --version
If a version number is displayed (e.g., Python 3.12.0), Python is in your PATH and ready to use.
If you receive an error (e.g., 'python' is not recognized... or command not found), you need to manually add it to the PATH environment variable. 
Reddit
Reddit
 +3
You can also try using the Python launcher command py on Windows, which is often added automatically during installation: 
Stack Overflow
Stack Overflow
bash
py --version
2. Add Python to the PATH Manually 
The steps vary by operating system. You will first need to locate where Python is installed on your system. 
Real Python Tutorials
Real Python Tutorials
On Windows
Locate the Python installation directory (e.g., C:\Users\YourName\AppData\Local\Programs\Python\Python311 or C:\Python311). Remember to also find the Scripts sub-folder within that directory.
Open the "Environment Variables" editor:
Press the Windows key and search for "environment variables".
Select "Edit the system environment variables" and then click the "Environment Variables..." button in the System Properties window.
Edit the Path variable:
Under the "User variables" section, select the Path variable and click "Edit...".
Click "New" and paste the path to your main Python installation directory.
Click "New" again and paste the path to the Scripts directory.
Click "OK" on all windows to save the changes.
Restart your command prompt or terminal window for the changes to take effect. 
Reddit
Reddit
 +5
Alternatively, you can run the Python installer again, select "Modify", and ensure the "Add Python to environment variables" option is checked in the Advanced Options screen. 
Stack Overflow
Stack Overflow
 +1
On macOS and Linux
Locate the Python executable path using the command which python or which python3 in your terminal.
Open your shell configuration file (e.g., ~/.bashrc, ~/.bash_profile, or ~/.zprofile for zsh shell) in a text editor like nano:
bash
nano ~/.bash_profile
Add the export command to the end of the file, replacing /path/to/python with your actual Python directory path:
bash
export PATH="/path/to/python:$PATH"
Save the file and exit the editor (Ctrl+O, Enter, Ctrl+X in nano).
Apply the changes by sourcing the file or restarting your terminal:
bash
source ~/.bash_profile
