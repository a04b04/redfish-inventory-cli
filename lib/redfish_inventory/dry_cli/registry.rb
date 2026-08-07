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


      #V2 stuff
      register 'assets create-server', Assets::CreateServer
      register 'assets create-storage', Assets::CreateStorage
      register 'assets create-generic', Assets::CreateGeneric
      register 'assets create-pdu', Assets::CreatePdu
      register 'assets create-ups', Assets::CreateUps

      register 'assets list-servers', Assets::ListServers
      register 'assets list-pdu', Assets::ListPdus
      register 'assets list-storage', Assets::ListStorage
      register 'assets list-ups', Assets::ListUps

      register 'interactive', Interactive, aliases: ['i']

      register 'templates list', Templates::List
      register 'templates show', Templates::Show
      register 'templates create', Templates::Create
      register 'templates delete', Templates::Delete
      register 'templates update-name', Templates::Update
      register 'templates add-path', Templates::AddPath
      register 'templates update-path', Templates::UpdatePath

      register 'stats', Stats::Stats
      register 'stats assets', Stats::Assets

      register 'login', Auth::Login
      register 'remove-token', Auth::RemoveToken

      register 'permissions list', Permissions::List

      register 'roles list', Roles::List
      register 'roles show', Roles::Show
      register 'roles create', Roles::Create
      register 'roles delete', Roles::Delete
      register 'roles add-permissions', Roles::AddPermissions
      register 'roles remove-permissions', Roles::RemovePermissions

      register 'config set-url', Config::SetUrl

      register 'user create', Users::Create

    end
  end
end