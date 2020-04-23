# frozen_string_literal: true

# InSpec test for recipe magento::default
# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
describe yum.repo('epel') do
  it { should exist }
  it { should be_enabled }
end

describe yum do
  # its('repos') { should exist }
  its('repos') { should include 'base/7/x86_64' }
  its('repos') { should include 'remi' }
  its('repos') { should include 'remi-safe' }
  # its('repos') { should include 'mariadb' }
  # its('repos') { should include 'virtualmin/7/x86_64' }
end
describe yum.repo('remi') do
  it { should exist }
  it { should be_enabled }
end
describe yum.repo('remi-safe') do
  it { should exist }
  it { should be_enabled }
end
%w[perl unzip net-tools perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph git].each do |pre|
  describe package(pre) do
    it { should be_installed }
  end
end

describe file('/opt/install.sh') do
  it { should_not exist }
  # it { should be_file }
  # it { should be_owned_by 'root' }
  # its('owner') { should eq 'root' }
  # its('mode') { should cmp '0777' }
  # its('type') { should cmp 'file' }
end
describe command('php -v') do
  # its('stdout') { should match 'PHP 7.3./\d{1,2}/' }
  its('stdout') { should match /PHP 7.2.\d{1,2}/ }
end
describe service('webmin') do
  it { should be_installed }
  # it { should be_running }
end

describe file('/opt/csf.tgz') do
  it { should_not exist }
end

describe directory('/opt/csf') do
  it { should_not exist }
end
describe file('/etc/csf/csf.conf') do
  it { should exist }
  # its('stdout') { should include 'RESTRICT_SYSLOG = "3"'}
  # its('stdout') { should include 'SYSLOG_CHECK = "3600"'}
end
describe package('MariaDB-server') do
  it { should be_installed }
end
describe command('mysql --version') do
  its('stdout') { should include '10.3.22-MariaDB' }
end

describe firewalld do
  it { should_not be_running }
end
# describe command('php -i') do
#   its('stdout') { should include 'short_open_tag On'}
# end
describe service('netdata') do
  it { should be_running }
end
describe http('http://localhost:19999') do
  its('status') { should eq 200 }
end
