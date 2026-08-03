# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class AddData < Dry::CLI::Command
        desc 'Search an asset JSON and add tracked data fields'

        argument :asset_id,
                 required: true,
                 type: :integer,
                 desc: 'Asset ID'

        def call(asset_id:, **)
          Commands::Assets.add_data(asset_id)
        end
      end
    end
  end
end