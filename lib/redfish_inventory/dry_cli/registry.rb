# frozen_string_literal: true

require 'dry/cli'

module RedfishInventory
  module DryCLI
    module Registry
      extend Dry::CLI::Registry

      register 'assets list', Assets::List
      register 'assets show', Assets::Show
      register 'assets create', Assets::Create
      register 'assets update', Assets::Update
      register 'assets update-json', Assets::UpdateJson
      register 'assets delete', Assets::Delete
      register 'assets show-version', Assets::ShowVersion

      register 'racks list', Racks::List
      register 'racks show', Racks::Show
      register 'racks create', Racks::Create
      register 'racks update', Racks::Update
      register 'racks delete', Racks::Delete
      register 'racks list-assets', Racks::ListAssets

      register 'interactive', Interactive, aliases: ['i']
    end
  end
end