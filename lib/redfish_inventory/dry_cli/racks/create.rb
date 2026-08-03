# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class Create < Dry::CLI::Command
        desc 'Create a rack'

        option :name,
               required: true,
               desc: 'Rack name'

        option :size,
               required: true,
               type: :integer,
               desc: 'Rack size'

        option :notes,
               desc: 'Optional rack notes'

        def call(name:, size:, notes: '', **)
          arguments = [
            "name=#{name}",
            "size=#{size}",
            "notes=#{notes}"
          ]

          Commands::Racks.create(arguments)
        end
      end
    end
  end
end