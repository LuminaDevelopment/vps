#!/bin/bash

apt update && apt upgrade -y

useradd -m -s /bin/bash vpnuser
usermod -aG sudo vpnuser

mkdir -p /home/vpnuser/.ssh
cp /root/.ssh/authorized_keys /home/vpnuser/.ssh/
chown -R vpnuser:vpnuser /home/vpnuser/.ssh
chmod 700 /home/vpnuser/.ssh
chmod 600 /home/vpnuser/.ssh/authorized_keys

cat > /etc/ssh/sshd_config << 'EOL'
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
EOL

systemctl restart ssh
