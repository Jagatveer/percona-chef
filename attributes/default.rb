# PXC
default['mysql']['wsrep_cluster_address'] = ''
default['mysql']['wsrep_node_name'] = 'mysql'
default['mysql']['wsrep_data_dir'] = '/mnt/data'

# MySQL
default['mysql']['innodb_log_file_size'] = false
default['mysql']['xtrabackup_path'] = '/disk1/mysql/backups/'
default['mysql']['xtrabackup_base'] = '/disk1/mysql/backup10'
default['mysql']['xtrabackup_archive'] = '/disk1/mysql/Archive'
default['mysql']['xtrabackup_mysql_bak'] = '/disk1/mysql_bak'
default['mysql']['xtrabackup_script_path'] = '/opt/xtrabackup/'
default['mysql']['key_buffer_size'] = false
default['mysql']['innodb_buffer_pool_size'] = false
