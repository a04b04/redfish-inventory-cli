# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class Create < Dry::CLI::Command
        desc 'Create a template'

        option :name,
               required: true,
               desc: 'Template name'

        def call(name:, **)
          Commands::Templates.create(name)
        end
      end
    end
  end
end