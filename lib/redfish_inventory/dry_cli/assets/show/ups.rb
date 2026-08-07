# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class ShowUps < Dry::CLI::Command
        desc 'Show a UPS asset'

        argument :id,
                 required: true,
                 desc: 'UPS ID'

        def call(id:, **)
          Commands::Assets.show_ups(id)
        end
      end
    end
  end
end