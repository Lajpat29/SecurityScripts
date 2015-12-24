#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash
# Locking down the account i.e disable password
passwd -dl sshlogin

#Creating .ssh folder in sshlogin home.
mkdir /home/sshlogin/.ssh

#Copying the ssh-key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCz/gRm3IBagXh1mxUTWUbozUFKdUHaY1SC0X5vPmyyHKN43tmWdebx7iL+t7jM1vdxdSADxCvqDkYQVWoMemsrJoOeqk4f7rcRSwDjcvfu4mzX9fRPEUeyEhGqPEyOrvWjC7ifA2E1mAJo2iVvQFF1hv0zCOJZ/9v5mnXeRF3hfPPH2IPRuCQIoKbYXNKJ/i31xPFp+prq5WCm4u/airghQOOozWCb9okwUeKEKiZJ1bWOElfni7WsaTZYZ0rTJC4Hq9uRa1/E6jUGvurHd6x0kVpbVDynG0is7ap3uIEQu2vdXSLGj4htlcKPJKNDf6Y1exHtR3ApG+tqtIJZSQSbGn7kH/OWQ5wblxhMR/Vav+3upd3tQ1/U4+wDL0hHPGBABIOLhcsi0xwHIsUcb6rHePptlEh2p8iY7sb72hInqR9qfsNDF5A/T4+s20hRmh2ZFCb6OYJkg9i2j9Bpnuf6PwWfLaurY7tQq175galNxNugazqjpd86qIfeFg2X0YMvoOZbYM9jCcUOy4BDVZbBxKy03Z3qHzBGSpvi1AsrzVmLhEfAac3z3RmO0qTXr2t+q7wDeR8VAGG7DIbqME7vgBi32xdvmdQbMUyTjnmoKp11VHXYTKv7LRz16ImdTImMmhLto4doT5wPa8a2bpzqgRVD38hRiwAeMPsuDQLVOQ==" > /home/sshlogin/.ssh/authorized_keys

#Changing the owner of created file and directory 
chown -R  sshlogin:sshlogin /home/sshlogin/.ssh
chown sshlogin:sshlogin /home/sshlogin/.ssh/authorized_keys


chmod 700 /home/sshlogin/.ssh
chmod 400 /home/sshlogin/.ssh/authorized_keys

#Adding sshlogin to sudoers
cp /etc/sudoers /root/sudoers.bak
echo "sshlogin	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers
#Disable ChallengeResponseAuthentication as it may ask for password and no recommended.
cp /etc/ssh/sshd_config /root/sshd_config.bak
sed -i "/^ChallengeResponseAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config && echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

#Disable password based ssh
sed -i "/^PasswordAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

#Locked Root account it is good practice to use sudo account instead of root login
passwd -dl root

#Restart the ssh dameon
service ssh restart


#Reboot the system
reboot
