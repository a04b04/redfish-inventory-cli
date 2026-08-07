# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class History < Dry::CLI::Command
        desc 'Show JSON history for an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        def call(id:, **)
          Commands::Assets.history(id)
        end
      end
    end
  end
end