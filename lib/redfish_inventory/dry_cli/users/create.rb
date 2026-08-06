# frozen_string_literal: true

require 'dry/cli'
require 'io/console'

module RedfishInventory
  module DryCLI
    module Users
      class Create < Dry::CLI::Command
        desc 'Create a new user'

        option :username,
               required: true,
               desc: 'Username for the new user'

        option :role_id,
               required: true,
               type: :integer,
               desc: 'Role ID for the new user'

        def call(username:, role_id:, **)
          print 'Password: '
          password = $stdin.noecho(&:gets)&.chomp
          puts

          if password.nil? || password.empty?
            puts 'Password cannot be empty'
            return
          end

          Commands::Users.create(
            username,
            password,
            role_id
          )
        end
      end
    end
  end
end