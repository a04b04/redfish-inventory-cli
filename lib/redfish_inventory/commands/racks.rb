# frozen_string_literal: true

require 'json'

module RedfishInventory
  module Commands
    class Racks
      def self.run(action, arguments)
        case action
        when 'list'
          list
        when 'show'
          show(arguments[0])
        when 'update-rack'
          update_rack(arguments[0], arguments.drop(1))
        when 'delete-rack'
          delete(arguments[0])
        when 'list-assets'
          list_assets(arguments[0])
        when 'create-rack'
          create(arguments)

        else puts "Unknown racks action: #{action}"
        end
      end

      def self.list
        # Production:
        racks = ApiClient.get("/racks")
        puts JSON.pretty_generate(racks)
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
          puts 'Usage: racks create-rack name="Rack A" size=42 notes=Optional notes" '
          return
        end

        # Production
        payload['size'] = payload['size'].to_i
        rack = ApiClient.post("/racks", payload)
        puts JSON.pretty_generate(rack)
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: racks show <id>'
          return
        end
        # Production:
        rack = ApiClient.get("/racks/#{id}")
        puts JSON.pretty_generate(rack)
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

        # Production:
        ApiClient.patch("/racks/#{id}", payload)
        puts "Rack #{id} updated"
        puts JSON.pretty_generate(payload)
      end

      def self.delete(id)
        if id.nil?
          puts 'Usage: racks delete <id>'
          return
        end

        # Production:
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
