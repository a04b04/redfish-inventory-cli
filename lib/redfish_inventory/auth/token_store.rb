# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'time'

module RedfishInventory
  module Auth
    class TokenStore
      DIRECTORY = File.expand_path('~/.config/redfish-inventory')
      FILE_PATH = File.join(DIRECTORY, 'session.json')

      def self.save_session(response)
        session = {
          'issued_at' => response['issuedAt'],
          'access_token' => response.dig('token', 'token'),
          'access_expires_at' => response.dig('token', 'expiresAt'),
          'refresh' => response.dig('refresh', 'token'),
          'refresh_expires_at' => response.dig('refresh', 'expiresAt')
        }

        FileUtils.mkdir_p(DIRECTORY)
        File.write(FILE_PATH, JSON.pretty_generate(session))
        File.chmod(0o600, FILE_PATH)
      end

      def self.load_session
        return unless File.file?(FILE_PATH)

        JSON.parse(File.read(FILE_PATH))
      rescue JSON::ParserError
        delete
        nil
      end

      def self.access_token
        load_session&.dig('access_token')
      end

      def self.refresh_token
        load_session&.dig('refresh_token')
      end

      def self.access_expired?
        expires_at = load_session&.dig('access_expires_at')
        return true if expires_at.nil?

        Time.now >= Time.parse(expires_at) - 60
      end

      def self.refresh_expired?
        expires_at = load_session&.dig('refresh_expires_at')
        return true if expires_at.nil?

        Time.now >= Time.parse(expires_at)
      end

      def self.delete
        File.delete(FILE_PATH) if File.file?(FILE_PATH)
      end

      def self.saved?
        !load_session.nil?
      end
    end
  end
end