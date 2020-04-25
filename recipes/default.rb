# frozen_string_literal: true

# Cookbook:: magento
# Recipe:: default
#
# Copyright:: 2020, Asdrubal Gonzalez Penton, All Rights Reserved.

# host_name = node['fqdn']

# Update the system

execute 'yum update -y' do
  action :run
  ignore_failure true
end

# Install EPEL Repo and wget for get some scripts
%w[epel-release wget].each do |pkg|
  yum_package(pkg) do
    action :install
  end
end

# get the gpgkey to the node.
remote_file '/etc/pki/rpm-gpg/RPM-GPG-KEY-remi' do
  source 'https://rpms.remirepo.net/RPM-GPG-KEY-remi'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

yum_repository 'remi' do
  description                "Remi's RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/remi/mirror'
  action                     :add
end

yum_repository 'remi-safe' do
  description                "Remi's RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/remi/mirror'
  action                     :add
end

yum_repository 'remi-php72' do
  description                "Remi's PHP 7.2 RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/php72/mirror'
  action                     :add
end
# remote_file '/opt/rabbitmq-release-signing-key.asc' do
#   source 'https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc'
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
#   # notifies :install, 'execute[rabbitmq_key]', :immediately
# end
#
# execute 'rpm --import /opt/rabbitmq-release-signing-key.asc'

yum_repository 'bintray-rabbitmq-server' do
  description 'bintray-rabbitmq-rpm'
  enabled true
  # gpgkey 'https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc'
  gpgcheck false
  baseurl 'https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.8.x/el/7/'
end

remote_file '/opt/mysql80-community-release-el7-3.noarch.rpm' do
  source 'https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :install, 'rpm_package[mysql_community]', :immediately
end
rpm_package 'mysql_community' do
  package_name 'mysql80-community-release-el7-3.noarch.rpm'
  source '/opt/mysql80-community-release-el7-3.noarch.rpm'
  action :nothing
  notifies :install, 'yum_package[mysql-community-server]', :immediately
end

yum_package 'mysql-community-server' do
  action :nothing
end
# rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
# [bintray-rabbitmq-server]
# name=bintray-rabbitmq-rpm
# baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.8.x/el/7/
# gpgcheck=0
# repo_gpgcheck=0
# enabled=1

# yum_repository 'mariadb' do
#   description 'MariaDB 10.3 CentOS repository'
#   enabled true
#   gpgkey 'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
#   gpgcheck true
#   baseurl 'http://yum.mariadb.org/10.3/centos7-amd64'
# end

# mysql 5.7 https://downloads.mysql.com/archives/get/p/23/file/mysql-community-server-5.7.28-1.el7.x86_64.rpm
# mysql 8 https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-server-8.0.19-1.el7.x86_64.rpm
# Signature Checking Using RPM
# rpm --checksig package_name.rpm
# mysql repo https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
# mysql apt repo https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb

yum_repository 'nginx-stable' do
  description                'nginx stable repo'
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'https://nginx.org/keys/nginx_signing.key'
  baseurl                    'http://nginx.org/packages/centos/$releasever/$basearch/'
  action                     :add
  # # TODO: module_hotfixes=true
  notifies :run, 'execute[yum update -y]', :immediately
  notifies :install, 'yum_package[nginx]', :immediately
end

yum_package 'nginx' do
  action :install
end

# %w[unzip net-tools git gzip lsof mysqldump nice sed tar].each do |deps|
%w[unzip net-tools git gzip lsof zip libtool mailx ccze htop vim glances].each do |deps|
  yum_package deps do
    action :install
    # notifies :notify, 'slack_notify[end_preparation]', :immediately
  end
end

%w[perl perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph].each do |perlp|
  yum_package perlp do
    action :install
    # notifies :notify, 'slack_notify[end_preparation]', :immediately
  end
end

# slack_notify 'end_preparation' do
#   message "The preparation is done, let's setup the Server #{host_name}"
#   webhook_url 'https://hooks.slack.com/services/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'
#   action :nothing
# end

group 'magento' do
  action :create
  # members 'magento'
  # append true
end

user 'magento' do
  comment 'the user for magento site'
  uid 1001
  gid 'magento'
  home '/home/magento'
  manage_home true
  shell '/bin/bash'
  action :create
  # password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end
group 'nginx' do
  action :modify
  members 'magento'
  append true
end

%w[php-mysql php-gd php-fpm php-pear php-bcmath php-mcrypt php-intl php-ctype php-curl php-dom php-hash php-iconv php-mbstring php-openssl php-pdo_mysql php-simplexml php-soap php-xsl php-zip php-libxml].each do |phpmod|
  yum_package phpmod do
    action :install
  end
end

# %w[httpd-devel libtool mailx redis ccze htop vim glances].each do |extra|
#   yum_package extra do
#     action :install
#   end
# end

template '/etc/php.ini' do
  source 'php.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    open_tag: node['magento']['php']['short_open_tag'],
    disable_functions: node['magento']['php']['disable_functions'],
    memory_limit: node['magento']['php']['memory_limit'],
    post_max_size: node['magento']['php']['post_max_size'],
    upload_max_filesize: node['magento']['php']['upload_max_filesize']
  )
end

service 'php-fpm' do
  subscribes :restart, 'file[/etc/php.ini]', :immediately
  # notifies :notify, 'slack_notify[php_configured]', :immediately
end

remote_file '/opt/composer-setup.php' do
  source 'https://getcomposer.org/installer'
  owner 'root'
  group 'root'
  action :create_if_missing
end

execute 'create_installer' do
  cwd '/opt'
  command 'php /opt/composer-setup.php --quiet'
end

remote_file 'install_composer' do
  path '/usr/local/bin/composer'
  source 'file:///opt/composer.phar'
  owner 'root'
  group 'root'
  mode '0777'
end

execute 'mkdir /opt/scripts' do
  action :run
  not_if { Dir.exist?('/opt/scripts') }
end

cookbook_file '/opt/scripts/cloudflare_ips.sh' do
  source 'cloudflare_ips.sh'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  # notifies :run, 'execute[add_cloudflare_ips]', :immediately
end

# execute 'add_cloudflare_ips' do
#   cwd '/opt/scripts'
#   command 'sh cloudflare_ips.sh'
#   action :nothing
# end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    user: node['magento']['nginx']['user'],
    w_processes: node['magento']['nginx']['worker_processes'],
    error_log: node['magento']['nginx']['error_log'],
    error_type: node['magento']['nginx']['error_log_type'],
    w_conns: node['magento']['nginx']['worker_connections'],
    sendfile: node['magento']['nginx']['sendfile'],
    l_subrequest: node['magento']['nginx']['log_subrequest'],
    tcp_nopush: node['magento']['nginx']['tcp_nopush'],
    tcp_nodelay: node['magento']['nginx']['tcp_nodelay'],
    etag: node['magento']['nginx']['etag'],
    kl_timeout: node['magento']['nginx']['keepalive_timeout'],
    types_hash_max_size: node['magento']['nginx']['types_hash_max_size'],
    resolver: node['magento']['nginx']['resolver'],
    gzip: node['magento']['nginx']['gzip'],
    server_tokens: node['magento']['nginx']['server_tokens'],
    fastcgi_read_timeout: node['magento']['nginx']['fastcgi_read_timeout'],
    cf_ips: node['magento']['nginx']['cloudflare_ips']
  )
end

service 'nginx' do
  action :nothing
  subscribes :restart, 'file[/etc/nginx/nginx.conf]', :immediately
  # notifies :notify, 'slack_notify[nginx_configured]', :immediately
end
#
directory '/root/.composer' do
  owner 'magento'
  group 'magento'
  mode '0755'
  action :create
end

cookbook_file '/root/.composer/auth.json' do
  source 'auth.json'
  owner 'magento'
  group 'magento'
  mode '0755'
  action :create
end
directory '/home/magento/public' do
  owner 'magento'
  group 'magento'
  mode '0755'
  action :create
end
# To get the Magento metapackage:
# https://magento.com/tech-resources/downloads/index/download/file_id/2876/category_id/2341/
execute 'install_magento' do
  cwd '/home/magento/public'
  command 'php -d max_execution_time=21600 /usr/local/bin/composer create-project --no-progress --repository-url=https://repo.magento.com/ magento/project-community-edition /home/magento/public'
  not_if { File.exist?('/home/magento/public/composer.json') }
end
# magento install  composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition <install-directory-name>

# You must set read-write permissions for the web server group
# cd /var/www/html/<magento install directory>
# %w[pub/static pub/media app/etc]
# find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
execute 'file_permitions' do
  cwd '/home/magento'
  command 'find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +'
end
execute 'dir_permitions' do
  cwd '/home/magento'
  command 'find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +'
end
execute 'dir_permitions' do
  cwd '/home/magento'
  command 'chmod u+x bin/magento'
end

# find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
# chown -R :www-data . # Ubuntu
# chmod u+x bin/magento

# installing Magento Command line
# bin/magento setup:install \
# --base-url=http://localhost/magento2ee \
# --db-host=localhost \
# --db-name=magento \
# --db-user=magento \
# --db-password=magento \
# --admin-firstname=admin \
# --admin-lastname=admin \
# --admin-email=admin@admin.com \
# --admin-user=admin \
# --admin-password=admin123 \
# --language=en_US \
# --currency=USD \
# --timezone=America/Chicago \
# --use-rewrites=1
# --amqp-host="<hostname>" --amqp-port="5672" --amqp-user="<user_name>" --amqp-password="<password>" --amqp-virtualhost="/"

# remote_file '/opt/install.sh' do
#   source 'http://software.virtualmin.com/gpl/scripts/install.sh'
#   owner 'root'
#   group 'root'
#   mode '0777'
#   action :create
# end
#
# execute 'install_virtuamin' do
#   command 'sh /opt/install.sh -f --bundle LEMP'
#   cwd '/opt'
#   action :run
#   # notifies :notify, 'slack_notify[virtualmin_installed]', :immediately
# end

# slack_notify 'virtualmin_installed' do
#   message "Virtualmin is Installed in Server #{host_name}"
#   webhook_url 'https://hooks.slack.com/services/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'
#   action :nothing
# end

# remote_file '/opt/csf.tgz' do
#   source 'https://download.configserver.com/csf.tgz'
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create_if_missing
#   notifies :run, 'execute[unzip_csf]', :immediately
# end
#
# execute 'unzip_csf' do
#   command 'tar -xzf /opt/csf.tgz -C /opt/'
#   cwd '/opt'
#   action :run
#   notifies :run, 'execute[install_csf]', :immediately
# end
#
# execute 'install_csf' do
#   command 'sh /opt/csf/install.sh'
#   cwd '/opt/csf/'
#   action :run
# end
#
# template '/etc/csf/csf.conf' do
#   source 'csf.conf.erb'
#   mode '0600'
#   owner 'root'
#   group 'root'
#   variables(
#     tcp_in: node['magento']['csf']['TCP_IN'],
#     udp_in: node['magento']['csf']['UDP_IN'],
#     tcp6_in: node['magento']['csf']['TCP6_IN'],
#     udp6_in: node['magento']['csf']['UDP6_IN'],
#     restrict_logs: node['magento']['csf']['RESTRICT_SYSLOG'],
#     check_logs: node['magento']['csf']['SYSLOG_CHECK'],
#     date: node['magento']['date']
#   )
# end
#
# service 'csf' do
#   action %i(start enable)
#   notifies :run, 'execute[yum update -y]', :immediately
#   # notifies :notify, 'slack_notify[csf_installed]', :immediately
# end
#
# # slack_notify 'csf_installed' do
# #   message "Csf is Installed in Server #{host_name}"
# #   webhook_url 'https://hooks.slack.com/services/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'
# #   action :nothing
# # end
#
# # echo "Installing CSF webmin module"
# execute 'webmin_module' do
#   command '/usr/libexec/webmin/install-module.pl /usr/local/csf/csfwebmin.tgz'
#   action :run
# end
#

# #
# # slack_notify 'php_configured' do
# #   message "php is Configured in Server #{host_name}"
# #   webhook_url 'https://hooks.slack.com/services/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'
# #   action :nothing
# # end
#

# # slack_notify 'nginx_configured' do
# #   message "NGINX is Configured in Server #{host_name}"
# #   webhook_url 'https://hooks.slack.com/services/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'
# #   action :nothing
# # end
#
# %w[MariaDB-server MariaDB-client].each do |maria|
#   yum_package maria do
#     action :install
#   end
# end
#
# template '/etc/my.cnf' do
#   source 'my.cnf.erb'
#   mode '0644'
#   owner 'root'
#   group 'root'
#   variables(
#     datadir: node['magento']['mysql']['datadir'],
#     log_error: node['magento']['mysql']['log-error'],
#     s_lnk: node['magento']['mysql']['symbolic-links'],
#     max_conn: node['magento']['mysql']['max_connections'],
#     perf_schema: node['magento']['mysql']['performance_schema'],
#     sqry_log: node['magento']['mysql']['slow-query-log'],
#     sqry_log_file: node['magento']['mysql']['slow-query-log-file'],
#     long_query_time: node['magento']['mysql']['long_query_time'],
#     query_size: node['magento']['mysql']['query_cache_size'],
#     query_type: node['magento']['mysql']['query_cache_type'],
#     query_limit: node['magento']['mysql']['query_cache_limit'],
#     join_buffer_size: node['magento']['mysql']['join_buffer_size'],
#     thread_cache_size: node['magento']['mysql']['thread_cache_size'],
#     read_rnd_buffer_size: node['magento']['mysql']['read_rnd_buffer_size'],
#     read_buffer_size: node['magento']['mysql']['read_buffer_size'],
#     sort_buffer_size: node['magento']['mysql']['sort_buffer_size'],
#     key_buffer_size: node['magento']['mysql']['key_buffer_size'],
#     innodb_f_p_table: node['magento']['mysql']['innodb_file_per_table'],
#     innodb_p_size: node['magento']['mysql']['innodb_buffer_pool_size'],
#     innodb_p_instances: node['magento']['mysql']['innodb_buffer_pool_instances'],
#     innodb_ft_min_token_size: node['magento']['mysql']['innodb-ft-min-token-size'],
#     innodb_ft_enable_stopword: node['magento']['mysql']['innodb_ft_enable_stopword'],
#     ft_min_word_len: node['magento']['mysql']['ft_min_word_len'],
#     ft_stopword_file: node['magento']['mysql']['ft_stopword_file']
#     # innodb_log_file_size = 2G
#   )
# end
#
# service 'mariadb' do
#   action %i(start enable)
# end
#
# execute 'mkdir /opt/scripts' do
#   action :run
#   not_if { Dir.exist?('/opt/scripts') }
# end
# cookbook_file '/opt/scripts/cloudflare_ips.sh' do
#   source 'cloudflare_ips.sh'
#   owner 'root'
#   group 'root'
#   mode '0777'
#   action :create
# end
#
# execute 'echo "root: incidents@studio-one.am" >> /etc/aliases'
#
# execute 'newaliases'
#
# cron 'clamscan_report' do
#   action :create
#   minute '0'
#   hour '0'
#   day '*'
#   month '*'
#   weekday '*'
#   user 'root'
#   mailto 'incidents@studio-one.am'
#   command 'clamscan -i -r * / 2>&1 | mail -s "CRON CLAMSCAN" incidents@studio-one.am'
# end
#
# cron 'cloudflare_ips' do
#   action :create
#   minute '0'
#   hour '04'
#   day '*'
#   month '*'
#   weekday '*'
#   user 'root'
#   home '/opt/scripts'
#   mailto 'incidents@studio-one.am'
#   command 'sh /opt/scripts/cloudflare_ips.sh'
#   # notifies :notify, 'slack_notify[install_netdata]', :immediately
# end
# #
# # slack_notify 'install_netdata' do
# #   message "Installation of netdata is starting in the Server #{host_name}"
# #   webhook_url 'https://hooks.slack.com/services/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'
# #   action :nothing
# # end
#
# remote_file '/opt/kickstart.sh' do
#   source 'https://my-netdata.io/kickstart.sh'
#   owner 'root'
#   group 'root'
#   mode '0777'
#   action :create_if_missing
#   notifies :run, 'execute[install_netdata]', :immediately
#   # notifies :create, 'yum_repository[remi-remi]', :immediately
# end
#
# execute 'install_netdata' do
#   command 'sh /opt/kickstart.sh  --dont-wait --non-interactive'
#   cwd '/opt'
#   user 'root'
#   action :run
#   # notifies :notify, 'slack_notify[end_setup]', :immediately
# end
#
# # slack_notify 'end_setup' do
# #   message "The Setup is done, let's clean the Server #{host_name}"
# #   webhook_url 'https://hooks.slack.com/services/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'
# #   action :nothing
# # end
# # Deleting all remains to clean the system.
# file '/opt/csf.tgz' do
#   action :delete
# end
#
# file '/opt/install.sh' do
#   action :delete
# end
#
# file '/opt/composer.phar' do
#   action :delete
# end
#
# file '/opt/composer-setup.php' do
#   action :delete
# end
#
# directory '/opt/csf' do
#   recursive true
#   action :delete
#   notifies :run, 'execute[yum update -y]', :immediately
#   # notifies :notify, 'slack_notify[end_provision]', :immediately
# end
#
# slack_notify 'end_provision' do
#   message "The provision is done in Server #{host_name}"
#   webhook_url 'https://hooks.slack.com/services/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'
#   action :nothing
# end
