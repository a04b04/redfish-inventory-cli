# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Roles
      class List < Dry::CLI::Command
        desc 'List all available roles'

        def call(**)
          Commands::Roles.list
        end
      end
    end
  end
end