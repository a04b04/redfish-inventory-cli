# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class Delete < Dry::CLI::Command
        desc 'Delete an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        def call(id:, **)
          Commands::Assets.delete(id)
        end
      end
    end
  end
end