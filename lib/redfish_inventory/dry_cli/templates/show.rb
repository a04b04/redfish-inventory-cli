# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class Show < Dry::CLI::Command
        desc 'Show a template'

        argument :id,
                 required: true,
                 type: :integer,
                 desc: 'Template ID'

        def call(id:, **)
          Commands::Templates.show(id)
        end
      end
    end
  end
end