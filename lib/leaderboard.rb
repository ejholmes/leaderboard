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
    sprockets_environment = sprockets
    @app ||= Rack::Builder.app do
      map '/assets' do
        run sprockets_environment
      end

      run App
    end
  end

  def self.rubygems_latest_specs
    # If newer Rubygems
    if ::Gem::Specification.respond_to? :latest_specs
      ::Gem::Specification.latest_specs
    else
      ::Gem.source_index.latest_specs
    end
  end

  ##
  # Sprockets::Environment for serving assets.
  def self.sprockets
    @sprockets ||= begin
      root = File.join(BASE, 'assets')

      environment = Sprockets::Environment.new.tap do |env|
        %w[stylesheets javascripts images].each do |path|
          env.append_path File.join(root, path)
        end
      end

      # Add any gems with (vendor|app|.)/assets/javascripts to paths
      # also add similar directories from project root (like in rails)
      try_paths = [
        %w{ assets },
        %w{ app },
        %w{ app assets },
        %w{ vendor },
        %w{ vendor assets },
        %w{ lib },
        %w{ lib assets }
      ].inject([]) do |sum, v|
        sum + [
          File.join(v, 'javascripts'),
          File.join(v, 'stylesheets'),
          File.join(v, 'images'),
          File.join(v, 'fonts')
        ]
      end

      ([root] + rubygems_latest_specs.map(&:full_gem_path)).each do |root_path|
        try_paths.map {|p| File.join(root_path, p) }.
          select {|p| File.directory?(p) }.
          each {|path| environment.append_path(path) }
      end

      environment
    end
  end
end