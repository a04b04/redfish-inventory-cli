# storage.rb

module RedfishInventory
  module DryCLI
    module Assets
      class ListStorage < Dry::CLI::Command
        desc 'List all storage assets'

        def call(**)
          Commands::Assets.list_storage
        end
      end
    end
  end
end