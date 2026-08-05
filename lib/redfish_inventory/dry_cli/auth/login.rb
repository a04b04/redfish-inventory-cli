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
          token = response.dig('token', 'token')

          if token.nil? || token.empty?
            puts 'Login failed: the API did not return a token'
            return
          end

          RedfishInventory::Auth::TokenStore.save(token)

          puts "Logged in successfully as #{username}"
        end
      end
    end
  end
end