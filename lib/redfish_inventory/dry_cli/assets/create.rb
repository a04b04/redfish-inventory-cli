# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class Create < Dry::CLI::Command
        desc 'Create an asset from a Redfish JSON file'

        argument :file_path,
                 required: true,
                 desc: 'Path to the Redfish JSON file'

        option :name,
               required: true,
               desc: 'Asset name'

        option :rack_id,
               required: true,
               type: :integer,
               desc: 'Rack ID'

        option :size,
               required: true,
               type: :integer,
               desc: 'Asset size in U'

        option :position,
               required: true,
               type: :integer,
               desc: 'Rack position'

        def call(file_path:, name:, rack_id:, size:, position:, **)
          arguments = [
            "name=#{name}",
            "rackId=#{rack_id}",
            "size=#{size}",
            "position=#{position}"
          ]

          Commands::Assets.create(file_path, arguments)
        end
      end
    end
  end
end