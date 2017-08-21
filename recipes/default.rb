#
# Cookbook Name:: percona-chef
# Recipe:: default
#
# Author: Jagatveer Singh
# All rights reserved - Do Not Redistribute
#
# https://www.percona.com/forums/questions-discussions/mysql-and-percona-server/percona-server-5-6/22586-yum-repository-seems-to-be-broken

include_recipe 'mysql::client'

package 'Percona-Server-server-56' do
  action :install
end

# Calclutate Amount of RAM present from OHAI plugin
ram_gb  = node['memory']['total'][0..-3].to_f / 1_024_000
my_cnf_file = MySQL.get_cnf_by_ram('my', 'cnf', ram_gb)

bash 'Create mysql slow query log file' do
  not_if { File.exist?('/var/log/mysql-slow.log') }
  code <<-EOH
        set -e
        touch /var/log/mysql-slow.log
        chown mysql.mysql /var/log/mysql-slow.log
        chmod 755 /var/log/mysql-slow.log
    EOH
end

if (node['mysql']['innodb_log_file_size'] == false)
  innodb_log_file_size = MySQL.get_innodb_log_size(my_cnf_file)
else
  innodb_log_file_size = node['mysql']['innodb_log_file_size']
end

if (node['mysql']['innodb_buffer_pool_size'] == false)
  innodb_buffer_pool_size = MySQL.get_innodb_buffer_pool_size(my_cnf_file)
else
  innodb_buffer_pool_size = node['mysql']['innodb_buffer_pool_size']
end

if (node['mysql']['key_buffer_size'] == false)
  key_buffer_size = MySQL.get_key_buffer_size(my_cnf_file)
else
  key_buffer_size = node['mysql']['key_buffer_size']
end

template '/etc/my.cnf' do
  source my_cnf_file
  variables(innodb_log_file_size: innodb_log_file_size,
            innodb_buffer_pool_size: innodb_buffer_pool_size,
            key_buffer_size: key_buffer_size
           )
end

service 'mysql' do
  action [:enable, :start]
end

# Assigning a Secure Password to MySQL
bash 'Generate MySql Password' do
  not_if { File.exist?('/root/creds/.mysqlpassword') }
  code <<-EOH
        set -e
        mysql_password=$(date +%s | sha256sum | base64 | head -c 15 ; echo)
        mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('$mysql_password') WHERE User='root';FLUSH PRIVILEGES;"
        echo $mysql_password > '/root/creds/.mysqlpassword'
        EOH
end

bash 'clearing the unrequired stuff from percona' do
  code <<-EOH
        mysql -u root -p$(cat /root/creds/.mysqlpassword) -e 'DELETE FROM mysql.user WHERE User="";'
        mysql -u root -p$(cat /root/creds/.mysqlpassword) -e 'DELETE FROM mysql.user WHERE User="root" AND Host NOT IN ("localhost", "127.0.0.1", "::1");'
        mysql -u root -p$(cat /root/creds/.mysqlpassword) -e 'DROP DATABASE test;'
        mysql -u root -p$(cat /root/creds/.mysqlpassword) -e 'FLUSH PRIVILEGES;'
    EOH
end
