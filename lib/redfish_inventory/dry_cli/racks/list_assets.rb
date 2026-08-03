# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class ListAssets < Dry::CLI::Command
        desc 'List assets assigned to a rack'

        argument :id,
                 required: true,
                 desc: 'Rack ID'

        def call(id:, **)
          Commands::Racks.list_assets(id)
        end
      end
    end
  end
end