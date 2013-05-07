require 'spec_helper'

describe Leaderboard.app do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  subject(:app) { Leaderboard.app }
  let(:api)     { double(Octokit::Client) }
  let(:user)    { double('User', api: api) }

  before do
    login_as user
  end

  after do
    Warden.test_reset!
  end

  describe 'GET /' do
    it 'allows the user to select an organization' do
      api.stub :organizations => []
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'GET /:owner' do
    it 'shows the user the streamed data'
  end

  describe 'GET /:owner/stream' do
    it 'streams aggregated contribution data'
  end
end