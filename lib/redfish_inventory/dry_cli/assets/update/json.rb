# frozen_string_literal: true

require 'dry/cli'
require 'json'

module RedfishInventory
  module DryCLI
    module Assets
      class UpdateJson < Dry::CLI::Command
        desc 'Upload a new JSON version for an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        argument :file,
                 required: true,
                 desc: 'Path to JSON file'

        def call(id:, file:, **)
          Commands::Assets.update_json(id, file)
        end
      end
    end
  end
end