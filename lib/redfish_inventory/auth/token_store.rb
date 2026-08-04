# frozen_string_literal: true

require 'fileutils'

module RedfishInventory
  module Auth
    class TokenStore
      DIRECTORY = File.expand_path('~/.config/redfish-inventory')
      FILE_PATH = File.join(DIRECTORY, 'token')

      def self.save(token)
        FileUtils.mkdir_p(DIRECTORY)
        File.write(FILE_PATH, token)
        File.chmod(0o600, FILE_PATH)
      end

      def self.load
        return unless File.file?(FILE_PATH)

        token = File.read(FILE_PATH).strip

        return if token.empty?

        token
      end

      def self.delete
        return unless File.file?(FILE_PATH)

        File.delete(FILE_PATH)
      end

      def self.saved?
        !load.nil?
      end
    end
  end
end