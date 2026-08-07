# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class UpdateAsset < Dry::CLI::Command
        desc 'Update an asset'

        argument :id,
                 required: true,
                 desc: 'Asset ID'

        option :name,
               required: false,
               desc: 'Asset name'

        option :notes,
               required: false,
               desc: 'Asset notes'

        option :position,
               required: false,
               type: :integer,
               desc: 'Asset position'

        option :storage_id,
               required: false,
               type: :integer,
               desc: 'Storage ID'

        option :group_id,
               required: false,
               type: :integer,
               desc: 'Group ID'

        def call(
          id:,
          name: nil,
          notes: nil,
          position: nil,
          storage_id: nil,
          group_id: nil,
          **
        )
          payload = {}

          payload['name'] = name unless name.nil? || name.empty?
          payload['notes'] = notes unless notes.nil?
          payload['position'] = position unless position.nil?
          payload['storageId'] = storage_id unless storage_id.nil?
          payload['groupId'] = group_id unless group_id.nil?

          if payload.empty?
            puts 'No updates supplied'
            return
          end

          Commands::Assets.update_asset(id, payload)
        end
      end
    end
  end
end