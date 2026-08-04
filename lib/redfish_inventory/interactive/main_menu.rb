require 'tty-prompt'

module RedfishInventory
  module Interactive
    class MainMenu
      def initialize
        @prompt = TTY::Prompt.new(
          symbols: {
            marker: '❯'
          },
          active_color: :green
        )
      end

      def select
        puts
        puts Theme.heading('Redfish Inventory CLI')
        puts

        @prompt.select(
          'Select an option:',
          cycle: true
        ) do |menu|
          menu.choice 'Assets', :assets
          menu.choice 'Racks', :racks
          menu.choice 'Templates', :templates
          menu.choice 'Stats', :stats
          menu.choice 'Exit', :exit
        end
      end
    end
  end
end