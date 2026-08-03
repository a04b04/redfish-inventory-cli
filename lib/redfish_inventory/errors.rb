# frozen_string_literal: true

module RedfishInventory
  class ApiError < StandardError
    attr_reader :status, :error_code, :details

    def initialize(status:, message:, error_code: nil, details: nil)
      @status = status
      @error_code = error_code
      @details = details

      super(message)
    end
  end
end