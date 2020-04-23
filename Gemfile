# frozen_string_literal: true

source 'https://rubygems.org'

# gem 'berkshelf', '~> 6.3'
gem 'berkshelf', '~> 7.0', '>= 7.0.9'
# gem 'chef', '~> 12'
gem 'chef', '~> 15.9', '>= 15.9.17'

group :test do
  # gem 'chefspec', '~> 7.2.1'
  gem 'chefspec', '~> 9.1'
  # gem 'cookstyle', '~> 3'
  # gem 'cookstyle', '~> 6.1', '>= 6.1.6'
  gem 'cookstyle', '~> 6.3', '>= 6.3.4'
  gem 'coveralls', require: false
  # gem 'coveralls', '~> 0.8.23'
  # gem 'foodcritic', '~> 13.1'
  gem 'foodcritic', '~> 16.2'
  # gem 'minitest', '~> 5.10.2'
  gem 'minitest', '~> 5.14'
  # gem 'rake'
  gem 'rake', '~> 13.0', '>= 13.0.1'
  # gem 'simplecov', '~> 0.10'
  gem 'simplecov', '~> 0.18.5'
end

group :development do
  gem 'guard'
  gem 'guard-cookstyle', '~> 0.3.0'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-kitchen'
  gem 'guard-rake', '~> 1.0'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end

group :integration do
  # gem 'concurrent-ruby', '~> 1.0.5'
  gem 'concurrent-ruby', '~> 1.1', '>= 1.1.6'
  gem 'kitchen-dokken'
  gem 'kitchen-inspec'
  gem 'kitchen-vagrant'
  # gem 'test-kitchen', '~> 1.16.0'
  gem 'test-kitchen', '~> 2.4'
end

group :tools do
  # gem 'github_changelog_generator', '~> 1.14'
  gem 'github_changelog_generator', '~> 1.15'
end
