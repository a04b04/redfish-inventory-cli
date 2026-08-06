# frozen_string_literal: true

require 'json'

module RedfishInventory
  module Commands
    class Assets

      def self.print_asset_summary(asset)
        puts ""
        puts "ID #{asset['id']}"
        puts "Name #{asset['name']}"
        puts "Rack #{asset['rackId']}"
        puts "Size: #{asset['size']}U"
        puts "Position: #{asset['position']}"

        data_fields = asset['data'] || []

        unless data_fields.empty?
          puts 'Data:'

          data_fields.each do |field|
            puts "#{field['name']}: #{field['value']}"
          end
        end
        puts '-' * 40
      end


      # Methods for what the API allows below 
      def self.list
        data = ApiClient.get('/assets')
        assets = data['assets'] || []

        if assets.empty?
          puts 'No assets found'
          return
        end

        assets.each do |asset|
          print_asset_summary(asset)
        end

        print "\nWould you like to see JSON? (y/n): "
        answer = $stdin.gets&.chomp&.downcase
        return unless answer == 'y'

        print "Enter asset IDs separated by commas: "
        input = $stdin.gets&.chomp

        selected_ids = input
                      .to_s
                      .split(',')
                      .map(&:strip)
                      .reject(&:empty?)
                      .map(&:to_i)
                      .uniq

        selected_ids.each do |id|
          asset = assets.find { |item| item['id'] == id }

          unless asset
            puts "Asset #{id} not found"
            next
          end
          puts
          puts "JSON for asset #{id}:"

          json_text = asset.dig('json', 'text')

          begin
            puts JSON.pretty_generate(JSON.parse(json_text))
          rescue JSON::ParserError
            puts "Asset #{id} contains invalid JSON"
          end
        end
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: assets show <id>'
          return
        end

        asset = ApiClient.get("/assets/#{id}")
        print_asset_summary(asset)

        print "\nWould you like to see JSON? (y/n): "
        answer = $stdin.gets&.chomp&.downcase

        return unless answer == 'y'

        json_text = asset.dig('json', 'text')

        puts
        puts "JSON for asset #{id}:"
        puts JSON.pretty_generate(JSON.parse(json_text))
      end
        

      def self.update_json(id, file_path)
        if id.nil? || file_path.nil?
          puts 'Usage: assets update-json <id> <json-file>'
          return
        end

        unless File.file?(file_path)
          puts "File not found: #{file_path}"
          return
        end

        json_text = File.read(file_path)

        begin
          JSON.parse(json_text)
        rescue JSON::ParserError => error
          puts "Invalid JSON file: #{error.message}"
          return
        end

        payload = {
          'json' => {
            'text' => json_text,
            'filename' => File.basename(file_path)
          }
        }

        data = ApiClient.post("/assets/#{id}", payload)
        updated_asset = data['assets']

        puts "JSON updated for asset #{id}"
        print_asset_summary(updated_asset)
      end

      def self.update_asset(id, updates)
        if id.nil? || updates.empty?
          puts 'Usage: assets update-asset <id> field=value field=value'
          return
        end

        payload =
          if updates.is_a?(Hash)
            updates.dup
          else
            updates.each_with_object({}) do |update, result|
              field, value = update.split('=', 2)

              if field.nil? || value.nil?
                puts "Invalid update: #{update}"
                puts 'Use the format field=value'
                return
              end

              result[field] = value
            end
          end

        %w[rackId size position].each do |field|
          payload[field] = payload[field].to_i if payload.key?(field)
        end

        data = ApiClient.patch("/assets/#{id}", payload)
        updated_asset = data['assets']

        puts "Asset #{id} updated"
        print_asset_summary(updated_asset)
      end

      def self.delete(id)
        if id.nil?
          puts 'Usage: assets delete <id>'
          return
        end

        ApiClient.delete("/assets/#{id}")
        puts "Asset #{id} deleted"
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

          matches = JsonFieldSelector.find_matching_paths(
            parsed_json,
            search_term
          )

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
            field_name = selected_match['path'].split('/').last if field_name.nil? || field_name.empty?

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
          'paths' => data_fields,
          'json' => {
            'text' => json_text,
            'filename' => File.basename(file_path)
          }
        }

        asset = ApiClient.post('/assets', payload)

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

      def self.show_version(id, index)
        if id.nil? || index.nil?
          puts 'Usage: assets show-version <id> <index>'
          return
        end

        if index.to_i.negative?
          puts 'Index must be 0 or higher'
          return
        end

        asset = ApiClient.get("/assets/#{id}/#{index}")
        puts JSON.pretty_generate(asset)
      end

      def self.fetch_version(id, index)
        ApiClient.get("/assets/#{id}/#{index}")
      end

      def self.print_json(asset)
        json_text = asset.dig('json', 'text')

        if json_text.nil? || json_text.empty?
          puts 'No JSON stored for this version'
          return
        end

        puts JSON.pretty_generate(JSON.parse(json_text))
      rescue JSON::ParserError
        puts json_text
      end

      def self.add_data(asset_id)
        if asset_id.nil?
          puts 'Usage: assets add-data <asset-id>'
          return
        end

        asset = ApiClient.get("/assets/#{asset_id}")
        json_text = asset.dig('json', 'text')

        if json_text.nil? || json_text.empty?
          puts "Asset #{asset_id} has no stored JSON"
          return
        end

        parsed_json = JSON.parse(json_text)
        selected_fields = []

        loop do
          print 'Search JSON fields: '
          search_term = $stdin.gets&.chomp

          if search_term.nil? || search_term.empty?
            puts 'Please enter a search term'
            next
          end

          matches = JsonFieldSelector.find_matching_paths(
            parsed_json,
            search_term
          )

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
            field_name = selected_match['path'].split('/').last if field_name.nil? || field_name.empty?

            selected_fields << {
              'name' => field_name,
              'path' => selected_match['path']
            }
          end

          puts
          puts '1. Search for more fields'
          puts '2. Finish'
          print 'Select an option: '

          next_action = $stdin.gets&.chomp
          break if next_action == '2'
        end

        selected_fields = selected_fields.uniq { |field| field['path'] }

        payload = {
          'paths' => selected_fields
        }

        added_data = ApiClient.post(
          "/assets/#{asset_id}/paths",
          payload
        )

        puts "Added #{added_data.length} data fields to asset #{asset_id}"
      end

      def self.delete_data(asset_id)
        asset = ApiClient.get("/assets/#{asset_id}")
        data_fields = asset['data'] || []

        if data_fields.empty?
          puts "Asset #{asset_id} has no tracked data"
          return
        end

        puts
        puts "Tracked data for asset #{asset_id}:"
        puts

        data_fields.each_with_index do |field, index|
          puts "#{index + 1}. #{field['name']}: #{field['value']}"
        end

        print "\nSelect a data field to delete: "
        selection = $stdin.gets&.chomp.to_i

        if selection < 1 || selection > data_fields.length
          puts 'Invalid selection'
          return
        end

        selected_field = data_fields[selection - 1]

        print "Delete '#{selected_field['name']}'? (y/n): "
        confirmed = $stdin.gets&.chomp&.downcase

        return unless confirmed == 'y'

        ApiClient.delete(
          "/assets/#{asset_id}/paths/#{selected_field['id']}"
        )
        puts "'#{selected_field['name']}' deleted from asset #{asset_id}"
      end

      
      
    end
  end
end
