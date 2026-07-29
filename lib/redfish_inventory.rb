require_relative "redfish_inventory/api_client"
require_relative "redfish_inventory/cli"
require_relative "redfish_inventory/commands/assets"
require_relative "redfish_inventory/commands/racks"

require_relative "redfish_inventory/api_client"
require_relative "redfish_inventory/config"

module RedfishInventory
  def self.start(arguments)
    CLI.start(arguments)
  end
end