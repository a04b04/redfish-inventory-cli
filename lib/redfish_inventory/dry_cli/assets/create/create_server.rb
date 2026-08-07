# frozen_string_literal: true
 
require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class CreateServer < Dry::CLI::Command
        desc 'Create a server asset'

        option :name, 
               required: true,
               desc: 'Server name'
        option :model,
               required: false,
               desc: 'Server model'
        option :notes,
               required: false,
               desc: 'Notes'
        option :position,
               required: false,
               type: :integer,
               desc: 'Asset position'
        option :json,
               required: false,
               desc: 'Path to a JSON file'
        option :tags,
               required: false,
               desc: 'option to group the server to a specified category'
        

        def call(name:, model: nil, notes: nil, position: nil, json: nil, tags: nil, **)
          payload = {
            'name' => name
          }

          payload['model'] = model unless model.nil? || model.empty?
          payload['notes'] = notes unless notes.nil? || notes.empty?
          payload['position'] = position unless position.nil?

          unless tags.nil? || tags.empty?
            tag_ids = tags
                      .split(',')
                      .map(&:strip)
                      .reject(&:empty?)
                      .map(&:to_i)
                      .uniq 
            payload['tags'] = tag_ids
          end

          unless json.nil?
            unless File.file?(json)
              puts "JSON file not found: #{json}"
              return
            end

            begin
              json_text = File.read(json)
              parsed_json = JSON.parse(json_text)
            rescue JSON::ParserError => error
              puts "Invalid JSON file: #{error.message}"
              return
            end

            payload['json'] = json_text

            print 'Would you like to select data from the JSON? (y/n): '
            answer = $stdin.gets&.chomp&.downcase

            if answer == 'y'
              selected_paths = JsonFieldSelector.select_fields(parsed_json)
              payload['paths'] = selected_paths unless selected_paths.empty?
            end
          end

          puts JSON.pretty_generate(payload)
          Commands::Assets.create_server(payload)
        end

      end
    end
  end
end