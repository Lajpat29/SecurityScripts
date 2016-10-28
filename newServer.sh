(printf "Creating backup of file /etc/shadow to /root/shadow.bak \n") >> /root/scriptLog.out
cp /etc/shadow /root/shadow.bak
(printf "Done : Creating backup of file /etc/shadow to /root/shadow.bak \n") >> /root/scriptLog.out
(printf "Creating backup of file /etc/passwd to /root/passwd.bak \n") >> /root/scriptLog.out
cp /etc/passwd /root/passwd.bak
(printf "Done : Creating backup of file /etc/passwd to /root/passwd.bak \n") >> /root/scriptLog.out

(printf "Creating backup of file /etc/ssh/sshd_config to /root/sshd_config.bak \n") >> /root/scriptLog.out
cp /etc/ssh/sshd_config /root/sshd_config.bak
(printf "Done : Creating backup of file /etc/ssh/sshd_config to /root/sshd_config.bak \n") >> /root/scriptLog.out
sshlogin_home_dir=/home/sshlogin

if type apt-get > /dev/null 2>&1; then
   (printf "Running apt-get update and upgrade && apt-get install sudo -y \n") >> /root/scriptLog.out
   (apt-get update -y && apt-get upgrade -y && apt-get install sudo vim -y) || { printf 'apt-get failed exiting' >> /root/scriptLog.out ; exit 1; }
   (printf "Done : Running apt-get update and upgrade && apt-get install sudo -y  \n") >> /root/scriptLog.out
elif type yum > /dev/null 2>&1; then
   (printf "Running yum update && yum upgrade && yum install sudo -y \n") >> /root/scriptLog.out
   (yum update && yum upgrade && yum install sudo vim -y) || { printf 'yum failed exiting' >> /root/scriptLog.out ; exit 1; }
   (printf "Done : Running yum update && yum upgrade && yum install sudo -y \n") >> /root/scriptLog.out
fi


cp /etc/sudoers /root/sudoers.bak
#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash

if type echo > /dev/null 2>&1; then
   (printf "Echo command exist hence moving forward. \n") >> /root/scriptLog.out
  else
  (printf "Echo  command  doesn't exist hence terminating. \n") >> /root/scriptLog.error
  exit
fi

#Creating .ssh folder in sshlogin home.
if [ -d "$sshlogin_home_dir" ]; then
    (printf "Making dir /home/sshlogin/.ssh as home folder already exist for sshlogin \n") >> /root/scriptLog.out
    mkdir /home/sshlogin/.ssh
    (printf  "Done making .ssh folder for sshlogin status $? \n")  >> /root/scriptLog.out
    else
    (printf "making home folder for sshlogin user as it doesnot exist. \n")   >> /root/scriptLog.out
    mkdir -p /home/sshlogin/.ssh
    (printf "Done making home folder. Status : $? \n")   >> /root/scriptLog.out
    chown -R  sshlogin:sshlogin /home/sshlogin
    (printf "Done : Changing permission of home folder of sshlogin status : $? \n")   >> /root/scriptLog.out
fi


passwd -d sshlogin 
(printf "Deleting password for sshlogin Status : $? \n")   >> /root/scriptLog.out

passwd -l sshlogin
(printf "Done : Locking sshlogin Status : $? \n")   >> /root/scriptLog.out
passwd -d root 
(printf "Done : Deleting password for root Status : $? \n")   >> /root/scriptLog.out

passwd -l root
(printf "Done : Locking root Status : $? \n")   >> /root/scriptLog.out

#Copying the ssh-key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0LqN37iQSYELGgRMjKH4x5jvNEy4lpd9lLUSufVuT0fmwu7URfKPuFrmIObEiwwQ3pvYzgL8mKsiGMDv1fkB1sQ3XghCGe+Pfnv3prMgZ1iu4ibKc/8yQ6QAPwsB/T9FQSwm3NlPvq8X2Y4ZIeshf+6g+15/vBE7tZW0GJ2txooDf3E2sY4uLPNnkx/TsNhYN4VD5YVNHr5wgk+ephJCxgQwBB6ciqcVU5e9tXfAVhvnNhYI61GbVYvrRrnXFiVyPaWdTx/P0AdZLCuh6KL2lpVnjdetG5OgZ8wsliBiOJZ/LjxyD4LkpeGCpjn0mM7UxQqTjiSL/KyMAul++H2KDazrzH0buXgAsfPUUbSzeu+7xi1EEezu9VRrluTLDIwui79IwZi6EsRBQZfIjWSUanXHwyYHu6RltFTWckGP4qVmHkY2mA0e1UeMbnfcJ1XTGxnmv0tFoO5rVrT46sJoyBRnPYsbQrqzq2TuycCF32Vvms9eNjP4grmQSbqQcjFFcnfpU/sFKg35C3KKCeJ3I3s3ADT3/YQ9iaPgqDBLugXxocMwGxq5R/uMN2f8Yynmd8Bi+HBV8FEQTHFfdSUcmHnGk9CAUbkTQxdR+yK2zPCuiPROvk5FOnJkr6s10L98CAsmh/U3LmCXmHQq50MHCM0xH9nip3sjs/Ch54xTlQw==" > /home/sshlogin/.ssh/authorized_keys


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
sed -i "/^ListenAddress.*/d" /etc/ssh/sshd_config
sed -i "/^PermitRootLogin[[:space:]][Yes|yes|no|without\-password].*/d" /etc/ssh/sshd_config


(printf "\nsshlogin\tALL=(ALL)\tNOPASSWD:ALL\n") >> /etc/sudoers
(printf "\nChallengeResponseAuthentication no\nPasswordAuthentication no\nAllowUsers sshlogin\n") >> /etc/ssh/sshd_config
(printf "\nDenyUsers root admin nobody\nDenyGroups root admin sudo nobody\nPermitRootLogin no\n") >> /etc/ssh/sshd_config

#Restarting sshd daemon
service ssh status
