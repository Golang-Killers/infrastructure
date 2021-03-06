#!/usr/bin/env tcsh

echo installing core packages
rm /etc/motd
pkg update -f
pkg install -y fish git mercurial htop ripgrep rsync

echo installing Go
setenv GOVERSION `curl -Ss 'https://golang.org/VERSION?m=text'`
wget -q https://storage.googleapis.com/golang/$GOVERSION.freebsd-amd64.tar.gz
tar -C /usr/local -xzf $GOVERSION.freebsd-amd64.tar.gz
rm $GOVERSION.freebsd-amd64.tar.gz

echo setting up user pb
sed -i.bak 's/^# %wheel ALL=(ALL) NOPASSWD: ALL$/%wheel ALL=(ALL) NOPASSWD: ALL/g' /usr/local/etc/sudoers
pw useradd pb -m -d /usr/home/pb -g wheel -s /usr/local/bin/fish -w no
mkdir -p /usr/home/pb/.ssh
chown -R pb:wheel /usr/home/pb/.ssh
cp .ssh/authorized_keys /usr/home/pb/.ssh
chown pb:wheel /usr/home/pb/.ssh/authorized_keys

echo disabling root SSH login
sed -i.bak 's/^PermitRootLogin .*$/PermitRootLogin no/' /etc/ssh/sshd_config
service sshd restart

echo cleaning up
rm root.sh

