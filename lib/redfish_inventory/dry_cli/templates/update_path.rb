# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class UpdatePath < Dry::CLI::Command
        desc 'Select and update a path within a template'

        argument :template_id,
                 required: true,
                 type: :integer,
                 desc: 'Template ID'

        def call(template_id:, **)
          Commands::Templates.select_and_update_path(template_id)
        end
      end
    end
  end
end