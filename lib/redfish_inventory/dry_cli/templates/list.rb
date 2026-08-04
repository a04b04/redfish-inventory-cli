# frozen_string_literal: true
 
require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Templates
      class List < Dry::CLI::Command
        desc 'List all templates'

        def call(**)
          Commands::Templates.list
        end
      end
    end
  end
end