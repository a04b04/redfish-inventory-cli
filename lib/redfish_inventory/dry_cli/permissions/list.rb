# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Permissions
      class List < Dry::CLI::Command
        desc 'List all available permissions'

        def call(**)
          Commands::Permissions.list
        end
      end
    end
  end
end