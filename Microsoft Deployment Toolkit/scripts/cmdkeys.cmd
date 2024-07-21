@echo off
set /p password1=Enter password for $HOST1
set /p password1=Enter password for $HOST2

cmdkey /add:$HOST1 /user:$USER1 /pass:%password1%
cmdkey /add:$HOST2 /user:$USER2 /pass:%password2%

echo "Credentials added successfully."
