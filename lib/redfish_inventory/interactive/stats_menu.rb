# frozen_string_literal: true

require 'tty-prompt'

module RedfishInventory
  module Interactive
    class StatsMenu
      def initialize
        @prompt = TTY::Prompt.new(
          symbols: {
            marker: '>'
          },
          active_color: :green
        )
      end

      def select 
        loop do
          puts
          puts Theme.heading('Main Menu > Stats')
          puts

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'Show General Stats', :show
            menu.choice 'Show Asset Stats', :assets
            menu.choice 'Back', :back
          end

          case choice
          when :show
            Commands::Stats.overview
            @prompt.keypress('Press any key to go back...')
          when :assets
            Commands::Stats.assets
            @prompt.keypress('Press any key to go back...')
          when :back
            return
          end
        end
      end



    end
  end
end