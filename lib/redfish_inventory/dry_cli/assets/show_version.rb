# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class ShowVersion < Dry::CLI::Command
        desc 'Show a specific asset version'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        argument :index,
                 required: true,
                 desc: 'Version index'

        def call(id:, index:, **)
          Commands::Assets.show_version(id, index)
        end
      end
    end
  end
end