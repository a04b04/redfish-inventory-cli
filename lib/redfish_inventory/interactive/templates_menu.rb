# frozen_string_literal: true

require 'tty-prompt'

module RedfishInventory
  module Interactive
    class TemplatesMenu
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
          puts Theme.heading('Main Menu > Templates')
          puts


          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'List Templates', :list
            menu.choice 'Show Template', :show
            menu.choice 'Create Template', :create
            menu.choice 'Create Template with JSON helper', :create_with_json
            menu.choice 'Delete Template', :delete
            menu.choice 'Add path to template', :add_path
            menu.choice 'Update path in template', :update_path
            menu.choice 'Back', :back
          end

          case choice
          when :list 
            Commands::Templates.list
            @prompt.keypress('Press any key to go back...')

          when :show
            show_template
          when :create
            create_template
          when :create_with_json
            create_template_with_json
          when :delete
            delete_template
          when :add_path
            add_path
          when :update_path
            update_path
          when :back
            return
          end



        end
      end

      def select_template(message = 'Select a template:')
        templates = ApiClient.get('/templates')

        if templates.empty?
          puts Theme.warning('No templates found')
          @prompt.keypress('Press any key to continue...')
          return
        end

        choices = templates.map do |template|
          {
            name: "#{template['name']} (ID: #{template['id']})",
            value: template
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }

        selected_template = @prompt.select(
          message,
          choices,
          cycle: true,
        )

        return if selected_template == :back

        selected_template
      end

      def show_template
        template = select_template('Select a template to view:')
        return if template.nil?

        Commands::Templates.show(template['id'])
        @prompt.keypress('Press any key to go back...')
      end

      def create_template_with_json
        
      end

      def create_template
        name = @prompt.ask(
          'Template name:',
          required: true
        )

        template = Commands::Templates.create(name)

        wants_paths = @prompt.yes?(
          "Would you like to add paths to '#{template['name']}'?"
        )

        unless wants_paths
          puts
          puts Theme.success("Template '#{template['name']}' created")
          @prompt.keypress('Press any key to continue...')
          return
        end

        add_paths_to_template(template['id'])
      end

      def add_paths_to_template(template_id)
        loop do
          path_name = @prompt.ask(
            'Path display name:',
            required: true
          )

          path = @prompt.ask(
            'JSON path:',
            required: true
          )

          Commands::Templates.add_path(
            template_id,
            path_name,
            path
          )

          add_another = @prompt.yes?(
            'Would you like to add another path?'
          )

          break unless add_another
        end

        puts
        puts Theme.success('Template paths added successfully')
        @prompt.keypress('Press any key to continue...')
      end

      def delete_template
        template = select_template('Select a template to delete:')
        return if template.nil?

        confirmed = @prompt.yes?(
          "Delete #{template['name']} (ID: #{template['id']})?"
        )

        return unless confirmed

        Commands::Templates.delete(template['id'])
      end

      def add_path
        template = select_template('Select a template to add a path to:')
        return if template.nil?

        path_name = @prompt.ask(
          'Path display name:',
          required: true
        )

        path = @prompt.ask(
          'JSON path:',
          required: true
        )

        Commands::Templates.add_path(
          template['id'],
          path_name,
          path
        )
      end

      def update_path
        template = select_template('Select a template:')
        return if template.nil?

        paths = ApiClient.get("/templates/#{template['id']}/paths")

        if paths.empty?
          puts Theme.warning("Template '#{template['name']}' has no paths")
          @prompt.keypress('Press any key to continue...')
          return
        end

        choices = paths.map do |template_path|
          {
            name: "#{template_path['name']} — #{template_path['path']}",
            value: template_path
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }

        selected_path = @prompt.select(
          'Select a path to update:',
          choices,
          cycle: true,
          per_page: 10
        )

        return if selected_path == :back

        updates = {}

        loop do
          puts
          puts Theme.heading("Updating path: #{selected_path['name']}")
          puts
          puts "Name: #{updates.fetch('name', selected_path['name'])}"
          puts "Path: #{updates.fetch('path', selected_path['path'])}"
          puts

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'Change Name', :name
            menu.choice 'Change Path', :path
            menu.choice 'Done', :done
            menu.choice 'Cancel', :cancel
          end

          case choice
          when :name
            updates['name'] = @prompt.ask(
              'New path name:',
              required: true,
              default: updates.fetch('name', selected_path['name'])
            )

          when :path
            updates['path'] = @prompt.ask(
              'New JSON path:',
              required: true,
              default: updates.fetch('path', selected_path['path'])
            )

          when :done
            if updates.empty?
              puts Theme.warning('No changes were made')
              return
            end

            Commands::Templates.update_path(
              template['id'],
              selected_path['id'],
              updates
            )

            puts
            puts Theme.success("Path '#{selected_path['name']}' updated")
            @prompt.keypress('Press any key to continue...')
            return

          when :cancel
            puts Theme.warning('Path update cancelled')
            return
          end
        end
      end






    end
  end
end