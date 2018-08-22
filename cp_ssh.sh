#!/bin/bash

#对端主机的IP列表
host_list='192.168.1.2 192.168.1.3 192.168.1.4 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.8'

#在对端主机过滤出第三列 
user_host=`awk '{print $3}' ~/.ssh/id_rsa.pub`

#循环列表，sshpass代表面交互输入密码，-o后面的参数代表第一次推送密码不会交互式确认输入yes or  no  
for i in $host_list ;do
	sshpass -p '123456' ssh-copy-id -i   /root/.ssh/id_rsa.pub root@$i     -o "StrictHostKeyChecking=no" >&/dev/null 
	ssh $i "grep "$user_host" ~/.ssh/authorized_keys" >&/dev/null  # 判断是否添加本机信息成功
        if [ $? -eq 0 ];then
                echo "$i is ok"
        else
                echo "$i is not ok"
        fi
done

#如果还是要你输入yes or  no  那就创建一个文件/root/.ssh/config 在这里面添加一行  StrictHostKeyChecking=no
