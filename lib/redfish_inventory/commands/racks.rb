# frozen_string_literal: true

require 'json'
require 'tty-table'

module RedfishInventory
  module Commands
    class Racks

      def self.list
        data = ApiClient.get('/racks')
        racks = data['racks'] || []

        if racks.empty?
          puts 'No racks found'
          return
        end

        rows = racks.map do |rack|
          [
            rack['id'],
            rack['name'],
            "#{rack['size']}U",
            rack['notes'].to_s.empty? ? '-' : rack['notes']
          ]
        end

        table = TTY::Table.new(
          header: ['ID', 'Name', 'Size', 'Notes'],
          rows: rows
        )

        puts
        puts table.render(:unicode, padding: [0, 1])

        puts
        puts "Page #{data['page']} of #{data['totalPages']}"
        puts "Total racks: #{data['total']}"
      end


      def self.create(arguments)
        payload = {
          'name' => '',
          'size' => '',
          'notes' => ''
        }

        arguments.each do |argument|
          key, value = argument.split('=', 2)
          payload[key] = value
        end

        if payload['name'].empty? || payload['size'].empty?
          puts 'Usage: racks create --name="Rack A" --size=42 --notes="Optional notes"'
          return
        end

        payload['size'] = payload['size'].to_i
        rack = ApiClient.post("/racks", payload)
        puts JSON.pretty_generate(rack)
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: racks show <id>'
          return
        end

        rack = ApiClient.get("/racks/#{id}")

        notes =
          if rack['notes'].to_s.empty?
            '-'
          else
            rack['notes']
          end

        table = TTY::Table.new(
          header: ['ID', 'Name', 'Size', 'Notes'],
          rows: [
            [
              rack['id'],
              rack['name'],
              "#{rack['size']}U",
              notes
            ]
          ]
        )

        puts
        puts table.render(:unicode, padding: [0, 1])
      end

      def self.update_rack(id, updates)
        if id.nil? || updates.empty?
          puts 'Usage: racks update-rack <id> field=value field=value'
          return
        end
        payload = {}

        updates.each do |update|
          field, value = update.split('=', 2)

          if field.nil? || value.nil?
            puts "Invalid update: #{update}"
            puts 'Use the format field=value'
            return
          end

          payload[field] = value
        end

        ApiClient.patch("/racks/#{id}", payload)
        puts "Rack #{id} updated"
        puts JSON.pretty_generate(payload)
      end

      def self.delete(id)
        if id.nil?
          puts 'Usage: racks delete <id>'
          return
        end

        ApiClient.delete("/racks/#{id}")
        puts "Rack #{id} deleted"
      end

      def self.list_assets(rack_id)
        if rack_id.nil?
          puts 'Usage: racks list-assets <rack-id>'
          return
        end

        assets = fetch_assets(rack_id)

        if assets.empty?
          puts "No assets found in rack #{rack_id}"
          return
        end

        assets.each do |asset|
          Commands::Assets.print_asset_summary(asset)
        end
      end

      def self.fetch_assets(rack_id)
        ApiClient.get("/racks/#{rack_id}/assets")
      end
      
    end
  end
end
