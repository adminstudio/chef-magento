# frozen_string_literal: true

include_controls 'linux-baseline' do
  # skip entropy test, as our short living test VMs usually do not
  # have enough
  # skip_control 'os-01'
  # skip_control 'os-08'
  # skip_control 'sysctl-05'
  # skip_control 'sysctl-06'
  # skip_control 'sysctl-07'
  # skip_control 'sysctl-08'
  # skip_control 'sysctl-09'
  # skip_control 'sysctl-10'
  # skip_control 'sysctl-14'
  # skip_control 'sysctl-15'
  # skip_control 'sysctl-16'
  # skip_control 'sysctl-17'
  # skip_control 'sysctl-18'
  # skip_control 'sysctl-20'
  # skip_control 'sysctl-21'
  # skip_control 'sysctl-22'
  # skip_control 'sysctl-23'
  # skip_control 'sysctl-24'
  # skip_control 'sysctl-25'
  # skip_control 'sysctl-26'
  # skip_control 'sysctl-27'
  # skip_control 'sysctl-28'
  # skip_control 'sysctl-30'
end
