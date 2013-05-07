require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']
require 'sinatra/base'

class Octokit::Client
  def contributor_stats(owner, repo)
    get("repos/#{owner}/#{repo}/stats/contributors")
  end
end

class App < Sinatra::Base
  enable :sessions

  configure :development do
    Dotenv.load
  end

  set :github_options, \
    scope:     'repo',
    secret:    ENV['GITHUB_SECRET'],
    client_id: ENV['GITHUB_KEY']

  register Sinatra::Auth::Github

  helpers do
    def api; github_user.api end

    def repositores
      api.organization_repositories(params[:owner], type: 'all')
    end

    def contributors(*args)
      api.contributor_stats(params[:owner], *args)
    end
  end

  get '/' do
    authenticate!
    erb :index
  end

  get '/:owner/stream', provides: 'text/event-stream' do |owner|
    authenticate!
    aggregate = Hash.new { |h,k| h[k] = { contributions: 0 } }
    stream do |out|
      repositores.each do |repo|
        contributors(repo.name).each do |contributor|
          login = contributor.author.login
          week  = contributor.weeks.first
          sum   = week.a + week.d + week.c
          aggregate[login][:author]         = contributor.author
          aggregate[login][:contributions] += sum
        end
        out << "event: update\ndata: #{aggregate.values.sort_by { |a| a[:sum] }.to_json}\n\n"
      end
      out << "event: complete\ndata: \n\n"
    end
  end
end