# frozen_string_literal: true

require 'chefspec'
require 'chefspec/policyfile'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documetation
  config.log_level = :error
end
