#
# Cookbook Name:: mysql
# Recipe:: xtrabackup
#
# Author: Jagatveer Singh#
# All rights reserved - Do Not Redistribute
#

directory node['mysql']['xtrabackup_script_path'] do
  action :create
  recursive true
end

directory node['mysql']['xtrabackup_path'] do
  action :create
  recursive true
end

directory node['mysql']['xtrabackup_base'] do
  action :create
  recursive true
end

directory node['mysql']['xtrabackup_archive'] do
  action :create
  recursive true
end

directory node['mysql']['xtrabackup_mysql_bak'] do
  action :create
  recursive true
end

template node['mysql']['xtrabackup_script_path'] + 'backup.sh' do
  source 'backup.sh.erb'
  mode '755'
  variables('xtrabackup_path' => node['mysql']['xtrabackup_path'],
            'xtrabackup_base' => node['mysql']['xtrabackup_base'],
            'archive' => node['mysql']['xtrabackup_archive'])
end

template node['mysql']['xtrabackup_script_path'] + 'restore.sh' do
  source 'restore.sh.erb'
  mode '755'
  variables('xtrabackup_path' => node['mysql']['xtrabackup_path'],
            'xtrabackup_mysql_bak' => node['mysql']['xtrabackup_mysql_bak'])
end
