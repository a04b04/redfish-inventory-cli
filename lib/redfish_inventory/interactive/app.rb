module RedfishInventory
  module Interactive
    class App
      def run
        loop do
          choice = MainMenu.new.select

          case choice
          when :assets
            AssetsMenu.new.select
          when :racks
            RacksMenu.new.select
          when :templates
            TemplatesMenu.new.select
          when :stats
            StatsMenu.new.select
          when :exit
            break
          end
        end

        puts
        puts Theme.success('Goodbye!')
      end
    end
  end
end