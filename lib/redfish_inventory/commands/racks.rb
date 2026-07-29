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

        # demo code
      #  file_path = File.expand_path('../../../data/racks.json', __dir__)
      #  racks = JSON.parse(File.read(file_path))
        # remove above
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

        # Demo only remove this section
        # racks_file = File.expand_path('../../../data/racks.json', __dir__)
        # racks = JSON.parse(File.read(racks_file))
        # next_id = racks.empty? ? 1 : racks.map { |rack| rack['id'] }.max + 1

        # rack = {
        #   'id' => next_id,
        #   'name' => payload['name'],
        #   'size' => payload['size'].to_i,
        #   'notes' => payload['notes']
        # }

        # racks << rack
        # File.write(
        #   racks_file,
        #   JSON.pretty_generate(racks)
        # )
        # puts JSON.pretty_generate(rack)

        # End demo-only section
      end

      def self.show(id)
        if id.nil?
          puts 'Usage: racks show <id>'
          return
        end
        # Production:
        rack = ApiClient.get("/racks/#{id}")
        puts JSON.pretty_generate(rack)

        # Demo only — remove for production
        # file_path = File.expand_path('../../../data/racks.json', __dir__)
        # racks = JSON.parse(File.read(file_path))

        # rack = racks.find do |rack|
        #   rack['id'] == id.to_i
        # end

        # unless rack
        #   puts "Rack #{id} not found"
        #   return
        # end

        # puts JSON.pretty_generate(rack)
        # End demo-only section
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

        # Demo Only
        # racks_file = File.expand_path('../../../data/racks.json', __dir__)

        # racks = JSON.parse(File.read(racks_file))
        # rack = racks.find do |rack|
        #   rack['id'] == id.to_i
        # end
        # unless rack
        #   puts "Rack #{id} not found"
        #   return
        # end

        # payload.each do |field, value|
        #   rack[field] = value
        # end

        # File.write(
        #   racks_file,
        #   JSON.pretty_generate(racks)
        # )

        # End demo-only section
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

        # Demo only — remove this section for production
        # racks_file = File.expand_path('../../../data/racks.json', __dir__)
        # racks = JSON.parse(File.read(racks_file))

        # rack = racks.find do |rack|
        #   rack['id'] == id.to_i
        # end

        # unless rack
        #   puts "Rack #{id} not found"
        #   return
        # end

        # racks.delete(rack)

        # File.write(
        #   racks_file,
        #   JSON.pretty_generate(racks)
        # )
        # End demo-only section

        puts "Rack #{id} deleted"
      end

      def self.list_assets(id)
        if id.nil?
          puts 'Usage: racks list-assets <id>'
          return
        end
        # Production:
        assets = ApiClient.get("/racks/#{id}/assets")
        puts JSON.pretty_generate(assets)
        
        # Demo only below
        # assets_file = File.expand_path('../../../data/assets.json', __dir__)

        # assets = JSON.parse(File.read(assets_file))

        # rack_assets = assets.select do |asset|
        #   asset['rackId'] == id.to_i
        # end

        # puts JSON.pretty_generate(rack_assets)

        # End demo-only section
      end
    end
  end
end
