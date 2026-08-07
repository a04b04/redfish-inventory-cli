# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class CreateGeneric < Dry::CLI::Command
        desc 'Create a generic asset'

        option :name,
               required: true,
               desc: 'Asset name'

        option :notes,
               required: false,
               desc: 'Notes'

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

        option :tags,
               required: false,
               desc: 'Tag IDs separated by commas'

        def call(
          name:,
          notes: nil,
          position: nil,
          storage_id: nil,
          group_id: nil,
          tags: nil,
          **
        )
          payload = {
            'name' => name
          }

          payload['notes'] = notes unless notes.nil? || notes.empty?
          payload['position'] = position unless position.nil?
          payload['storageId'] = storage_id unless storage_id.nil?
          payload['groupId'] = group_id unless group_id.nil?

          unless tags.nil? || tags.empty?
            tag_ids = tags
                      .split(',')
                      .map(&:strip)
                      .reject(&:empty?)
                      .map(&:to_i)
                      .uniq

            payload['tags'] = tag_ids
          end

          Commands::Assets.create_generic(payload)
        end
      end
    end
  end
end