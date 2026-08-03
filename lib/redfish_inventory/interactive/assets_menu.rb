require 'tty-prompt'

module RedfishInventory
  module Interactive
    class AssetsMenu
      def initialize
        @prompt = TTY::Prompt.new(
          symbols: {
            marker: ')'
          },
          active_color: :green
        )
      end

      def select
        puts
        puts Theme.heading("Main Menu > Assets")
        puts 

        choice = @prompt.select(
          'Select an option:',
          cycle: true
        ) do |menu|
          menu.choice 'List Assets', :list
          menu.choice 'Show Asset', :show
          menu.choice 'Create Asset', :create
          menu.choice 'Update Asset', :update
          menu.choice "Update JSON for an Asset", :update_json
          menu.choice 'Add Data to an Asset', :add_data
          menu.choice 'Delete Data from an Asset', :delete_data
          menu.choice 'Show Version', :show_version
          menu.choice 'Delete Asset', :delete_asset
          menu.choice 'Back', :back
        end

        case choice
        when :list
          Commands::Assets.list
        when :show
          show_asset
        when :delete_asset
          delete_asset
        when :create
          create_asset
        when :update
          update_asset
        when :update_json
          update_json
        when :show_version
          show_version
        when :add_data
          add_data
        when :delete_data
          delete_data
        when :back
          return

        end

        
        
      end


      private 
      def select_asset(message = 'Select an asset:')
        assets = ApiClient.get('/assets')

        if assets.empty?
          puts Theme.warning('No assets found')
          return
        end

        choices = assets.map do |asset|
          {
            name: "#{asset['name']} (ID: #{asset['id']})",
            value: asset
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }

        selected_asset = @prompt.select(
          message,
          choices,
          cycle: true
        )

        return if selected_asset == :back

        selected_asset
      end

      def show_asset
        asset = select_asset('Select an asset to view:')
        return if asset.nil?

        Commands::Assets.show(asset['id'])
      end

      def delete_asset
        asset = select_asset('Select an asset to delete:')
        return if asset.nil?

        confirmed = @prompt.yes?(
          "Delete #{asset['name']} (ID: #{asset['id']})?"
        )
        return unless confirmed

        Commands::Assets.delete(asset['id'])
      end

      def create_asset
        puts
        puts Theme.heading('Main Menu > Assets > Create Asset')
        puts

        file_path = @prompt.ask(
          'JSON file path:',
          required: true
        )

        name = @prompt.ask(
          'Asset name:',
          required: true
        )

        rack_id = @prompt.ask(
          'Rack ID:',
          required: true,
          convert: :int
        )

        size = @prompt.ask(
          'Size in U:',
          required: true,
          convert: :int
        )

        position = @prompt.ask(
          'Rack position:',
          required: true,
          convert: :int
        )

        arguments = [
          "name=#{name}",
          "rackId=#{rack_id}",
          "size=#{size}",
          "position=#{position}"
        ]

        Commands::Assets.create(file_path, arguments)
      end

      def update_asset
        asset = select_asset('Select an asset to update:')
        return if asset.nil?

        updates = {}

        loop do
          puts
          puts Theme.heading("Updating: #{asset['name']}")
          puts

          puts "Name: #{updates.fetch('name', asset['name'])}"
          puts "Rack: #{updates.fetch('rackId', asset['rackId'])}"
          puts "Size: #{updates.fetch('size', asset['size'])}U"
          puts "Position: #{updates.fetch('position', asset['position'])}"
          puts

          choice = @prompt.select(
            'Select a field to update:',
            cycle: true
          ) do |menu|
            menu.choice 'Name', :name
            menu.choice 'Rack', :rack_id
            menu.choice 'Size', :size
            menu.choice 'Position', :position
            menu.choice 'Done', :done
            menu.choice 'Cancel', :cancel
          end

          case choice
          when :name
            updates['name'] = @prompt.ask(
              'New name:',
              required: true,
              default: updates.fetch('name', asset['name'])
            )

          when :rack_id
            updates['rackId'] = @prompt.ask(
              'New rack ID:',
              required: true,
              convert: :int,
              default: updates.fetch('rackId', asset['rackId'])
            )

          when :size
            updates['size'] = @prompt.ask(
              'New size in U:',
              required: true,
              convert: :int,
              default: updates.fetch('size', asset['size'])
            )

          when :position
            updates['position'] = @prompt.ask(
              'New position:',
              required: true,
              convert: :int,
              default: updates.fetch('position', asset['position'])
            )

          when :done
            if updates.empty?
              puts Theme.warning('No changes were made')
              return
            end

            Commands::Assets.update_asset(asset['id'], updates)
            return

          when :cancel
            puts Theme.warning('Update cancelled')
            return
          end
        end
      end

      def update_json
        asset = select_asset('Select an asset to update JSON:')
        return if asset.nil?

        file_path = @prompt.ask(
          'JSON file path:',
          required: true
        )

        unless File.file?(file_path)
          puts Theme.error("File not found: #{file_path}")
          return
        end

        unless File.extname(file_path).downcase == '.json'
          puts Theme.error('The selected file must be a JSON file')
          return
        end

        confirmed = @prompt.yes?(
          "Replace the JSON for #{asset['name']} with #{File.basename(file_path)}?"
        )

        return unless confirmed

        Commands::Assets.update_json(asset['id'], file_path)
      end


      def add_data 
        asset = select_asset('Select an asset to add data:')
        return if asset.nil?

        Commands::Assets.add_data(asset['id'])

        puts 
        puts Theme.success("Data added to asset #{asset['name']} (ID: #{asset['id']})")
        @prompt.keypress('Press any key to continue...')
      end

      def delete_data
        asset = select_asset('Select an asset to remove data from:')
        return if asset.nil?

        data_fields = asset['data'] || []

        if data_fields.empty?
          puts Theme.warning("Asset '#{asset['name']}' has no tracked data")
          @prompt.keypress('Press any key to continue...')
          return
        end

        choices = data_fields.map do |field|
          {
            name: "#{field['name']}: #{field['value']}",
            value: field
          }
        end

        choices << {
          name: 'Back',
          value: :back
        }

        field = @prompt.select(
          'Select a data field to delete:',
          choices,
          cycle: true
        )

        return if field == :back

        confirmed = @prompt.yes?(
          "Delete '#{field['name']}' from #{asset['name']}?"
        )

        return unless confirmed

        ApiClient.delete(
          "/assets/#{asset['id']}/paths/#{field['id']}"
        )

        puts
        puts Theme.success(
          "'#{field['name']}' was removed from #{asset['name']}"
        )

        @prompt.keypress('Press any key to continue...')
      end

      def show_version
        asset = select_asset('Select an asset:')
        return if asset.nil?

        version = Commands::Assets.fetch_version(asset['id'], 0)

        loop do
          position = version.dig('pagination', 'position').to_i
          total = version.dig('pagination', 'total').to_i

          puts

          display_version = total - position
          puts Theme.heading("Version #{display_version} of #{total}")
          puts

          Commands::Assets.print_asset_summary(version)

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'Previous Version', :previous if position < total - 1
            menu.choice 'Next Version', :next if position.positive?
            menu.choice 'Show JSON', :json
            menu.choice 'Back', :back
          end

          case choice
            when :previous
              version = Commands::Assets.fetch_version(
                asset['id'],
                position + 1
              )

            when :next
              version = Commands::Assets.fetch_version(
                asset['id'],
                position - 1
              )

            when :json
              Commands::Assets.print_json(version)

            when :back
              return
          end

        end
      end

      

    

    end
  end
end