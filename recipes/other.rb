#
# Cookbook:: virtualminLEMP
# Recipe:: default
#
# Copyright:: 2020, Asdrubal Gonzalez Penton, All Rights Reserved.
host_name = node['fqdn']
# Update the system
slack_notify 'begin_provision' do
  message "The provision start in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  # not_if { node['im_boring'] }
end

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
  # notifies :create, 'yum_repository[remi]', :immediately
  # notifies :create, 'yum_repository[remi-remi]', :immediately
end

yum_repository 'remi' do
  description                "Remi's RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/remi/mirror'
  action                     :add
  # action                     :nothing
end

yum_repository 'remi-safe' do
  description                "Remi's RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/remi/mirror'
  action                     :add
  # action                     :nothing
end

yum_repository 'remi-php73' do
  description                "Remi's PHP 7.3 RPM repository for Enterprise Linux 7 - $basearch"
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi'
  mirrorlist                 'http://cdn.remirepo.net/enterprise/7/php73/mirror'
  action                     :add
  # action                     :nothing
end

yum_repository 'nginx-stable' do
  description                'nginx stable repo'
  enabled                    true
  fastestmirror_enabled      true
  gpgcheck                   true
  gpgkey                     'https://nginx.org/keys/nginx_signing.key'
  baseurl                    'http://nginx.org/packages/centos/$releasever/$basearch/'
  action                     :add
  # action                     :nothing
  # # TODO: module_hotfixes=true
  notifies :run, 'execute[yum update -y]', :immediately
end

%w[perl unzip net-tools perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph git].each do |pre|
  yum_package pre do
    action :install
    notifies :notify, 'slack_notify[end_preparation]', :immediately
  end
end

slack_notify 'end_preparation' do
  message "The preparation is done, let's setup the Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end

remote_file '/opt/install.sh' do
  source 'http://software.virtualmin.com/gpl/scripts/install.sh'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  # notifies :run, 'execute[sh /tmp/install.sh -f]', :immediately
  # notifies :create, 'yum_repository[remi-remi]', :immediately
end

execute 'install_virtuamin' do
  command 'sh /opt/install.sh -f --bundle LEMP'
  cwd '/opt'
  action :run
  notifies :notify, 'slack_notify[virtualmin_installed]', :immediately
end
slack_notify 'virtualmin_installed' do
  message "Virtualmin is Installed in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end

remote_file '/opt/csf.tgz' do
  source 'https://download.configserver.com/csf.tgz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create_if_missing
  notifies :run, 'execute[unzip_csf]', :immediately
end

execute 'unzip_csf' do
  command 'tar -xzf /opt/csf.tgz -C /opt/'
  cwd '/opt'
  action :run
  notifies :run, 'execute[install_csf]', :immediately
end

execute 'install_csf' do
  command 'sh /opt/csf/install.sh'
  cwd '/opt/csf/'
  action :run
end

template '/etc/csf/csf.conf' do
  source 'csf.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
  variables(
    tcp_in: node['virtualminLEMP']['csf']['TCP_IN'],
    udp_in: node['virtualminLEMP']['csf']['UDP_IN'],
    tcp6_in: node['virtualminLEMP']['csf']['TCP6_IN'],
    udp6_in: node['virtualminLEMP']['csf']['UDP6_IN'],
    restrict_logs: node['virtualminLEMP']['csf']['RESTRICT_SYSLOG'],
    check_logs: node['virtualminLEMP']['csf']['SYSLOG_CHECK'],
    date: node['virtualminLEMP']['date']
  )
end
service 'csf' do
  action %i(start enable)
  notifies :run, 'execute[yum update -y]', :immediately
  notifies :notify, 'slack_notify[csf_installed]', :immediately
end
slack_notify 'csf_installed' do
  message "Csf is Installed in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end
# echo "Installing CSF webmin module"
execute 'webmin_module' do
  command '/usr/libexec/webmin/install-module.pl /usr/local/csf/csfwebmin.tgz'
  action :run
end

%w[php-mysql php-gd php-fpm php-pear php-mcrypt php-intl php-ctype php-curl php-dom php-hash php-iconv php-mbstring php-openssl php-pdo_mysql php-simplexml php-soap php-xsl php-zip php-libxml].each do |phpmod|
  yum_package phpmod do
    action :install
  end
end
%w[httpd-devel libtool mailx redis ccze htop vim glances].each do |extra|
  yum_package extra do
    action :install
  end
end
template '/etc/php.ini' do
  source 'php.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    open_tag: node['virtualminLEMP']['php']['short_open_tag'],
    disable_functions: node['virtualminLEMP']['php']['disable_functions'],
    memory_limit: node['virtualminLEMP']['php']['memory_limit'],
    post_max_size: node['virtualminLEMP']['php']['post_max_size'],
    upload_max_filesize: node['virtualminLEMP']['php']['upload_max_filesize']
  )
end

# service 'httpd' do
#   subscribes :restart, 'file[/etc/php.ini]', :immediately
#   subscribes :restart, 'file[/etc/httpd/conf.d/cloudflare.conf]', :immediately
# end

service 'php-fpm' do
  subscribes :restart, 'file[/etc/php.ini]', :immediately
  notifies :notify, 'slack_notify[php_configured]', :immediately
end
slack_notify 'php_configured' do
  message "php is Configured in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
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
  notifies :run, 'execute[add_cloudflare_ips]', :immediately
end

execute 'add_cloudflare_ips' do
  cwd '/opt/scripts'
  command 'sh cloudflare_ips.sh'
  action :nothing
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    user: node['virtualmin']['nginx']['user'],
    w_processes: node['virtualmin']['nginx']['worker_processes'],
    error_log: node['virtualmin']['nginx']['error_log'],
    error_type: node['virtualmin']['nginx']['error_log_type'],
    w_conns: node['virtualmin']['nginx']['worker_connections'],
    sendfile: node['virtualmin']['nginx']['sendfile'],
    l_subrequest: node['virtualmin']['nginx']['log_subrequest'],
    tcp_nopush: node['virtualmin']['nginx']['tcp_nopush'],
    tcp_nodelay: node['virtualmin']['nginx']['tcp_nodelay'],
    etag: node['virtualmin']['nginx']['etag'],
    kl_timeout: node['virtualmin']['nginx']['keepalive_timeout'],
    types_hash_max_size: node['virtualmin']['nginx']['types_hash_max_size'],
    resolver: node['virtualmin']['nginx']['resolver'],
    gzip: node['virtualmin']['nginx']['gzip'],
    server_tokens: node['virtualmin']['nginx']['server_tokens'],
    fastcgi_read_timeout: node['virtualmin']['nginx']['fastcgi_read_timeout'],
    cf_ips: node['virtualmin']['nginx']['cloudflare_ips']
  )
end
service 'nginx' do
  action :nothing
  subscribes :restart, 'file[/etc/nginx/nginx.conf]', :immediately
  notifies :notify, 'slack_notify[nginx_configured]', :immediately
end
slack_notify 'nginx_configured' do
  message "NGINX is Configured in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end

execute 'echo "root: incidents@studio-one.am" >> /etc/aliases'
execute 'newaliases'

cron 'clamscan_report' do
  action :create
  minute '0'
  hour '0'
  day '*'
  month '*'
  weekday '*'
  user 'root'
  mailto 'incidents@studio-one.am'
  command 'clamscan -i -r * / 2>&1 | mail -s "CRON CLAMSCAN" incidents@studio-one.am'
end
cron 'cloudflare_ips' do
  action :create
  minute '0'
  hour '04'
  day '*'
  month '*'
  weekday '*'
  user 'root'
  home '/opt/scripts'
  mailto 'incidents@studio-one.am'
  command 'sh /opt/scripts/cloudflare_ips.sh'
  notifies :notify, 'slack_notify[end_setup]', :immediately
end
slack_notify 'end_setup' do
  message "The Setup is done, let's clean the Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end

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
# end

# Deleting all remains to clean the system.
file '/opt/csf.tgz' do
  action :delete
end

file '/opt/install.sh' do
  action :delete
end

file '/opt/composer.phar' do
  action :delete
end

file '/opt/composer-setup.php' do
  action :delete
end

directory '/opt/csf' do
  recursive true
  action :delete
  notifies :run, 'execute[yum update -y]', :immediately
  notifies :notify, 'slack_notify[end_provision]', :immediately
end
slack_notify 'end_provision' do
  message "The provision is done in Server #{host_name}"
  webhook_url 'https://hooks.slack.com/services/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'
  action :nothing
end
