


groupadd mygroup


useradd -m -g mygroup myuser


echo "myuser:password123" | chpasswd


usermod -aG sudo myuser


mkdir /home/myuser/mydir
chown myuser:mygroup /home/myuser/mydir


chmod 770 /home/myuser/mydir


id myuser
ls -ld /home/myuser/mydir


