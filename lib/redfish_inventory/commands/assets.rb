require "json"

module RedfishInventory
  module Commands
    class Assets
      def self.run(action, arguments)
        case action
        when "list"
          list
        when "show"
          show(arguments[0])
        when "update-json"
          update_json(arguments[0], arguments[1])
        when "update-asset"
          update_asset(arguments[0], arguments.drop(1))
        when "delete-asset"
          delete(arguments[0])
        else 
          puts "Unknown assets action: #{action}"
        end 
      end
      def self.list
        file_path = File.expand_path("../../../data/assets.json", __dir__)
        assets = JSON.parse(File.read(file_path))
        puts assets
      end

      def self.show(id)
        if id.nil?
          puts "Usage: assets show <id>"
          return
        end

        # Production:
        # asset = ApiClient.get("/assets/#{id}")
        # puts JSON.pretty_generate(asset)
      end

      def self.update_json(id, file_path)
        unless File.exist?(file_path)
          puts "File not found: #{file_path}"
          return
        end

        raw_json = JSON.parse(File.read(file_path))

        payload = {
          json: raw_json
        }
        #uncomment line below for real deployment
        #ApiClient.post("/assets/#{id}", payload)
        
        #demo code remove in deployment
          assets_file = File.expand_path("../../../data/assets.json", __dir__)
          assets = JSON.parse(File.read(assets_file))
          asset = assets.find do |asset|
            asset["id"] == id.to_i
          end
          unless asset
            puts "Asset #{id} not found"
            return
          end
          asset["json"] = raw_json
          File.write(
            assets_file,
            JSON.pretty_generate(assets)
          )
          puts "JSON added to asset #{id}"
      end

      def self.update_asset(id, updates)
        if id.nil? || updates.empty?
          puts 'Usage: assets update-asset <id> field=value field=value'
          return
        end

        payload = {}

        updates.each do |update|
          field, value = update.split("=", 2)

          if field.nil? || value.nil?
            puts "Invalid update: #{update}"
            puts "Use the format field=value"
            return
          end

          payload[field] = value
        end

        # Production:
        # ApiClient.patch("/assets/#{id}", payload)

        # Demo only:
        assets_file = File.expand_path("../../../data/assets.json", __dir__)
        assets = JSON.parse(File.read(assets_file))

        asset = assets.find do |asset|
          asset["id"] == id.to_i
        end

        unless asset
          puts "Asset #{id} not found"
          return
        end

        payload.each do |field, value|
          asset[field] = value
        end

        File.write(
          assets_file,
          JSON.pretty_generate(assets)
        )
        #remove above till last comment

        puts "Asset #{id} updated"
        puts JSON.pretty_generate(payload)
      end

      def self.delete(id)
        if id.nil?
          puts "Usage: assets delete <id>"
          return
        end

        # Production:
        # ApiClient.delete("/assets/#{id}")

        # Demo only — remove this section for production
        assets_file = File.expand_path("../../../data/assets.json", __dir__)
        assets = JSON.parse(File.read(assets_file))

        asset = assets.find do |asset|
          asset["id"] == id.to_i
        end

        unless asset
          puts "Asset #{id} not found"
          return
        end

        assets.delete(asset)

        File.write(
          assets_file,
          JSON.pretty_generate(assets)
        )
        # End demo-only section

        puts "Asset #{id} deleted"
      end

      def self.show_version(id, index)

        if id.nil? || index.nil?

          puts "Usage: assets show-version <id> <index>"

          return

        end

        # Production:

        # asset = ApiClient.get("/assets/#{id}/#{index}")

        # puts JSON.pretty_generate(asset)

      end

    end
  end
end

