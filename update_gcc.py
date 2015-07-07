#!/usr/bin/env python

import paramiko
import threading

def ssh2(ip, username, passwd, cmd):
	try:
		ssh = paramiko.SSHClient()
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		ssh.connect(ip, 22, username, passwd, timeout=5)
		for m in cmd:
			stdin, stdout, stderr = ssh.exec_command(m)
			stdin.write("Y")
			out = stdout.readlines()
			for o in out:
				print o,
		print '%s\t\OK\n' % (ip)
		ssh.close()
	except :
		print '%s\tError\n'%(ip)

if __name__ == '__main__':
	cmd = ['wget http://10.128.161.98/ubuntu/gcc.sh -P /tmp', '/bin/sh -x /tmp/gcc.sh']
	username = "root"
	passwd = "******"
	threads =[1]
	fp=open("./ip.txt","r")
	allines= fp.readlines();
	fp.close();

	print "Begin......"
	for i in allines:
		ip = str(i)
		a = threading.Thread(target=ssh2,args=(ip,username,passwd,cmd))
		a.start()
