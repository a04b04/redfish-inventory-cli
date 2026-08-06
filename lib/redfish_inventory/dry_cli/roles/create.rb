# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Roles
      class Create < Dry::CLI::Command
        desc 'Create a role with permission IDs'

        option :name,
               required: true,
               desc: 'Role name, use quotes if it contains spaces'

        option :permissions,
               required: true,
               desc: 'Permission IDs separated by commas'

        def call(name:, permissions:, **)
          permission_ids = permissions
                           .split(',')
                           .map(&:strip)
                           .reject(&:empty?)
                           .map(&:to_i)
                           .uniq

          Commands::Roles.create(
            name,
            permission_ids
          )
        end
      end
    end
  end
end