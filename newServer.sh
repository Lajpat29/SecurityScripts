cp /etc/shadow /root/shadow.bak
cp /etc/passwd /root/passwd.bak

cp /etc/ssh/sshd_config /root/sshd_config.bak
sshlogin_home_dir=/home/sshlogin
echo_command=echo

apt-get update && apt-get upgrade && apt-get install sudo -y

cp /etc/sudoers /root/sudoers.bak
#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash

if ! type "$echo_command" > /dev/null; then
  (echo -ne "Echo  command  doesn't exist hence terminating.") >> /root/scriptLog.error
  exit
  else
  (echo -ne "Echo command exist hence moving forward.") >> /root/scriptLog.out
fi

#Creating .ssh folder in sshlogin home.
if [ -d "$sshlogin_home_dir" ]; then
    (echo -ne "making dir /home/sshlogin/.ssh as home folder already exist for sshlogin") >> /root/scriptLog.out
    mkdir /home/sshlogin/.ssh
    (echo -ne "Done making .ssh folder for sshlogin status $?")  >> /root/scriptLog.out
    else
    (echo -ne "making home folder for sshlogin user as it doesnot exist.")   >> /root/scriptLog.out
    mkdir -p /home/sshlogin/.ssh
    (echo -ne "Done making home folder status $?")   >> /root/scriptLog.out
    chown -R  sshlogin:sshlogin /home/sshlogin
    (echo -ne "Changing permission of home folder of sshlogin status $?")   >> /root/scriptLog.out
fi


passwd -d sshlogin 
(echo -ne "Deleting password for sshlogin Status $?")   >> /root/scriptLog.out

passwd -l sshlogin
(echo -ne "Locking sshlogin Status $?")   >> /root/scriptLog.out
passwd -d root 
(echo -ne "Deleting password for root Status $?")   >> /root/scriptLog.out

passwd -l root
(echo -ne "Locking root Status $?")   >> /root/scriptLog.out

#Copying the ssh-key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXy0GqyOeGChJSXysL8ennCNtW1ykfBqpj50fRCiAGYDXAVVcxn7TTs9SCPNGgQ6ZKVPOYqwT32Ke6bBlMJgPt2xm0SPmLquhffdCCAy/X+NFFDLs+3DvPJVp9uHv2jvs8NVbhSK7kzo0YG72oRsu9hnYtvMMsxwPS7GOKDoHGt398Sw7tjllyXoRTV3/1mfA0/je4V/7cYGLimigBRYoIlQe8612k6SPQgTQxLLLCzY/OADtHIIAxG/FBEze563Qa6023cDOPId+ZIbblZyLkrDvr8jia0VI+PQx7UE3Lqg9K6bcw8YPsLtMH/dBIqmwo9optnpc0Mw2ZQ8GqIuwH9uxR/tbW0Q9S+JtNVUM53VgZoEKUQQZ1MTGTkjbiGBhjxzZsCTb7UyJqg5LLnilEpFAGLivEtxZ1Tg4wNwlAkQ33gbrGVpIy/k3V9voypynW/8LifLdEnBzmOW7S2/2iRBG7Zq3UGSi0pC/ADx92WnvDYRWJiI5FwZWdLVdmSmywfPwTCpSqxq954VbPLJje8srUU997xA+hZ6vg5d2tRcHvasrT2x0vaY5LJ0e9t5nyOMzYcCZKDxN+BW3GOh2ty9o2KFfdOJMPATOIcL5/0gv1G+jfL+sq19Z1ouE1ZrtVlluB9TzF7OldCw2/+XSPn3+0k5/tSK10vJJZ0Cvonw==" > /home/sshlogin/.ssh/authorized_keys


#Changing the owner of created file and directory 
chown -R  sshlogin:sshlogin /home/sshlogin/.ssh
chown sshlogin:sshlogin /home/sshlogin/.ssh/authorized_keys


chmod 700 /home/sshlogin/.ssh
chmod 400 /home/sshlogin/.ssh/authorized_keys

#Adding sshlogin to sudoers


#Disable ChallengeResponseAuthentication as it may ask for password and no recommended.
sed -i "/^ChallengeResponseAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config
#Disable password based ssh
sed -i "/^PasswordAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config 
sed -i "/^AllowUsers.*/d" /etc/ssh/sshd_config
sed -i "/^DenyUsers.*/d" /etc/ssh/sshd_config 
sed -i "/^DenyGroups.*/d" /etc/ssh/sshd_config
sed -i "/^PermitRootLogin[[:space:]][Yes|yes|no|without\-password].*/d" /etc/ssh/sshd_config


(printf "sshlogin\tALL=(ALL)\tNOPASSWD:ALL\n") >> /etc/sudoers
(printf "ChallengeResponseAuthentication no\nPasswordAuthentication no\nAllowUsers sshlogin\n") >> /etc/ssh/sshd_config
(printf "DenyUsers root admin nobody\nDenyGroups root admin sudo nobody\nPermitRootLogin no\n") >> /etc/ssh/sshd_config

#Reboot the system
reboot
