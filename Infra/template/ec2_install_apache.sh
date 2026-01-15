#! /bin/bash
cd /home/ubuntu
sudo apt update -y
sudo apt install python3 python3-flask python3-pymysql git -y
git clone https://github.com/rahulwagh/python-mysql-db-proj-1.git
cd python-mysql-db-proj-1

# Update app.py with correct RDS endpoint
sed -i "s/host='[^']*'/host='${rds_endpoint}'/" app.py
sed -i "s/user='[^']*'/user='${db_username}'/" app.py
sed -i "s/password='[^']*'/password='${db_password}'/" app.py
sed -i "s/db='[^']*'/db='${db_name}'/" app.py

nohup python3 app.py > app.log 2>&1 &