require 'spec_helper'

describe Leaderboard.app do
  include Rack::Test::Methods
  include Warden::Test::Helpers

  subject(:app) { Leaderboard.app }

  before do
    login_as "A GitHub User"
  end

  after do
    Warden.test_reset!
  end

  describe 'GET /' do
    it 'allows the user to select an organization' do
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