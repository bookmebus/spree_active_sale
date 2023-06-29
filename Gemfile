source 'http://rubygems.org'

# Provides basic authentication functionality for testing parts of your engine
# gem 'spree_auth_devise', :git => "git://github.com/spree/spree_auth_devise", :branch => '2-0-stable'
# gem 'spree', :git => "git://github.com/spree/spree", :branch => '2-0-stable'
# gem 'coveralls', require: false

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

spree_version = '>= 4.5'

gem 'spree', spree_version
gem 'spree_auth_devise', spree_version
gem 'coveralls', require: false
gem 'spree_multi_vendor'

gem 'rails-controller-testing'
gem 'factory_bot'
gem 'ffaker'

gem 'request_store'

group :development, :test do
  # %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
  #   gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'main'
  # end

  %w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'main'
  end

  gem 'spree_sample', '~> 4.5'
  gem 'mobility'
  gem 'byebug'
  gem 'pg'
end

gemspec
