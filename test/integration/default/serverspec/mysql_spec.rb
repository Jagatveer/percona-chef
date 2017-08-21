require 'serverspec'

set :backend, :exec

packages = [
  'perl-DBD-MySQL',
  'perl-DBI',
  'Percona-Server-client-56',
  'Percona-Server-devel-56',
  'Percona-Server-server-56',
  'Percona-Server-shared-56',
  'percona-xtrabackup',
  'percona-toolkit']

packages.each do|p|
  describe package(p) do
    it { should be_installed }
  end
end

describe service('mysql') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(3306) do
  it { should be_listening }
end

describe file('/var/log/mysql-slow.log') do
  it { should be_file }
end

describe file('/etc/my.cnf') do
  it { should be_file }
end

describe file('/root/creds/.mysqlpassword') do
  it { should be_file }
end
