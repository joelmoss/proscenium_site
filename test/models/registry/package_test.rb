# frozen_string_literal: true

require 'test_helper'

class Registry::PackageTest < ActiveSupport::TestCase
  describe '.finreate!' do
    it 'raises on invalid name' do
      assert_raises(ActiveRecord::RecordNotFound) { described_class.finreate!('rai ls') }
      assert_raises(ActiveRecord::RecordNotFound) { described_class.finreate!('rai/ls') }
      assert_raises(ActiveRecord::RecordNotFound) { described_class.finreate!('rai.ls') }
    end

    it 'raises on invalid version' do
      assert_raises(ActiveRecord::RecordNotFound) do
        described_class.finreate!('rails', 'version 1')
      end
    end

    context 'record exists' do
      it 'returns record' do
        assert_equal registry_packages(:rails7), described_class.finreate!('rails', '7.0.0')
      end

      it 'does not create new record' do
        assert_no_difference 'Registry::Package.count' do
          described_class.finreate!('rails', '7.0.0')
        end
      end
    end

    context 'record does not exist' do
      before do
        stub_gem('rails', version: '8.0.0')
      end

      it 'returns record' do
        assert_kind_of described_class, described_class.finreate!('rails', '8.0.0')
      end

      it 'creates new record when not existing' do
        assert_difference 'Registry::Package.count' do
          described_class.finreate!('rails', '8.0.0')
        end
      end
    end

    it 'uses latest version when none is given' do
      stub_gem('rails', latest_version: '8.0.2')

      assert described_class.finreate!('rails').version == '8.0.2'
    end

    context 'with unknown version' do
      it 'raises ActiveRecord::RecordNotFound' do
        stub_request(:get, 'https://rubygems.org/api/v2/rubygems/rails/versions/1.0.0.json')
          .to_return(status: 404, body: 'This version could not be found')

        assert_raises(ActiveRecord::RecordNotFound) do
          described_class.finreate!('rails', '1.0.0')
        end
      end
    end
  end

  private

    def stub_gem(name, version: nil, latest_version: nil)
      if version.blank? && latest_version.blank?
        raise ArgumentError, 'One of `version` or `latest_version` is required'
      end

      if version.present? && latest_version.present?
        raise ArgumentError, 'Only one of `version` or `latest_version` is accepted'
      end

      if version
        stub_request(:get, "https://rubygems.org/api/v2/rubygems/#{name}/versions/#{version}.json")
          .to_return_json(body: { version: })
      elsif latest_version
        stub_request(:get, "https://rubygems.org/api/v1/gems/#{name}.json")
          .to_return_json(body: { version: latest_version })
      end
    end
end
