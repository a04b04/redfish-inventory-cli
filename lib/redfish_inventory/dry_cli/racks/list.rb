# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class List < Dry::CLI::Command
        desc 'List all racks'

        def call(**)
          Commands::Racks.list
        end
      end
    end
  end
end