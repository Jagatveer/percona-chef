#
# Cookbook Name:: mysql
# Library:: mysql
#
# Author: Jagatveer Singh
# All rights reserved - Do Not Redistribute
#

class Chef::Recipe::MySQL
  def self.get_cnf_by_ram(name, type, ram_gb)
    suffix = type + '.erb'
    if ram_gb > 36
      return name + '-extralarge.' + suffix
    elsif ram_gb > 20
      return name + '-large.' + suffix
    elsif ram_gb > 8
      return name + '-medium.' + suffix
    else
      return name + '-small.' + suffix
    end
  end

  def self.get_innodb_log_size(cnf)
    value = case cnf
            when 'my-extralarge.cnf.erb' then '768M'
            when 'my-large.cnf.erb' then '768M'
            when 'my-medium.cnf.erb' then '512M'
            when 'my-small.cnf.erb' then '256M'
            else ''
            end
    value
  end
  def self.get_innodb_buffer_pool_size(cnf)
    value = case cnf
            when 'my-extralarge.cnf.erb' then '20G'
            when 'my-large.cnf.erb' then '10G'
            when 'my-medium.cnf.erb' then '4G'
            when 'my-small.cnf.erb' then '256M'
            else ''
            end
    value
  end
  def self.get_key_buffer_size(cnf)
    value = case cnf
            when 'my-extralarge.cnf.erb' then '1300M'
            when 'my-large.cnf.erb' then '800M'
            when 'my-medium.cnf.erb' then '500M'
            when 'my-small.cnf.erb' then '300M'
            else ''
            end
    value
  end
end
