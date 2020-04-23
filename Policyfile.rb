# frozen_string_literal: true

# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'magento'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'magento::default', 'os-hardening'

# Specify a custom source for a single cookbook:
cookbook 'magento', path: '.'
cookbook 'chef_slack', '~> 3.1.2', :supermarket
cookbook 'os-hardening', github: 'dev-sec/chef-os-hardening', branch: 'master'
