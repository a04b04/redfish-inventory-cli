# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class Show < Dry::CLI::Command
        desc 'Show an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        def call(id:, **)
          Commands::Assets.show(id)
        end
      end
    end
  end
end