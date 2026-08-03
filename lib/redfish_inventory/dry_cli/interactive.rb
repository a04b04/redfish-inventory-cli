# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    class Interactive < Dry::CLI::Command
      desc 'Start interactive mode'

      def call(**)
        RedfishInventory::Interactive::App.new.run
      end
    end
  end
end