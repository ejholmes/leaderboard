require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']
require 'active_support'
require 'active_support/core_ext'

class Octokit::Client
  def contributor_stats(owner, repo)
    get("repos/#{owner}/#{repo}/stats/contributors")
  end
end

module Leaderboard
  BASE = File.dirname(File.dirname(__FILE__))

  autoload :App, 'leaderboard/app'

  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'])
  end

  def self.app
    @app ||= Rack::Builder.app do
      run App
    end
  end
end