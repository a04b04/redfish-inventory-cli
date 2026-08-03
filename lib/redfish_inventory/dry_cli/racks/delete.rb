# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class Delete < Dry::CLI::Command
        desc 'Delete a rack'

        argument :id,
                 required: true,
                 desc: 'Rack ID'

        def call(id:, **)
          Commands::Racks.delete(id)
        end
      end
    end
  end
end