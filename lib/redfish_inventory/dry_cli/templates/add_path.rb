# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class AddPath < Dry::CLI::Command
        desc 'Add a path to a template'

        argument :template_id,
                 required: true,
                 type: :integer,
                 desc: 'Template ID'

        option :name,
               required: true,
               desc: 'Path name, use quotes if it contains spaces'

        option :path,
               required: true,
               desc: 'JSON path'

        def call(template_id:, name:, path:, **)
          Commands::Templates.add_path(template_id, name, path)
        end
      end
    end
  end
end

