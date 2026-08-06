# frozen_string_literal: true

require 'tty-table'

module RedfishInventory
  module Commands
    class Permissions
      def self.list
        permissions = ApiClient.get('/permissions')

        if permissions.empty?
          puts 'No permissions found'
          return
        end

        sorted_permissions = permissions.sort_by do |permission|
          permission['id'].to_i
        end

        rows = sorted_permissions.map do |permission|
          [
            permission['id'],
            permission['name']
          ]
        end

        table = TTY::Table.new(
          header: ['ID', 'Permission'],
          rows: rows
        )

        puts
        puts table.render(:unicode, padding: [0, 1])
      end
    end
  end
end