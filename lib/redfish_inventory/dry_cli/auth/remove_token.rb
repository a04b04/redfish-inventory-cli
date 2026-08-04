# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Auth
      class RemoveToken < Dry::CLI::Command
        desc 'Remove the locally stored authentication token'

        def call(**)
          unless RedfishInventory::Auth::TokenStore.saved?
            puts 'No authentication token is currently stored'
            return
          end

          RedfishInventory::Auth::TokenStore.delete

          puts 'Authentication token removed successfully'
        end
      end
    end
  end
end