# frozen_string_literal: true

require 'tty-prompt'

module RedfishInventory
  module Interactive
    class RacksMenu
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
          puts Theme.heading('Main Menu > Racks')
          puts

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'List Racks', :list
            menu.choice 'Show Rack', :show
            menu.choice 'Create Rack', :create
            menu.choice 'Delete Rack', :delete
            menu.choice 'List Assets in Rack', :list_assets
            menu.choice 'Back', :back
          end

          case choice
          when :list
            Commands::Racks.list
            @prompt.keypress('Press any key to go back...')
          when :show
            show_rack
          when :create
            create_rack
          when :delete
            delete_rack
          when :list_assets
            list_rack_assets
          when :back
            return
          end
        end
      end

      private

      def select_rack(message = 'Select a rack:')
        data = ApiClient.get('/racks')
        racks = data['racks']

        if racks.empty?
          puts Theme.warning('No racks found')
          return
        end

        choices = racks.map do |rack|
          {
            name: "#{rack['name']} (ID: #{rack['id']})",
            value: rack
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }

        selected_rack = @prompt.select(
          message,
          choices,
          cycle: true
        )

        return if selected_rack == :back

        selected_rack
      end

      def show_rack
        rack = select_rack('Select a rack to view:')
        return if rack.nil?

        Commands::Racks.show(rack['id'])
        @prompt.keypress('Press any key to go back...')
      end

      def delete_rack
        rack = select_rack('Select a rack to delete:')
        return if rack.nil?

        confirmed = @prompt.yes?(
          "Delete #{rack['name']} (ID: #{rack['id']})?"
        )

        return unless confirmed

        Commands::Racks.delete(rack['id'])
      end

      def list_rack_assets
        loop do
          rack = select_rack('Select a rack:')
          return if rack.nil?

          browse_rack_assets(rack)
        end
      end

      def browse_rack_assets(rack)
        loop do
          assets = Commands::Racks.fetch_assets(rack['id'])

          if assets.empty?
            puts Theme.warning("No assets found in #{rack['name']}")
            @prompt.keypress('Press any key to go back...')
            return
          end

          choices = assets.map do |asset|
            {
              name: "#{asset['name']} (ID: #{asset['id']})",
              value: asset
            }
          end

          choices << { name: 'Back', value: nil }

          asset = @prompt.select(
            "Assets in #{rack['name']}:",
            choices,
            per_page: 10,
            cycle: true,
            active_color: :green
          )

          return if asset.nil?

          show_rack_asset(asset)
        end
      end

      def show_rack_asset(asset)
        loop do
          system('clear')

          puts Theme.heading("Main Menu > Racks > #{asset['name']}")
          puts

          Commands::Assets.print_asset_summary(asset)

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'Show JSON', :json
            menu.choice 'Back', :back
          end

          case choice
          when :json
            Commands::Assets.print_json(asset)
            @prompt.keypress('Press any key to continue...')
          when :back
            return
          end
        end
      end

      def create_rack
        puts
        puts Theme.heading('Main Menu > Racks > Create Rack')
        puts

        name = @prompt.ask(
          'Rack name:',
          required: true
        )

        size = @prompt.ask(
          'Rack size:',
          required: true,
          convert: :int
        )

        notes = @prompt.ask(
          'Notes:'
        )

        arguments = [
          "name=#{name}",
          "size=#{size}",
          "notes=#{notes}"
        ]

        Commands::Racks.create(arguments)
        puts 
        puts Theme.success("Rack '#{name}' has been created")
        @prompt.keypress('Press any key to go back ...')
      end
    end
  end
end