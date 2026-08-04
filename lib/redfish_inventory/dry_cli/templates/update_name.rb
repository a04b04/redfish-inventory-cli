# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class Update < Dry::CLI::Command
        desc 'Update a template name by ID'

        argument :id,
                 required: true,
                 type: :integer,
                 desc: 'Template ID'

        option :name,
                 required: true,
                 desc: 'New template name'

        def call(id:, name:, **)
          Commands::Templates.update(id, name)
        end
      end
    end
  end
end