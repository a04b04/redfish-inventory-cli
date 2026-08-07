# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class ShowStorage < Dry::CLI::Command
        desc 'Show a storage asset'

        argument :id,
                 required: true,
                 desc: 'Storage ID'

        def call(id:, **)
          Commands::Assets.show_storage(id)
        end
      end
    end
  end
end