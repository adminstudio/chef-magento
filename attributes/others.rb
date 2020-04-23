# frozen_string_literal: true

default['virtualminLEMP']['date'] = Time.new
default['virtualminLEMP']['csf']['TESTING'] = '"1"'
default['virtualminLEMP']['csf']['RESTRICT_SYSLOG'] = '"3"'
default['virtualminLEMP']['csf']['LF_POP3D'] = '"10"'
default['virtualminLEMP']['csf']['LF_IMAPD'] = '"10"'
default['virtualminLEMP']['csf']['LF_IMAPD'] = '"10"'
default['virtualminLEMP']['csf']['SYSLOG_CHECK'] = '"3600"'
default['virtualminLEMP']['csf']['TCP_IN'] = '"22,80,443,19999"'
default['virtualminLEMP']['csf']['UDP_IN'] = '"53"'
default['virtualminLEMP']['csf']['TCP6_IN'] = '"80,443,19999"'
default['virtualminLEMP']['csf']['UDP6_IN'] = '"53"'

# my.cnf
default['virtualminLEMP']['mysql']['datadir'] = '/var/lib/mysql'
default['virtualminLEMP']['mysql']['socket'] = '/var/lib/mysql/mysql.sock'
default['virtualminLEMP']['mysql']['log-error'] = '/var/log/mariadb/mariadb_error.log'
default['virtualminLEMP']['mysql']['symbolic-links'] = '0'
default['virtualminLEMP']['mysql']['max_connections'] = '700'
default['virtualminLEMP']['mysql']['join_buffer_size'] = '10M'
default['virtualminLEMP']['mysql']['performance_schema'] = 'on'
default['virtualminLEMP']['mysql']['slow-query-log'] = '1'
default['virtualminLEMP']['mysql']['slow-query-log-file'] = '/var/lib/mysql/mysql-slow.log'
default['virtualminLEMP']['mysql']['long_query_time'] = '1'
default['virtualminLEMP']['mysql']['query_cache_size'] = '128M'
default['virtualminLEMP']['mysql']['query_cache_limit'] = '128M'
default['virtualminLEMP']['mysql']['query_cache_type'] = '1'
default['virtualminLEMP']['mysql']['thread_cache_size'] = '8'
default['virtualminLEMP']['mysql']['myisam_sort_buffer_size'] = '64M'
default['virtualminLEMP']['mysql']['read_rnd_buffer_size'] = '8M'
default['virtualminLEMP']['mysql']['read_buffer_size'] = '2M'
default['virtualminLEMP']['mysql']['sort_buffer_size'] = '2M'
default['virtualminLEMP']['mysql']['table_open_cache'] = '1024'
default['virtualminLEMP']['mysql']['max_allowed_packet'] = '32M'
default['virtualminLEMP']['mysql']['key_buffer_size'] = '384M'
default['virtualminLEMP']['mysql']['tmp_table_size'] = '2G'
default['virtualminLEMP']['mysql']['max_heap_table_size'] = '512M'
default['virtualminLEMP']['mysql']['innodb_file_per_table'] = '2'
default['virtualminLEMP']['mysql']['innodb_log_file_size'] = '2G'
default['virtualminLEMP']['mysql']['innodb_buffer_pool_instances'] = '1'
default['virtualminLEMP']['mysql']['innodb-ft-min-token-size'] = '2'
default['virtualminLEMP']['mysql']['innodb_ft_enable_stopword'] = '""'
default['virtualminLEMP']['mysql']['ft_min_word_len'] = '1'
default['virtualminLEMP']['mysql']['ft_stopword_file'] = '""'
# default['virtualminLEMP']['mysql']['innodb_buffer_pool_size'] = ((1024 + (256 * Math.log(19, 2)) * 2) ).
p_mem = node['memory']['total']
men = p_mem[0...-2].to_i / 1024
t_mem = men
default['virtualminLEMP']['mysql']['innodb_buffer_pool_size'] = ((t_mem * 1024 - 2 * (256 + 256 * Math.log2(t_mem)).to_i) / (1.05 * 1024)).to_i
# if(ramValue <= 1) { result = 128; display = result + ' MB'; } else if(ramValue < 32) { var OS= Math.round(256+256*(Math.log2(ramValue))); result = (ramValue*1024-2*OS)/(1.05*1024); if(result < 2) { display = result.toFixed(2) + ' GB'; } else { display = Math.round(result) + ' GB'; } } else { var OS = Math.round(0.05*ramValue*1024); result = (ramValue*1024-2*OS)/(1.05*1024); display = Math.round(result) + ' GB'; }

# php.ini
default['virtualminLEMP']['php']['short_open_tag'] = 'On'
default['virtualminLEMP']['php']['memory_limit'] = '1024M'
default['virtualminLEMP']['php']['post_max_size'] = '128M'
default['virtualminLEMP']['php']['upload_max_filesize'] = '64M'
# default['virtualminLEMP']['php']['disable_functions'] = 'exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source'
default['virtualminLEMP']['php']['disable_functions'] = '""'

# nginx.conf

default['virtualmin']['nginx']['user'] = 'nginx'
default['virtualmin']['nginx']['worker_processes'] = 'auto'
default['virtualmin']['nginx']['error_log'] = '/var/log/nginx/error.log'
default['virtualmin']['nginx']['error_log_type'] = 'warn'
default['virtualmin']['nginx']['worker_connections'] = '2048'
default['virtualmin']['nginx']['access_log'] = '/var/log/nginx/access.log'
default['virtualmin']['nginx']['sendfile'] = 'on'
default['virtualmin']['nginx']['log_subrequest'] = 'on'
default['virtualmin']['nginx']['tcp_nopush'] = 'on'
default['virtualmin']['nginx']['tcp_nodelay'] = 'on'
default['virtualmin']['nginx']['etag'] = 'on'
default['virtualmin']['nginx']['keepalive_timeout'] = '75'
default['virtualmin']['nginx']['types_hash_max_size'] = '2048'
default['virtualmin']['nginx']['resolver'] = '1.1.1.1 valid=30s'
default['virtualmin']['nginx']['gzip'] = 'on'
default['virtualmin']['nginx']['gzip_comp_level'] = '6'
default['virtualmin']['nginx']['gzip_min_length'] = '100'
default['virtualmin']['nginx']['gzip_http_version'] = '1.1'
default['virtualmin']['nginx']['gzip_vary'] = 'on'
default['virtualmin']['nginx']['gzip_proxied'] = 'any'
default['virtualmin']['nginx']['gzip_types'] = 'text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/svg+xml application/x-font-ttf font/opentype image/jpeg image/png'
default['virtualmin']['nginx']['gzip_static'] = 'always'
default['virtualmin']['nginx']['gzip_buffers'] = '16 8k'
default['virtualmin']['nginx']['gzip_disable'] = '“MSIE [1-6].(?!.*SV1)”'
default['virtualmin']['nginx']['server_tokens'] = 'off'
default['virtualmin']['nginx']['fastcgi_read_timeout'] = '600'
default['virtualmin']['nginx']['server_names_hash_bucket_size'] = '128'
default['virtualmin']['nginx']['cloudflare_ips'] = '/etc/nginx/cloudflare.conf'