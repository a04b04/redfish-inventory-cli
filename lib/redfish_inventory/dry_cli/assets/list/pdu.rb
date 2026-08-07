# pdus.rb

module RedfishInventory
  module DryCLI
    module Assets
      class ListPdus < Dry::CLI::Command
        desc 'List all PDU assets'

        def call(**)
          Commands::Assets.list_pdus
        end
      end
    end
  end
end