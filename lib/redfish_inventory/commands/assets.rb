# frozen_string_literal: true

require 'json'

module RedfishInventory
  module Commands
    class Assets
      def self.run(action, arguments)
        case action
        when 'list'
          list
        when 'show'
          show(arguments[0])
        when 'update-json'
          update_json(arguments[0], arguments[1])
        when 'update-asset'
          update_asset(arguments[0], arguments.drop(1))
        when 'delete-asset'
          delete(arguments[0])
        when 'create-asset'
          create(arguments[0], arguments.drop(1))
        else
          puts "Unknown assets action: #{action}"
        end
      end

      def self.list
        # Production:
         assets = ApiClient.get("/assets")
         puts JSON.pretty_generate(assets)
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: assets show <id>'
          return
        end

        puts 'Usage: assets show <id>'
        nil

        # Production:
        asset = ApiClient.get("/assets/#{id}")
        puts JSON.pretty_generate(asset)
      end

      def self.update_json(id, file_path)
        if id.nil? || file_path.nil?
          puts 'Usage: assets update-json <id> <json-file>'
          return
        end

        unless File.exist?(file_path)
          puts "File not found: #{file_path}"
          return
        end

        json_text = File.read(file_path)

        begin
          JSON.parse(json_text)
        rescue JSON::ParserError
          puts 'The supplied file does not contain valid JSON'
          return
        end

        payload = {
          'json' => {
            'text' => json_text,
            'filename' => File.basename(file_path)
          }
        }

        response = ApiClient.post("/assets/#{id}", payload)

        puts "JSON added to asset #{id}"
      end

      def self.update_asset(id, updates)
        if id.nil? || updates.empty?
          puts 'Usage: assets update-asset <id> field=value field=value'
          return
        end

        asset = ApiClient.get("/assets/#{id}")

        payload = {
          'name' => asset['name'],
          'rackId' => asset['rackId'],
          'size' => asset['size'],
          'position' => asset['position']
        }

        updates.each do |update|
          field, value = update.split('=', 2)

          if field.nil? || value.nil?
            puts "Invalid update: #{update}"
            puts 'Use the format field=value'
            return
          end

          payload[field] = value
        end

        %w[rackId size position].each do |field|
          payload[field] = payload[field].to_i
        end

        updated_asset = ApiClient.patch("/assets/#{id}", payload)

        puts "Asset #{id} updated"
      end

      def self.delete(id)
        if id.nil?
          puts 'Usage: assets delete <id>'
          return
        end

        # Production:
        ApiClient.delete("/assets/#{id}")

        # Demo only — remove this section for production
        # assets_file = File.expand_path('../../../data/assets.json', __dir__)
        # assets = JSON.parse(File.read(assets_file))

        # asset = assets.find do |asset|
        #   asset['id'] == id.to_i
        # end

        # unless asset
        #   puts "Asset #{id} not found"
        #   return
        # end

        # assets.delete(asset)

        # File.write(
        #   assets_file,
        #   JSON.pretty_generate(assets)
        # )
        # End demo-only section

        puts "Asset #{id} deleted"
      end

      def self.show_version(id, index)
        if id.nil? || index.nil?
          puts 'Usage: assets show-version <id> <index>'
          return
        end

        if index.to_i.negative?
          puts 'Index must be 0 or higher'
          return
        end

        # Production:
        # asset = ApiClient.get("/assets/#{id}/#{index}")
        # puts JSON.pretty_generate(asset)
        puts "getting version #{index} of asset #{id}"
      end

      def self.create(file_path, arguments)
        if file_path.nil?
          puts 'Usage: assets create-asset <json-file> name="Server 1" rackId=1 size=2 position=4'
          return
        end

        unless File.exist?(file_path)
          puts "File not found: #{file_path}"
          return
        end

        fields = {
          'name' => '',
          'rackId' => '',
          'size' => '',
          'position' => ''
        }

        arguments.each do |argument|
          key, value = argument.split('=', 2)
          fields[key] = value
        end

        if fields['name'].empty? ||
           fields['rackId'].empty? ||
           fields['size'].empty? ||
           fields['position'].empty?
          puts 'Usage: assets create-asset <json-file> name="Server 1" rackId=1 size=2 position=4'
          return
        end

        begin
          json_text = File.read(file_path)
          parsed_json = JSON.parse(json_text)
        rescue JSON::ParserError
          puts 'The supplied file does not contain valid JSON'
          return
        end

        data_fields = []
        loop do
          print 'Search JSON fields: '
          search_term = $stdin.gets&.chomp

          if search_term.nil? || search_term.empty?
            puts 'Please enter a search term'
            next
          end

          matches = find_matching_paths(parsed_json, search_term)

          if matches.empty?
            puts 'No matching JSON fields found'
            next
          end

          matches.each_with_index do |match, index|
            puts
            puts "#{index + 1}. #{match['path']} = #{match['value'].inspect}"
          end

          print "\nSelect path numbers separated by commas: "
          input = $stdin.gets&.chomp

          selections = input
                       .to_s
                       .split(',')
                       .map(&:strip)
                       .reject(&:empty?)
                       .map(&:to_i)
                       .uniq

          invalid_selections = selections.select do |selection|
            selection < 1 || selection > matches.length
          end

          if selections.empty?
            puts 'Please select at least one path'
            next
          end

          unless invalid_selections.empty?
            puts "Invalid selections: #{invalid_selections.join(', ')}"
            next
          end

          selections.each do |selection|
            selected_match = matches[selection - 1]
            puts
            puts 'Enter a name for:'
            puts selected_match['path']
            print '> '

            field_name = $stdin.gets&.chomp
            field_name = selected_match['path'] if field_name.nil? || field_name.empty?

            data_fields << {
              'name' => field_name,
              'path' => selected_match['path']
            }
          end

          puts
          puts 'Selected fields:'

          data_fields.each_with_index do |field, index|
            puts "#{index + 1}. #{field['name']} — #{field['path']}"
          end

          puts
          puts '1. Search for more fields'
          puts '2. Submit asset'
          print 'Select an option: '

          next_action = $stdin.gets&.chomp

          case next_action
          when '1'
            next
          when '2'
            break
          else
            puts 'Invalid option. Returning to search.'
          end
        end

        payload = {
          'rackId' => fields['rackId'].to_i,
          'name' => fields['name'],
          'size' => fields['size'].to_i,
          'position' => fields['position'].to_i,
          'data' => data_fields,
          'json' => {
            'text' => json_text,
            'filename' => File.basename(file_path)
          }
        }

        # Production code — uncomment this when using the real API
        asset = ApiClient.post('/assets', payload)

        # Demo only — delete everything between these comments for production
        # assets_file = File.expand_path('../../../data/assets.json', __dir__)
        # assets = JSON.parse(File.read(assets_file))

        # next_id =
        #   if assets.empty?
        #     1
        #   else
        #     assets.map { |asset| asset['id'] }.max + 1
        #   end

        # asset = {
        #   'id' => next_id,
        #   **payload
        # }

        # assets << asset

        # File.write(
        #   assets_file,
        #   JSON.pretty_generate(assets)
        # )
        # End demo-only section — delete everything above this comment for production

        puts 'Asset created successfully'

        puts JSON.pretty_generate(
          {
            'id' => asset['id'],
            'name' => asset['name'],
            'rackId' => asset['rackId'],
            'size' => asset['size'],
            'position' => asset['position'],
            'data' => asset['data'],
            'json' => {
              'filename' => File.basename(file_path)
            }
          }
        )
      end

      def self.find_matching_paths(data, search_term, base_path = '')
        matches = []

        return matches if search_term.nil? || search_term.empty? || data.nil?

        if data.is_a?(Array)

          data.each_with_index do |item, index|
            path = base_path.empty? ? index.to_s : "#{base_path}/#{index}"

            matches.concat(
              find_matching_paths(item, search_term, path)
            )
          end

          return matches
        end

        return matches unless data.is_a?(Hash)

        data.each do |key, value|
          path = base_path.empty? ? key : "#{base_path}/#{key}"

          if key.downcase.include?(search_term.downcase)

            matches << {
              'path' => path,
              'value' => value
            }

          end

          matches.concat(
            find_matching_paths(value, search_term, path)
          )
        end

        matches
      end

      def self.select_data_fields(_parsed_json)
        []
      end
    end
  end
end
