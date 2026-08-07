# frozen_string_literal: true

module RedfishInventory
  class JsonFieldSelector
    def self.find_matching_paths(data, search_term, base_path = '')
      matches = []

      return matches if data.nil?
      return matches if search_term.nil? || search_term.empty?

      if data.is_a?(Array)
        data.each_with_index do |item, index|
          path =
            if base_path.empty?
              index.to_s
            else
              "#{base_path}/#{index}"
            end

          matches.concat(
            find_matching_paths(item, search_term, path)
          )
        end

        return matches
      end

      return matches unless data.is_a?(Hash)

      data.each do |key, value|
        path =
          if base_path.empty?
            key.to_s
          else
            "#{base_path}/#{key}"
          end

        if key.to_s.downcase.include?(search_term.downcase)
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

    def self.select_fields(data)
      selected_fields = []

      loop do
        print 'Search JSON fields: '
        search_term = $stdin.gets&.chomp

        if search_term.nil? || search_term.empty?
          puts 'Please enter a search term'
          next
        end

        matches = find_matching_paths(data, search_term)

        if matches.empty?
          puts 'No matching JSON fields found'
          next
        end

        matches.each_with_index do |match, index|
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

          if field_name.nil? || field_name.empty?
            field_name = selected_match['path'].split('/').last
          end

          selected_fields << {
            'name' => field_name,
            'path' => selected_match['path']
          }
        end

        puts
        puts 'Selected fields:'

        selected_fields.each_with_index do |field, index|
          puts "#{index + 1}. #{field['name']} — #{field['path']}"
        end

        puts
        puts '1. Search for more fields'
        puts '2. Finish'
        print 'Select an option: '

        choice = $stdin.gets&.chomp

        break if choice == '2'
      end

      selected_fields
    end
  end
end