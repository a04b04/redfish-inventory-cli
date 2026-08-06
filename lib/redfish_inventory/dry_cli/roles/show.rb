# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Roles
      class Show < Dry::CLI::Command
      desc 'Show a specific role by id'

        argument :id,
                 required: true,
                 desc: 'Role ID'

        def call(id:, **)
          Commands::Roles.show(id)
        end
      end
    end
  end
end