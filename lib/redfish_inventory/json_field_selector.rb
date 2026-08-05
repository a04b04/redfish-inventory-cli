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
  end
end