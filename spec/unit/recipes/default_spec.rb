#
# Cookbook:: magento
# Spec:: default
#
# Copyright:: 2020, Asdrubal Gonzalez Penton, All Rights Reserved.

require 'spec_helper'

describe 'magento::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on CentOS 7' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'centos', '7'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'update the system' do
      expect(chef_run).to run_execute('yum update -y')
    end
    it 'install epel repo and wget' do
      expect(chef_run).to install_yum_package('wget')
      expect(chef_run).to install_yum_package('epel-release')
    end
    it 'remi repo present' do
      expect(chef_run).to add_yum_repository('remi')
    end
    it 'remi-safe present' do
      expect(chef_run).to add_yum_repository('remi-safe')
    end
    it 'remi-php73 present' do
      expect(chef_run).to add_yum_repository('remi-php72')
    end
    it 'nginx present' do
      expect(chef_run).to add_yum_repository('nginx-stable')
    end
    it 'update the system' do
      expect(chef_run).to run_execute('yum update -y')
    end
    it 'packages installed' do
      %w[perl unzip net-tools perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph git ccze htop vim glances].each do |pkg|
        expect(chef_run).to install_yum_package(pkg)
      end
    end
    it 'download the virtualmin script installation' do
      expect(chef_run).to create_remote_file('/opt/install.sh')
    end
    it 'install virtualmin' do
      expect(chef_run).to run_execute('install_virtuamin')
    end
    it 'csf downloaded' do
      expect(chef_run).to create_if_missing_remote_file('/opt/csf.tgz')
    end
    it 'csf unzipped' do
      expect(chef_run).to run_execute('unzip_csf')
    end
    it 'csf installed' do
      expect(chef_run).to run_execute('install_csf')
    end
    it 'template applied' do
      expect(chef_run).to render_file('/etc/csf/csf.conf')
    end
    it 'csf running' do
      expect(chef_run).to start_service('csf')
    end
    it 'csf enabled' do
      expect(chef_run).to enable_service('csf')
    end
    it 'install webmin module' do
      expect(chef_run).to run_execute('webmin_module')
    end
    it 'download the netdata script installation' do
      expect(chef_run).to create_if_missing_remote_file('/opt/kickstart.sh')
    end
    it 'install netdata' do
      expect(chef_run).to run_execute('install_netdata')
    end
    it 'files delete from /opt/csf.tgz' do
      expect(chef_run).to delete_file('/opt/csf.tgz')
    end

    it 'files delete from /opt/install.sh' do
      expect(chef_run).to delete_file('/opt/install.sh')
    end

    it 'files delete from /opt/composer.phar' do
      expect(chef_run).to delete_file('/opt/composer.phar')
    end

    it 'files delete from /opt/composer-setup.php' do
      expect(chef_run).to delete_file('/opt/composer-setup.php')
    end
    it 'files delete from /opt/csf' do
      expect(chef_run).to delete_directory('/opt/csf')
    end
  end
end
