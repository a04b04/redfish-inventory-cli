# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class CreatePdu < Dry::CLI::Command
        desc 'Create a power distribution unit'

        option :name,
               required: true,
               desc: 'PDU name'

        option :notes,
               required: false,
               desc: 'Optional notes'

        option :position,
               required: false,
               type: :integer,
               desc: 'PDU position'

        option :storage_id,
               required: false,
               type: :integer,
               desc: 'Storage ID'

        option :group_id,
               required: false,
               type: :integer,
               desc: 'Group ID'

        option :tags,
               required: false,
               desc: 'Tag IDs separated by commas'

        option :outlet_count,
               required: false,
               type: :integer,
               desc: 'Number of PDU outlets'

        def call(
          name:,
          notes: nil,
          position: nil,
          storage_id: nil,
          group_id: nil,
          tags: nil,
          outlet_count: nil,
          **
        )
          payload = {
            'name' => name
          }

          payload['notes'] = notes unless notes.nil? || notes.empty?
          payload['position'] = position unless position.nil?
          payload['storageId'] = storage_id unless storage_id.nil?
          payload['groupId'] = group_id unless group_id.nil?
          payload['outletCount'] = outlet_count unless outlet_count.nil?

          unless tags.nil? || tags.empty?
            tag_ids = tags
                      .split(',')
                      .map(&:strip)
                      .reject(&:empty?)
                      .map(&:to_i)
                      .uniq

            payload['tags'] = tag_ids
          end

          Commands::Assets.create_pdu(payload)
        end
      end
    end
  end
end