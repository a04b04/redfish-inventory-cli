# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class List < Dry::CLI::Command
        desc 'List all assets'

        def call(**)
          Commands::Assets.list
        end
      end
    end
  end
end