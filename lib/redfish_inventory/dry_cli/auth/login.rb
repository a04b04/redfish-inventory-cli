# frozen_string_literal: true

require 'dry/cli'
require 'io/console'

module RedfishInventory
  module DryCLI
    module Auth
      class Login < Dry::CLI::Command
        desc 'Log in to the Redfish Inventory API'

        def call(**)
          print 'Username: '
          username = $stdin.gets&.chomp

          if username.nil? || username.empty?
            puts 'Username cannot be empty'
            return
          end

          print 'Password: '
          password = $stdin.noecho(&:gets)&.chomp
          puts

          if password.nil? || password.empty?
            puts 'Password cannot be empty'
            return
          end

          response = ApiClient.login(username, password)

          access_token = response.dig('token', 'token')
          access_expires_at = response.dig('token', 'expiresAt')
          refresh_token = response.dig('refresh', 'token')
          refresh_expires_at = response.dig('refresh', 'expiresAt')

          if access_token.nil? || access_token.empty? ||
             refresh_token.nil? || refresh_token.empty? ||
             access_expires_at.nil? ||
             refresh_expires_at.nil?
            puts 'Login failed: the API did not return a valid session'
            return
          end

          RedfishInventory::Auth::TokenStore.save_session(response)

          puts "Logged in successfully as #{username}"
        end
      end
    end
  end
end