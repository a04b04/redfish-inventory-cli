# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class Update < Dry::CLI::Command
        desc 'Update an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        option :name,
               desc: 'New asset name, use quotes if it contains spaces'

        option :rack_id,
               type: :integer,
               desc: 'New rack ID'

        option :size,
               type: :integer,
               desc: 'New size in U'

        option :position,
               type: :integer,
               desc: 'New rack position'

        def call(id:, name: nil, rack_id: nil, size: nil, position: nil, **)
          updates = {}

          updates['name'] = name unless name.nil?
          updates['rackId'] = rack_id unless rack_id.nil?
          updates['size'] = size unless size.nil?
          updates['position'] = position unless position.nil?

          Commands::Assets.update_asset(id, updates)
        end
      end
    end
  end
end