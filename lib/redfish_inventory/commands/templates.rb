# frozen_string_literal: true

require 'json'

module RedfishInventory
  module Commands
    class Templates
      def self.list
        templates = ApiClient.get('/templates')

        if templates.empty?
          puts 'No templates found'
          return
        end

        templates.each do |template|
          print_template_summary(template)
        end
      end

      def self.show(id)
        template = ApiClient.get("/templates/#{id}")
        print_template_summary(template)
      end

      def self.create(name, paths = [])
        payload = {
          'name' => name,
          'paths' => paths
        }

        template = ApiClient.post('/templates', payload)

        puts "Template '#{template['name']}' created"
        template
      end

      # Updating a template name by ID

      def self.update(id, name)
        payload = {
          'name' => name
        }
        template = ApiClient.patch("/templates/#{id}", payload)
        puts "Template #{id} updated"

        print_template_summary(template)
      end

      def self.delete(id)
        ApiClient.delete("/templates/#{id}")
        puts "Template #{id} deleted"
      end

      def self.list_paths(id)
        paths = ApiClient.get("/templates/#{id}/paths")

        if paths.empty?
          puts "Template #{id} has no paths"
          return
        end

        paths.each do |path|
          puts "ID: #{path['id']}"
          puts "Name: #{path['name']}"
          puts "Path: #{path['path']}"
          puts '-' * 40
        end
      end

      def self.add_path(id, name, path)
        payload = {
          'paths' => [
            {
              'name' => name,
              'path' => path
            }
          ]
        }

        created_paths = ApiClient.post(
          "/templates/#{id}/paths",
          payload
        )

        puts "Path '#{name}' added to template #{id}"

        created_paths
      end


      def self.select_and_update_path(template_id)
        paths = ApiClient.get("/templates/#{template_id}/paths")

        if paths.empty?
          puts "Template #{template_id} has no paths"
          return
        end

        puts
        puts "Paths for template #{template_id}:"
        puts

        paths.each do |template_path|
          puts(
            "#{template_path['id']}. " \
            "#{template_path['name']} — #{template_path['path']}"
          )
        end

        print "\nEnter the path ID to update: "
        path_id = $stdin.gets&.chomp&.to_i

        selected_path = paths.find do |template_path|
          template_path['id'] == path_id
        end

        unless selected_path
          puts "Path #{path_id} was not found in template #{template_id}"
          return
        end

        puts
        puts "Current name: #{selected_path['name']}"
        puts "Current path: #{selected_path['path']}"
        puts
        print 'Enter updates using --name= and/or --path=: '

        input = $stdin.gets&.chomp.to_s

        updates = {}

        input.scan(/--(name|path)=(?:"([^"]*)"|'([^']*)'|(\S+))/) do |key, double_quoted, single_quoted, unquoted|
          updates[key] = double_quoted || single_quoted || unquoted
        end

        if updates.empty?
          puts 'Please provide --name, --path, or both'
          return
        end

        update_path(template_id, path_id, updates)
      end

      def self.update_path(template_id, path_id, updates)
        payload = {}

        payload['name'] = updates['name'] if updates.key?('name')
        payload['path'] = updates['path'] if updates.key?('path')

        template_path = ApiClient.patch(
          "/templates/#{template_id}/paths/#{path_id}",
          payload
        )

        puts "Template path #{path_id} updated"
        puts JSON.pretty_generate(template_path)
      end

      def self.print_template_summary(template)
        puts
        puts "ID: #{template['id']}"
        puts "Name: #{template['name']}"

        paths = template['paths'] || []

        unless paths.empty?
          puts 'Paths:'

          paths.each do |path|
            puts "  #{path['name']}: #{path['path']}"
          end
        end

        puts '-' * 40
      end
    end
  end
end