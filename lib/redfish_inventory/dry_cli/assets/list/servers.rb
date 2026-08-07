module RedfishInventory
  module DryCLI
    module Assets
      class ListServers < Dry::CLI::Command
        desc 'List all server assets'

        def call(**)
          Commands::Assets.list_servers
        end


      end
    end
  end
end