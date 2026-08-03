# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Stats
      class Stats < Dry::CLI::Command
        desc 'Show an overview of inventory statistics'

        def call(**)
          Commands::Stats.overview
        end
      end
    end
  end
end