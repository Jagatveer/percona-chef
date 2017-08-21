#
# Cookbook Name:: percona-chef
# Recipe:: client
#
# Author: Jagatveer Singh
# All rights reserved - Do Not Redistribute
#

%w(mysql-libs
   percona-xtrabackup-20
   percona-xtrabackup-21
   mysql55-5.5.42-1.4.amzn1.x86_64
   mysqlclient16-5.1.61-1.ius.el6.x86_64
).each do |pkg|
  bash "removing #{pkg}" do
    code <<-EOF
          rpm --nodeps -e #{pkg} 2> /dev/null
          exit 0
      EOF
    only_if "rpm -qa | grep #{pkg}"
  end
end

bash 'installing percona' do
  code <<-EOF
        rpm -ivh http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
        sed -i 's/$releasever/6/g' /etc/yum.repos.d/percona-release.repo
    EOF
  not_if 'rpm -qa | grep percona-release-0.1-3'
end

# Package perl-DBD-MySQL-4.023-5.17.amzn1.x86_64 is obsoleted by perl-DBD-MySQL55-4.023-5.23.amzn1.x86_64 which is already installed
if node['kernel']['release'][0].to_i >= 4
  dbd_pkg = 'perl-DBD-MySQL55'
else
  dbd_pkg = 'perl-DBD-MySQL'
end

package dbd_pkg do
  action :install
end

%w(perl-DBI
   Percona-Server-client-56
   Percona-Server-devel-56
   Percona-Server-shared-56
   percona-xtrabackup
   percona-toolkit).each do |pkg|
  package pkg do
    action :install
  end
end
