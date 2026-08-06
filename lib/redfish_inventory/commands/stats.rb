# frozen_string_literal: true

module RedfishInventory
  module Commands
    class Stats
      def self.overview
        assets_data = ApiClient.get('/assets')
        assets = assets_data['assets']
        racks_data = ApiClient.get('/racks')
        racks = racks_data['racks']


        asset_count = assets.length
        rack_count = racks.length

        tracked_data_count = assets.sum do |asset|
          (asset['data'] || []).length
        end

        average_assets_per_rack =
          if rack_count.zero?
            0
          else
            asset_count.to_f / rack_count
          end

        used_rack_ids = assets.map { |asset| asset['rackId'] }.uniq

        empty_rack_count = racks.count do |rack|
          !used_rack_ids.include?(rack['id'])
        end

        puts
        puts 'Redfish Inventory Statistics'
        puts '-' * 40
        puts "Assets: #{asset_count}"
        puts "Racks: #{rack_count}"
        puts "Tracked data fields: #{tracked_data_count}"
        puts format(
          'Average assets per rack: %.1f',
          average_assets_per_rack
        )
        puts "Empty racks: #{empty_rack_count}"


        puts
      end

      def self.racks
        assets_data = ApiClient.get('/assets')
        assets = assets_data['assets']
        racks_data = ApiClient.get('/racks')
        racks = racks_data['racks']

        puts
        puts 'Rack Statistics'
        puts '-' * 60

        racks.each do |rack|
          rack_assets = assets.select do |asset|
            asset['rackId'] == rack['id']
          end

          used_units = rack_assets.sum do |asset|
            asset['size'].to_i
          end

          total_units = rack['size'].to_i
          free_units = total_units - used_units

          utilisation =
            if total_units.zero?
              0
            else
              used_units.to_f / total_units * 100
            end

          puts "Rack: #{rack['name']} (ID: #{rack['id']})"
          puts "Assets: #{rack_assets.length}"
          puts "Capacity: #{total_units}U"
          puts "Used: #{used_units}U"
          puts "Free: #{free_units}U"
          puts format('Utilisation: %.1f%%', utilisation)
          puts '-' * 60
        end
      end

      def self.assets
        assets_data = ApiClient.get('/assets')
        assets = assets_data['assets']

        asset_count = assets.length

        assets_with_data = assets.count do |asset|
          !(asset['data'] || []).empty?
        end

        assets_without_data = asset_count - assets_with_data

        tracked_data_count = assets.sum do |asset|
          (asset['data'] || []).length
        end

        average_tracked_fields =
          if asset_count.zero?
            0
          else
            tracked_data_count.to_f / asset_count
          end

        most_tracked_asset = assets.max_by do |asset|
          (asset['data'] || []).length
        end

        puts
        puts 'Asset Statistics'
        puts '-' * 60
        puts "Total assets: #{asset_count}"
        puts "Assets with tracked data: #{assets_with_data}"
        puts "Assets without tracked data: #{assets_without_data}"
        puts "Total tracked fields: #{tracked_data_count}"
        puts format(
          'Average tracked fields per asset: %.1f',
          average_tracked_fields
        )

        if most_tracked_asset
          tracked_fields = (most_tracked_asset['data'] || []).length

          puts(
            "Most tracked asset: #{most_tracked_asset['name']} " \
            "(#{tracked_fields} fields)"
          )
        end

        puts '-' * 60
      end
      
    end
  end
end