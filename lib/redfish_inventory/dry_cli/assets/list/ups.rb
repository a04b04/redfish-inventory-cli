# ups.rb

module RedfishInventory
  module DryCLI
    module Assets
      class ListUps < Dry::CLI::Command
        desc 'List all UPS assets'

        def call(**)
          Commands::Assets.list_ups
        end
      end
    end
  end
end