# frozen_string_literal: true

require 'tty-table'

module RedfishInventory
  module Commands
    class Roles
      def self.list
        data = ApiClient.get('/roles')
        roles = data['roles'] || []

        if roles.empty?
          puts 'No roles found'
          return
        end

        roles.each do |role|
          permissions = role['permissions'] || []

          table = TTY::Table.new(
            header: ['ID', 'Role', 'Permission Count'],
            rows: [
              [
                role['id'],
                role['name'],
                permissions.length
              ]
            ]
          )

          puts
          puts table.render(:unicode, padding: [0, 1])

          puts
          puts 'Permissions:'

          if permissions.empty?
            puts '  None'
          else
            permissions.each do |permission|
              puts "  #{permission['id']}. #{permission['name']}"
            end
          end
        end

        puts
        puts "Page #{data['page']} of #{data['totalPage']}"
        puts "Total roles: #{data['total']}"
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: roles show <id>'
          return
        end

        role = ApiClient.get("/roles/#{id}")
        permissions = role['permissions'] || []

        role_table = TTY::Table.new(
          header: ['ID', 'Role', 'Permission Count'],
          rows: [
            [
              role['id'],
              role['name'],
              permissions.length
            ]
          ]
        )

        puts
        puts role_table.render(:unicode, padding: [0, 1])

        puts
        puts 'Permissions'

        if permissions.empty?
          puts 'No permissions assigned'
          return
        end

        permission_rows = permissions
                          .sort_by { |permission| permission['id'].to_i }
                          .map do |permission|
          [
            permission['id'],
            permission['name']
          ]
        end

        permissions_table = TTY::Table.new(
          header: ['ID', 'Permission'],
          rows: permission_rows
        )

        puts permissions_table.render(:unicode, padding: [0, 1])
      end

      def self.create(name, permission_ids)
        if name.nil? || name.empty?
          puts 'Role name cannot be empty'
          return
        end

        if permission_ids.empty?
          puts 'Select at least one permission'
          return
        end

        payload = {
          'name' => name,
          'permissions' => permission_ids
        }

        role = ApiClient.post('/roles', payload)

        puts
        puts "Role '#{role['name']}' created successfully"
        puts

        show(role['id'])

        role
      end

      def self.delete(id)
        if id.nil?
          puts"Usage: roles delete <id>"
          return
        end

        ApiClient.delete("/roles/#{id}")
        puts "Role #{id} deleted"
      end

      def self.add_permissions(role_id, permission_ids)
        payload = {
          'permissions' => permission_ids
        }

        role = ApiClient.post(
          "/roles/permissions/#{role_id}/add",
          payload
        )

        puts "Permissions added to role #{role_id}"
        show(role_id)

        role
      end

      def self.remove_permissions(role_id, permission_ids)
        role = ApiClient.get("/roles/#{role_id}")

        current_permission_ids = (role['permissions'] || []).map do |permission|
          permission['id'].to_i
        end

        missing_permission_ids = permission_ids.reject do |permission_id|
          current_permission_ids.include?(permission_id)
        end

        unless missing_permission_ids.empty?
          puts(
            "Role #{role_id} does not have permission IDs: " \
            "#{missing_permission_ids.join(', ')}"
          )
          return
        end

        payload = {
          'permissions' => permission_ids
        }

        updated_role = ApiClient.post(
          "/roles/permissions/#{role_id}/remove",
          payload
        )

        puts "Permissions removed from role #{role_id}"
        show(role_id)

        updated_role
      end


    end
  end
end