module RedfishInventory
  module DryCLI
    module Assets
      class CreateStorage < Dry::CLI::Command
        desc 'Create a storage asset'

        option :name,
               required: true,
               desc: 'Storage name'

        option :notes,
               required: false,
               desc: 'Optional notes'

        option :position,
               required: false,
               type: :integer,
               desc: 'Asset position'

        option :group_id,
               required: false,
               type: :integer,
               desc: 'Optional group ID'

        option :tags,
               required: false,
               desc: 'Tag IDs separated by commas'

        def call(name:, notes: nil, position: nil, group_id: nil, tags: nil, **)
          payload = {
            'name' => name
          }

          payload['notes'] = notes unless notes.nil? || notes.empty?
          payload['position'] = position unless position.nil?
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

          puts (payload)
          Commands::Assets.create_storage(payload)
        end
      end
    end
  end
end