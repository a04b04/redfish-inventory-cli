require 'pastel'

module RedfishInventory
  module Interactive
    module Theme
      DIVIDER = '─' * 44

      def self.pastel
        @pastel ||= Pastel.new
      end

      def self.heading(text)
        pastel.bold.cyan(text)
      end

      def self.selected(text)
        pastel.bold.green(text)
      end

      def self.normal(text)
        pastel.white(text)
      end

      def self.success(text)
        pastel.green(text)
      end

      def self.error(text)
        pastel.red(text)
      end

      def self.warning(text)
        pastel.yellow(text)
      end

      def self.info(text)
        pastel.cyan(text)
      end

      def self.muted(text)
        pastel.dim(text)
      end

      def self.divider
        muted(DIVIDER)
      end

      def self.navigation_footer
        [
          divider,
          muted('↑↓ Navigate   Enter Select   Esc Back')
        ].join("\n")
      end
    end
  end
end