require 'sinatra/base'
require 'haml'

module Leaderboard
  class App < Sinatra::Base
    set :root, BASE

    enable :sessions

    configure :test do
      set :show_exceptions, false
      set :raise_errors, true
    end

    set :github_options, \
      scope:     'repo',
      secret:    ENV['GITHUB_SECRET'],
      client_id: ENV['GITHUB_KEY']

    register Sinatra::Auth::Github

    helpers do
      delegate :api, to: :github_user
      delegate :organizations, to: :api

      def repositores
        api.organization_repositories(params[:owner], type: 'all')
      end

      def contributors(*args)
        api.contributor_stats(params[:owner], *args)
      end
    end

    before do
      authenticate!
    end

    get '/' do
      haml :index
    end

    get '/:owner' do |owner|
      @owner = owner
      haml :owner
    end

    get '/:owner/stream', provides: 'text/event-stream' do |owner|
      aggregate = Hash.new { |h,k| h[k] = { contributions: 0 } }
      stream do |out|
        repositores.each do |repo|
          contributors(repo.name).each do |contributor|
            login = contributor.author.login
            week  = contributor.weeks.first
            sum   = week.a + week.d + week.c
            aggregate[login][:login]          = login
            aggregate[login][:author]         = contributor.author
            aggregate[login][:contributions] += sum
          end
          out << "event: update\ndata: #{aggregate.values.to_json}\n\n"
        end
        out << "event: complete\ndata: \n\n"
      end
    end
  end
end