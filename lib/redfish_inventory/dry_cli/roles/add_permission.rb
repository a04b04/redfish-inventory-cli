# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Roles
      class AddPermissions < Dry::CLI::Command
        desc 'Add permissions to a role by ID'

        argument :id,
                 required: true,
                 type: :integer,
                 desc: 'Role ID'

        option :permissions,
               required: true,
               desc: 'Permission IDs separated by commas'

        def call(id:, permissions:, **)
          permission_ids = permissions
                           .split(',')
                           .map(&:strip)
                           .reject(&:empty?)

          unless permission_ids.all? { |permission_id| permission_id.match?(/\A\d+\z/) }
            puts 'Permission IDs must be positive integers separated by commas'
            return
          end

          permission_ids = permission_ids
                           .map(&:to_i)
                           .select(&:positive?)
                           .uniq

          if permission_ids.empty?
            puts 'Please provide at least one permission ID'
            return
          end

          Commands::Roles.add_permissions(
            id,
            permission_ids
          )
        end
      end
    end
  end
end