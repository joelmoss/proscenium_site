# frozen_string_literal: true

require 'test_helper'

class TarballsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'registry.proscenium.localhost'
  end

  describe 'GET /tarballs/:name/:version' do
    context 'package is live on RubyGems' do
      before do
        stub_request(:get, 'https://rubygems.org/api/v2/rubygems/rails/versions/7.0.0.json')
          .to_return_json(body: { version: '7.0.0' })
      end

      it 'redirects to a signed R2 URL' do
        get '/tarballs/rails/7.0.0.tgz'

        assert_response :redirect
        assert_equal 'https://signed.test/rails/rails-7.0.0.tgz', response.location
      end
    end

    context 'package has been yanked' do
      before do
        stub_request(:get, 'https://rubygems.org/api/v2/rubygems/rails/versions/7.0.0.json')
          .to_return(status: 404, body: 'This version could not be found')
      end

      it 'returns 404' do
        get '/tarballs/rails/7.0.0.tgz'

        assert_response :not_found
      end

      it 'destroys the cached package' do
        assert_difference 'Registry::Package.count', -1 do
          get '/tarballs/rails/7.0.0.tgz'
        end
      end
    end

    context 'invalid version' do
      it 'returns 404 without hitting RubyGems' do
        get '/tarballs/rails/not-a-version.tgz'

        assert_response :not_found
      end
    end
  end
end
