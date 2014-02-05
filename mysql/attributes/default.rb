# my.cnf default values
default['mysql']['server_charset']                  = 'utf8'
default['mysql']['max_connections']                 = 128
default['mysql']['query_cache_size']                = 0
default['mysql']['table_cache_size']                = 1024
default['mysql']['thread_cache_size']               = 128
default['mysql']['join_buffer_size']                = '16M'
default['mysql']['sort_buffer_size']                = '2M'
default['mysql']['read_rnd_buffer_size']            = '2M'
default['mysql']['innodb_file_per_table']           = true
default['mysql']['innodb_data_file_path']           = 'ibdata1:1G:autoextend'
default['mysql']['innodb_autoextend_increment']     = 64
default['mysql']['innodb_buffer_pool_size']         = '256M'
default['mysql']['innodb_additional_mem_pool_size'] = '10M'
default['mysql']['innodb_write_io_threads']         = 4
default['mysql']['innodb_read_io_threads']          = 4
default['mysql']['innodb_log_buffer_size']          = 16
default['mysql']['innodb_log_file_size']            = '64M'
default['mysql']['innodb_flush_log_at_trx_commit']  = 1

# instruction
default['mysql']['instruction'] = 'x86_64'

# version
default['mysql']['version']       = '5.6'
default['mysql']['minor_version'] = '15-1'

# packages
default['mysql']['rpms'] = {
  'MySQL-server' => {
    'install?' => true,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-server-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-client' => {
    'install?' => true,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-client-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-shared' => {
    'install?' => true,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-shared-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-shared-compat' => {
    'install?' => false,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-shared-compat-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-devel' => {
    'install?' => false,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-devel-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-test' => {
    'install?' => false,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-test-{{full_version}}.el6.{{instruction}}.rpm"
  },
  'MySQL-embedded' => {
    'install?' => false,
    'url'      => "http://dev.mysql.com/get/Downloads/MySQL-{{version}}/MySQL-embedded-{{full_version}}.el6.{{instruction}}.rpm"
  }
}
