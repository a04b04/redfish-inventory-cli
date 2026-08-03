# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class Create < Dry::CLI::Command
        desc 'Create a rack'

        option :name,
               required: true,
               desc: 'Rack name, use quotes if it contains spaces'

        option :size,
               required: true,
               type: :integer,
               desc: 'Rack size'

        option :notes,
               desc: 'Optional rack notes, use quotes if it contains spaces'

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