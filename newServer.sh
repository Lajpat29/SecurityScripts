#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash
#Delete the password
passwd -d sshlogin
# Locking down the account i.e disable password
passwd -l sshlogin

#Creating .ssh folder in sshlogin home.
mkdir /home/sshlogin/.ssh

#Copying the ssh-key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXy0GqyOeGChJSXysL8ennCNtW1ykfBqpj50fRCiAGYDXAVVcxn7TTs9SCPNGgQ6ZKVPOYqwT32Ke6bBlMJgPt2xm0SPmLquhffdCCAy/X+NFFDLs+3DvPJVp9uHv2jvs8NVbhSK7kzo0YG72oRsu9hnYtvMMsxwPS7GOKDoHGt398Sw7tjllyXoRTV3/1mfA0/je4V/7cYGLimigBRYoIlQe8612k6SPQgTQxLLLCzY/OADtHIIAxG/FBEze563Qa6023cDOPId+ZIbblZyLkrDvr8jia0VI+PQx7UE3Lqg9K6bcw8YPsLtMH/dBIqmwo9optnpc0Mw2ZQ8GqIuwH9uxR/tbW0Q9S+JtNVUM53VgZoEKUQQZ1MTGTkjbiGBhjxzZsCTb7UyJqg5LLnilEpFAGLivEtxZ1Tg4wNwlAkQ33gbrGVpIy/k3V9voypynW/8LifLdEnBzmOW7S2/2iRBG7Zq3UGSi0pC/ADx92WnvDYRWJiI5FwZWdLVdmSmywfPwTCpSqxq954VbPLJje8srUU997xA+hZ6vg5d2tRcHvasrT2x0vaY5LJ0e9t5nyOMzYcCZKDxN+BW3GOh2ty9o2KFfdOJMPATOIcL5/0gv1G+jfL+sq19Z1ouE1ZrtVlluB9TzF7OldCw2/+XSPn3+0k5/tSK10vJJZ0Cvonw==" > /home/sshlogin/.ssh/authorized_keys

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

sed -i "/^AllowUsers.*/d" /etc/ssh/sshd_config && echo "AllowUsers sshlogin" >> /etc/ssh/sshd_config

sed -i "/^DenyUsers.*/d" /etc/ssh/sshd_config && echo "DenyUsers root admin nobody" >> /etc/ssh/sshd_config

sed -i "/^DenyGroups.*/d" /etc/ssh/sshd_config && echo "DenyGroups root admin sudo nobody" >> /etc/ssh/sshd_config

sed -i "/^PermitRootLogin[[:space:]][Yes|yes|no|without\-password].*/d" /etc/ssh/sshd_config

echo "PermitRootLogin no" >> /etc/ssh/sshd_config
#Locked Root account it is good practice to use sudo account instead of root login
passwd -d root
passwd -l root


#Reboot the system
reboot
