require_relative 'redfish_inventory/config'
require_relative 'redfish_inventory/api_client'

require_relative 'redfish_inventory/commands/assets'
require_relative 'redfish_inventory/commands/racks'

require_relative 'redfish_inventory/interactive/theme'
require_relative 'redfish_inventory/interactive/main_menu'
require_relative 'redfish_inventory/interactive/assets_menu'
require_relative 'redfish_inventory/interactive/racks_menu'
require_relative 'redfish_inventory/interactive/app'

require_relative 'redfish_inventory/dry_cli/assets/list'
require_relative 'redfish_inventory/dry_cli/assets/show'
require_relative 'redfish_inventory/dry_cli/assets/create'
require_relative 'redfish_inventory/dry_cli/assets/update'
require_relative 'redfish_inventory/dry_cli/assets/update_json'
require_relative 'redfish_inventory/dry_cli/assets/delete'
require_relative 'redfish_inventory/dry_cli/assets/show_version'
require_relative 'redfish_inventory/dry_cli/assets/add_data'
require_relative 'redfish_inventory/dry_cli/assets/delete_data'

require_relative 'redfish_inventory/dry_cli/racks/list'
require_relative 'redfish_inventory/dry_cli/racks/show'
require_relative 'redfish_inventory/dry_cli/racks/create'
require_relative 'redfish_inventory/dry_cli/racks/update'
require_relative 'redfish_inventory/dry_cli/racks/delete'
require_relative 'redfish_inventory/dry_cli/racks/list_assets'

require_relative 'redfish_inventory/dry_cli/interactive'
require_relative 'redfish_inventory/dry_cli/registry'

module RedfishInventory
  def self.start(arguments)
    Dry::CLI.new(DryCLI::Registry).call(arguments: arguments)
  end
end