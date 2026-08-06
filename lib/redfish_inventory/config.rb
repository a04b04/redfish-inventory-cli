# frozen_string_literal: true

module RedfishInventory
  module Config
    API_URL =
      ConfigStore.api_url ||
      ENV['REDFISH_INVENTORY_API_URL'] ||
      'http://localhost:3000/api/v1'
  end
end



 #API_URL = 'http://10.151.0.44:3000/api/v1'