# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Assets
      class ShowPdu < Dry::CLI::Command
        desc 'Show a PDU asset'

        argument :id,
                 required: true,
                 desc: 'PDU ID'

        def call(id:, **)
          Commands::Assets.show_pdu(id)
        end
      end
    end
  end
end