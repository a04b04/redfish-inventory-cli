module RedfishInventory
  class CLI 
    def self.start(arguments)
      
      command = arguments[0]
      action = arguments[1]

      case command
      when "assets"
        Commands::Assets.run(action, arguments.drop(2))
      when "racks"
        Commands::Racks.run(action, arguments.drop(2))
      else
        puts "Usage:"
        puts "  redfish-inventory assets <action>"
        puts "  redfish-inventory racks <action>"
      end

    end
  end
end