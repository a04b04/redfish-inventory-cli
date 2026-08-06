# frozen_string_literal: true

require 'fileutils'
require 'json'

module RedfishInventory
  class ConfigStore
    DIRECTORY = File.expand_path('~/.config/redfish-inventory')
    FILE_PATH = File.join(DIRECTORY, 'config.json')

    def self.save_api_url(url)
      FileUtils.mkdir_p(DIRECTORY)

      config = {
        'api_url' => url.sub(%r{/$}, '')
      }

      File.write(FILE_PATH, JSON.pretty_generate(config))
    end

    def self.api_url
      return unless File.file?(FILE_PATH)

      config = JSON.parse(File.read(FILE_PATH))
      config['api_url']
    rescue JSON::ParserError
      nil
    end
  end
end