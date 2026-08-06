# frozen_string_literal: true

require 'tty-prompt'

module RedfishInventory
  module Interactive
    class RolesMenu
      def initialize
        @prompt = TTY::Prompt.new(
          symbols: {
            marker: '>'
          },
          active_color: :green
        )
      end

      def select
        loop do
          puts
          puts Theme.heading('Main Menu > Roles')
          puts

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'List Roles', :list
            menu.choice 'Show Role', :show
            menu.choice 'Create Role', :create
            menu.choice 'Alter Permissions', :alter_permissions
            menu.choice 'Delete Role', :delete
            menu.choice 'Back', :back
          end

          case choice
          when :list
            Commands::Roles.list
            @prompt.keypress('Press any key to go back...')

          when :show
            show_role

          when :create
            create_role
          
          when :alter_permissions
            alter_permissions
          when :delete
            delete_role
          when :back
            return
          end
        end
      end

      def select_role(message = 'Select a role:')
        data = ApiClient.get('/roles')
        roles = data['roles'] || []

        if roles.empty?
          puts Theme.warning('No roles found')
          return
        end

        choices = roles.map do |role|
          {
            name: "#{role['name']} (ID: #{role['id']})",
            value: role
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }
        selected_role = @prompt.select(
          message,
          choices,
          cycle: true
        )

        return if selected_role == :back
        selected_role
      end

      def show_role
        role = select_role('Select a role to view:')
        return if role.nil?

        Commands::Roles.show(role['id'])
        @prompt.keypress('Press any key to go back...')
      end

      def create_role
        puts
        puts Theme.heading('Main Menu > Roles > Create Role')
        puts

        name = @prompt.ask(
          'Role name:',
          required: true
        )

        permissions = ApiClient.get('/permissions')

        if permissions.empty?
          puts Theme.warning('No permissions found')
          @prompt.keypress('Press any key to go back...')
          return
        end

        choices = permissions
                  .sort_by { |permission| permission['id'].to_i }
                  .map do |permission|
          {
            name: "#{permission['name']} (ID: #{permission['id']})",
            value: permission['id']
          }
        end

        selected_permission_ids = @prompt.multi_select(
          'Select permissions for this role:',
          choices,
          per_page: 12,
          cycle: true
        )

        if selected_permission_ids.empty?
          puts Theme.warning('Please select at least one permission')
          @prompt.keypress('Press any key to go back...')
          return
        end

        Commands::Roles.create(
          name,
          selected_permission_ids
        )

        puts
        puts Theme.success("Role '#{name}' has been created")
        @prompt.keypress('Press any key to go back...')
      end

      def alter_permissions
        role = select_role('Select a role to alter:')
        return if role.nil?

        permissions = ApiClient.get('/permissions')

        if permissions.empty?
          puts Theme.warning('No permissions found')
          @prompt.keypress('Press any key to go back...')
          return
        end

        current_permission_ids = (role['permissions'] || []).map do |permission|
          permission['id'].to_i
        end

        choices = permissions
                  .sort_by { |permission| permission['id'].to_i }
                  .map do |permission|
          {
            name: "#{permission['name']} (ID: #{permission['id']})",
            value: permission['id'].to_i
          }
        end

        selected_permission_ids = @prompt.multi_select(
          "Alter permissions for '#{role['name']}':",
          choices,
          default: current_permission_ids,
          per_page: 15,
          cycle: true
        )

        permissions_to_add =
          selected_permission_ids - current_permission_ids

        permissions_to_remove =
          current_permission_ids - selected_permission_ids

        if permissions_to_add.empty? && permissions_to_remove.empty?
          puts Theme.warning('No permission changes were made')
          @prompt.keypress('Press any key to go back...')
          return
        end

        unless permissions_to_add.empty?
          Commands::Roles.add_permissions(
            role['id'],
            permissions_to_add
          )
        end

        unless permissions_to_remove.empty?
          Commands::Roles.remove_permissions(
            role['id'],
            permissions_to_remove
          )
        end

        puts
        puts Theme.success(
          "Permissions updated for '#{role['name']}'"
        )

        @prompt.keypress('Press any key to go back...')
      end

      def delete_role
        role = select_role('Select a role to delete:')
        return if role.nil?

        confirmed = @prompt.yes?(
          "Delete '#{role['name']}' (ID: #{role['id']})?"
        )

        unless confirmed
          puts Theme.warning('Role deletion cancelled')
          return
        end

        Commands::Roles.delete(role['id'])

        puts
        puts Theme.success(
          "Role '#{role['name']}' has been deleted"
        )

        @prompt.keypress('Press any key to go back...')
      end




    end
  end
end