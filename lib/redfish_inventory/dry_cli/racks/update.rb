# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Racks
      class Update < Dry::CLI::Command
        desc 'Update a rack'

        argument :id,
                 required: true,
                 desc: 'Rack ID'

        option :name,
               desc: 'New rack name, use quotes if it contains spaces'

        option :size,
               type: :integer,
               desc: 'New rack size'

        option :notes,
               desc: 'New rack notes, use quotes if it contains spaces'

        def call(id:, name: nil, size: nil, notes: nil, **)
          updates = []

          updates << "name=#{name}" unless name.nil?
          updates << "size=#{size}" unless size.nil?
          updates << "notes=#{notes}" unless notes.nil?

          Commands::Racks.update_rack(id, updates)
        end
      end
    end
  end
end