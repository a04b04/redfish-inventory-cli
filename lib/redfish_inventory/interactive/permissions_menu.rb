# frozen_string_literal: true

require 'tty-prompt'

module RedfishInventory
  module Interactive
    class PermissionsMenu
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
          puts Theme.heading('Main Menu > Permissions')
          puts

          choice = @prompt.select(
            'Select an option:',
            cycle: true
          ) do |menu|
            menu.choice 'List Permissions', :list
            menu.choice 'Back', :back
          end

          case choice
          when :list
            list_permissions
          when :back
            return
          end
        end
      end

      def list_permissions
        Commands::Permissions::list
        @prompt.keypress('Press any key to go back')
      end

    end
  end
end