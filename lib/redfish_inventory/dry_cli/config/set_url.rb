# frozen_string_literal: true

require 'dry/cli'
require 'uri'

module RedfishInventory
  module DryCLI
    module Config
      class SetUrl < Dry::CLI::Command
        desc 'Set the Asset Rack API URL'

        argument :url,
                 required: true,
                 desc: 'API URL'

        def call(url:, **)
          uri = URI.parse(url)

          unless uri.is_a?(URI::HTTP) && uri.host
            puts 'Please enter a valid HTTP or HTTPS URL'
            return
          end

          ConfigStore.save_api_url(url)

          puts "API URL set to #{ConfigStore.api_url}"
        rescue URI::InvalidURIError
          puts 'Please enter a valid HTTP or HTTPS URL'
        end
      end
    end
  end
end