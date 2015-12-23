#Create new user with name sshlogin with Locked account
useradd -m -c "ssh Login" sshlogin  -s /bin/bash
# Locking down the account i.e disable password
passwd -dl sshlogin

#Creating .ssh folder in sshlogin home.
mkdir /home/sshlogin/.ssh

#Copying the ssh-key
echo "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmkgA+Yq1bGT0uMby/nGJ85E2bHJ+0JL7otW+J7NfIwentGRS22iyCPEFDUninKlm8UHpMjmHaY1/mRXz+y4l/9wnYLaw+ASaGNVikZSRub8EG4qHhnnePPq6JBUiBuQUloVcn6mN/U7KJnT9ym58ELDDPXsFl7lI9iyjs56pHTYXfqWivz2Tn6UNVEMdBmzoMPox680yUcRywN8pLoRy1ZGjBIWCYgAK2AzcK4RYZVQ4VRF8oTrdjb2X3wyijkrfsHYGLfy5sc0hbCfXsMWCUut8QX+6VO0QL9iYcfjbyhG7s8GrW0wjcIWzNWnjcRyFxnkMJwdefMjrAN2zctca7GnQ7eONLJH6Y9hYjtKitx8qBvrxrhlHgNJESrUTWHNxZwkHCigKU9pfR8pbUHue8cKLM1ApVSuR4SZtIozw6hgKIWAUtiVBt/uIxg+I4FjbPNwsZVS7AmEAT4PQjFlT8Uvo9Gs1nddvV7Lst8jXGVx0aflSnlsNgzlN1C4arHKmNVuDbIQVTEkJEp0UIXGZfsidqssUAamnkDuoC9PWKm60A5A5uI5pZRFdcaeabDR3QFkvgp2d2/ZLFpBRaakI6gsPTvOThALikpU6jad9gWmvWPrOdbfQDR9Ye4bLQJBydD52IYIxUzLTVasny2x0fuVJkB9gh/MLoWws8+OD1+Q==" > /home/sshlogin/.ssh/authorized_keys

#Changing the owner of created file and directory 
chown -R  sshlogin:sshlogin /home/sshlogin/.ssh
chown sshlogin:sshlogin /home/sshlogin/.ssh/authorized_keys


chmod 700 /home/sshlogin/.ssh
chmod 400 /home/sshlogin/.ssh/authorized_keys

#Disable ChallengeResponseAuthentication as it may ask for password and no recommended.
sed -i "/^ChallengeResponseAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config && echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config

#Disable password based ssh
sed -i "/^PasswordAuthentication[[:space:]][yes|no].*/d" /etc/ssh/sshd_config && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

#Restart the ssh dameon
service ssh restart

#Reboot the system
reboot
