#!/bin/bash

# Redirect output to a log file
exec > >(tee -a ./kontextmeny.log) 2>&1

echo "Starting the setup script..."

# Adding user to kali-trusted group
echo "Adding user to kali-trusted group..."
usermod -aG kali-trusted user

# Check for errors in the previous command
if [ $? -ne 0 ]; then
    echo "Error: Adding user to kali-trusted group failed. Exiting."
    exit 1
fi

# Backup original .bashrc
cp /home/user/.bashrc /home/user/.bashrc_backup

# Create extra config file for right-click "Kali Desktop"
cp /home/user/.bashrc /home/user/.bashrc2

# Create /etc/wsl.conf
echo "Creating /etc/wsl.conf..."
touch /etc/wsl.conf

# Uncomment the next line only if hushlogin files need to be added
# touch /home/user//.hushlogin

# Add content to .bashrc
echo "Adding Kali Kontext Meny to .bashrc..."
cat << EOF >> /home/user/.bashrc
# KALI KONTEXT MENY
if [ -z "\$WSL_INTEROP" ]; then
    kex --win
fi
cd \$HOME
EOF

# Add content to .bashrc2
echo "Adding Kali Kontext Meny to .bashrc2..."
cat << EOF >> /home/user/.bashrc2
# KALI KONTEXT MENY
if [ "\$WSL_INTEROP" ]; then
    kex --win
fi
cd \$HOME
EOF

# Create /etc/wsl.conf with default user
echo "Creating /etc/wsl.conf with default user..."
cat << EOF >> /etc/wsl.conf
# KALI DEFAULT ANVÄNDARE
[user]
default=user
EOF

echo "Script execution completed successfully."

