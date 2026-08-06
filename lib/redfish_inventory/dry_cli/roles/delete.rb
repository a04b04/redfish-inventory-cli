# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Roles
      class Delete < Dry::CLI::Command
        desc 'Delete a role by ID'

        argument :id,
                 required: true,
                 type: :integer,
                 desc: 'Role ID to delete'

        def call(id:, **)
          Commands::Roles.delete(id)
        end
      end
    end
  end
end