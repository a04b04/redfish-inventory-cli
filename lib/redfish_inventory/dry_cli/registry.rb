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
      register 'assets add-data', Assets::AddData
      register 'assets delete-data', Assets::DeleteData

      register 'racks list', Racks::List
      register 'racks show', Racks::Show
      register 'racks create', Racks::Create
      register 'racks update', Racks::Update
      register 'racks delete', Racks::Delete
      register 'racks list-assets', Racks::ListAssets

      register 'interactive', Interactive, aliases: ['i']

      register 'templates list', Templates::List
      register 'templates show', Templates::Show
      register 'templates create', Templates::Create
      register 'templates delete', Templates::Delete
      register 'templates update-name', Templates::Update
      register 'templates add-path', Templates::AddPath
      register 'templates update-path', Templates::UpdatePath

      register 'stats', Stats::Stats
      register 'stats racks', Stats::Racks
      register 'stats assets', Stats::Assets

      register 'login', Auth::Login
      register 'remove-token', Auth::RemoveToken

    end
  end
end