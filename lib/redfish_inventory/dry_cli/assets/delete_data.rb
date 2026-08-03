# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class DeleteData < Dry::CLI::Command
        desc 'Select and delete a tracked data field from an asset'

        argument :asset_id,
                 required: true,
                 type: :integer,
                 desc: 'Asset ID'

        def call(asset_id:, **)
          Commands::Assets.delete_data(asset_id)
        end
      end
    end
  end
end