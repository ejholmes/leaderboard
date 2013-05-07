ENV['RACK_ENV'] ||= 'test'
ENV['GITHUB_KEY']    = 'foobar'
ENV['GITHUB_SECRET'] = 'barfoo'

require File.expand_path('../../config/environment', __FILE__)
Bundler.require :default, :test
require 'rack/test'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}
