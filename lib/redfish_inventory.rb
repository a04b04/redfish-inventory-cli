# frozen_string_literal: true
 
require_relative 'redfish_inventory/config_store'
require_relative 'redfish_inventory/config'
require_relative 'redfish_inventory/api_client'

require_relative 'redfish_inventory/dry_cli/config/set_url'


require_relative 'redfish_inventory/dry_cli/auth/login'
require_relative 'redfish_inventory/auth/token_store'
require_relative 'redfish_inventory/dry_cli/auth/remove_token'

require_relative 'redfish_inventory/dry_cli/auth/session_manager'

require_relative 'redfish_inventory/json_field_selector'

require_relative 'redfish_inventory/errors'

require_relative 'redfish_inventory/commands/assets'

require_relative 'redfish_inventory/commands/stats'
require_relative 'redfish_inventory/dry_cli/stats/stats'
require_relative 'redfish_inventory/dry_cli/stats/assets'

require_relative 'redfish_inventory/interactive/theme'
require_relative 'redfish_inventory/interactive/main_menu'
require_relative 'redfish_inventory/interactive/assets_menu'
require_relative 'redfish_inventory/interactive/templates_menu'
require_relative 'redfish_inventory/interactive/stats_menu'
require_relative 'redfish_inventory/interactive/app'
require_relative 'redfish_inventory/interactive/roles_menu'
require_relative 'redfish_inventory/interactive/permissions_menu'


require_relative 'redfish_inventory/dry_cli/assets/list'
require_relative 'redfish_inventory/dry_cli/assets/show'
require_relative 'redfish_inventory/dry_cli/assets/create'
require_relative 'redfish_inventory/dry_cli/assets/update'
require_relative 'redfish_inventory/dry_cli/assets/update_json'
require_relative 'redfish_inventory/dry_cli/assets/delete'
require_relative 'redfish_inventory/dry_cli/assets/show_version'
require_relative 'redfish_inventory/dry_cli/assets/add_data'
require_relative 'redfish_inventory/dry_cli/assets/delete_data'

#v2 assets requirements
require_relative 'redfish_inventory/dry_cli/assets/create/create_server'
require_relative 'redfish_inventory/dry_cli/assets/create/create_storage'
require_relative 'redfish_inventory/dry_cli/assets/create/create_generic'
require_relative 'redfish_inventory/dry_cli/assets/create/create_pdu'
require_relative 'redfish_inventory/dry_cli/assets/create/create_ups'

require_relative 'redfish_inventory/dry_cli/assets/list/pdu'
require_relative 'redfish_inventory/dry_cli/assets/list/servers'
require_relative 'redfish_inventory/dry_cli/assets/list/storage'
require_relative 'redfish_inventory/dry_cli/assets/list/ups'

require_relative 'redfish_inventory/dry_cli/assets/show/pdu'
require_relative 'redfish_inventory/dry_cli/assets/show/servers'
require_relative 'redfish_inventory/dry_cli/assets/show/storage'
require_relative 'redfish_inventory/dry_cli/assets/show/ups'

require_relative 'redfish_inventory/dry_cli/assets/delete/delete'



require_relative 'redfish_inventory/dry_cli/interactive'

require_relative 'redfish_inventory/commands/templates'
require_relative 'redfish_inventory/dry_cli/templates/list'
require_relative 'redfish_inventory/dry_cli/templates/show'
require_relative 'redfish_inventory/dry_cli/templates/create'
require_relative 'redfish_inventory/dry_cli/templates/delete'
require_relative 'redfish_inventory/dry_cli/templates/update_name'
require_relative 'redfish_inventory/dry_cli/templates/add_path'
require_relative 'redfish_inventory/dry_cli/templates/update_path'

require_relative 'redfish_inventory/commands/permissions'
require_relative 'redfish_inventory/dry_cli/permissions/list'

require_relative 'redfish_inventory/commands/roles'
require_relative 'redfish_inventory/dry_cli/roles/list'
require_relative 'redfish_inventory/dry_cli/roles/show'
require_relative 'redfish_inventory/dry_cli/roles/create'
require_relative 'redfish_inventory/dry_cli/roles/delete'
require_relative 'redfish_inventory/dry_cli/roles/add_permission'
require_relative 'redfish_inventory/dry_cli/roles/remove_permission'

require_relative 'redfish_inventory/commands/users'
require_relative 'redfish_inventory/dry_cli/users/create'


require_relative 'redfish_inventory/dry_cli/registry'

module RedfishInventory
  def self.start(arguments)
    Dry::CLI.new(DryCLI::Registry).call(arguments: arguments)
  rescue ApiError => error
    case error.status
    when 401
      Auth::TokenStore.delete
      warn 'Your session has expired. Please log in again'
    when 403
      warn 'You do not have permission to perform this action'
    else
      warn "API error: #{error.message}"

      Array(error.details).each do |detail|
        path = Array(detail['path']).join('.')
        warn "  #{path}: #{detail['message']}"
      end
    end
  rescue Errno::ECONNREFUSED
    warn "Could not connect to the API at #{Config::API_URL}"
  rescue SocketError
    warn "Could not resolve the API address: #{Config::API_URL}"
  rescue Net::OpenTimeout, Net::ReadTimeout
    warn 'The API request timed out'
  rescue URI::InvalidURIError
    warn "The API URL is invalid: #{Config::API_URL}"
  rescue OpenSSL::SSL::SSLError
    warn 'Could not establish a secure connection to the API'
  rescue JSON::ParserError => error
    warn "The API returned invalid JSON: #{error.message}"
  end
end