# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class CreateUps < Dry::CLI::Command
        desc 'Create an uninterruptible power supply'

        option :name,
               required: true,
               desc: 'UPS name'

        option :notes,
               required: false,
               desc: 'Optional notes'

        option :position,
               required: false,
               type: :integer,
               desc: 'UPS position'

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

        option :capacity,
               required: false,
               type: :float,
               desc: 'UPS capacity'

        def call(
          name:,
          notes: nil,
          position: nil,
          storage_id: nil,
          group_id: nil,
          tags: nil,
          capacity: nil,
          **
        )
          payload = {
            'name' => name
          }

          payload['notes'] = notes unless notes.nil? || notes.empty?
          payload['position'] = position unless position.nil?
          payload['storageId'] = storage_id unless storage_id.nil?
          payload['groupId'] = group_id unless group_id.nil?
          payload['capacity'] = capacity unless capacity.nil?

          unless tags.nil? || tags.empty?
            tag_ids = tags
                      .split(',')
                      .map(&:strip)
                      .reject(&:empty?)
                      .map(&:to_i)
                      .uniq

            payload['tags'] = tag_ids
          end

          Commands::Assets.create_ups(payload)
        end
      end
    end
  end
end