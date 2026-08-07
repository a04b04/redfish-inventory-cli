# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class DeleteAsset < Dry::CLI::Command
        desc 'Delete Asset by ID'

        argument :asset_id,
                 required: true,
                 type: :integer,
                 desc: 'Asset ID'
        def call(asset_id:, **)
          Commands::Assets.delete_asset(asset_id)
        end
      end
    end
  end
end