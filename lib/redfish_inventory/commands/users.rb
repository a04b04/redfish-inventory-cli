# frozen_string_literal: true

module RedfishInventory
  module Commands
    class Users
      def self.create(username, password, role_id)
        if username.nil? || username.empty?
          puts 'Username cannot be empty'
          return
        end

        if password.nil? || password.empty?
          puts 'Password cannot be empty'
          return
        end

        payload = {
          'username' => username,
          'password' => password,
          'roleId' => role_id
        }

        user_id = ApiClient.post('/users', payload)

        puts
        puts "User '#{username}' created successfully"
        puts "User ID: #{user_id}"

        user_id
      end


    end
  end
end