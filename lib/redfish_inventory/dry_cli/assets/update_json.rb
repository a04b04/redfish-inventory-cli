# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class UpdateJson < Dry::CLI::Command
        desc 'Replace an asset JSON payload'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        argument :file_path,
                 required: true,
                 desc: 'Path to the replacement JSON file'

        def call(id:, file_path:, **)
          Commands::Assets.update_json(id, file_path)
        end
      end
    end
  end
end