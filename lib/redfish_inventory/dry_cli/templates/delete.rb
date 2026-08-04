# frozen_string_literal: true
 
require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class Delete < Dry::CLI::Command
        desc 'Delete a template'

        argument :id,
                 required: true,
                 type: :integer,
                 desc: 'Template ID'

        def call(id:, **)
          Commands::Templates.delete(id)
        end
      end
    end
  end
end