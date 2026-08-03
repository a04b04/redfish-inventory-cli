# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Stats
      class Racks < Dry::CLI::Command
        desc 'Show rack capacity and utilisation statistics'

        def call(**)
          Commands::Stats.racks
        end
      end
    end
  end
end