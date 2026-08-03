# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class Show < Dry::CLI::Command
        desc 'Show a rack'

        argument :id,
                 required: true,
                 desc: 'Rack ID'

        def call(id:, **)
          Commands::Racks.show(id)
        end
      end
    end
  end
end