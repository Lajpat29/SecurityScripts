#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash
#Delete the password
passwd -d sshlogin
# Locking down the account i.e disable password
passwd -l sshlogin

#Creating .ssh folder in sshlogin home.
mkdir /home/sshlogin/.ssh

#Copying the ssh-key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDieIRdMqyCMaZ/NjIWCOROn3KTJS3LwQbaFbfzNFMSdFoH3KGTLVQVSmTjrbcMLmkoVEWqk8hruzz6pCfjOGTIoDL/IxPkYYckaz5QB9/Zi3pGUyELxRKEjqpUKzxbTableLeYKtk9RCGezgFMS4AEEJo5RPSSEKnLPryJv16wrIu+ScAkxA5oYr4YhRt0d6oiZtp0Z0e7/tm/0zeFbAmvIL6ZyJircqWKUJN7Q+rHc46E4NEnBG8XosuZSyBMctS4MbBs/jMWf1owUj0sgaw1HuhkfJe2o1NlV/8UPeY2HpXp3SFE8iUpepL+eCK6dvndoSq1FjDHGzpxz7wWGimkS8nk++1BKexCFNtgVsEPlIX2MAlzhNsPip1MIfy8HOKR9EdeOnwvcBQiCQu7Q1CtWzSWMiYqRXnAYR3tyCr3k0b8PiMTqu7aaq9levB1gwzi5z+QMP7cgFVNe0S17w+XtU1mUH9aSMw6/x49fXKXCwv0AJbudm0XG/Q7OM+gtm7J++lTD7cTQ0iVmYiMZqaTxyBNFY+K5mMw6dBkb5wFmuUXldT4nhGMCrKP2K0OBPNuKq9LhW+6TOE5auq0vYX3ns3NDVGHv1dGGkMVi0hUVGe9ZSCdR9EGOtzoYAc63c99QKJhnp5TyuFgFrY05l5r+KCwMr3DwhVCgk6u8b3YeQ==" > /home/sshlogin/.ssh/authorized_keys

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
