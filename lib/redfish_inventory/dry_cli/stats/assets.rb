# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Stats
      class Assets < Dry::CLI::Command
        desc 'Show asset and tracked-data statistics'

        def call(**)
          Commands::Stats.assets
        end
      end
    end
  end
end