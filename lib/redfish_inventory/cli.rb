module RedfishInventory
  class CLI
    def self.start(arguments)
      if arguments.include?('--interactive') || arguments.include?('-i')
        choice = Interactive::MainMenu.new.select

        case choice
        when :assets
          RedfishInventory::Interactive::AssetsMenu.new.select
        when :racks
          RedfishInventory::Interactive::RacksMenu.new.select
        when :exit
          puts Interactive::Theme.success('Goodbye!')
        end

        return
      end

      command = arguments[0]
      action = arguments[1]

      case command
      when 'assets'
        Commands::Assets.run(action, arguments.drop(2))
      when 'racks'
        Commands::Racks.run(action, arguments.drop(2))
      else
        puts 'Usage:'
        puts '  redfish-inventory assets <action>'
        puts '  redfish-inventory racks <action>'
        puts '  redfish-inventory --interactive'
        puts '  redfish-inventory -i'
      end
    end
  end
end