# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class ShowServer < Dry::CLI::Command
        desc 'Show a server asset'

        argument :id,
                 required: true,
                 desc: 'Server ID'

        def call(id:, **)
          Commands::Assets.show_server(id)
        end
      end
    end
  end
end