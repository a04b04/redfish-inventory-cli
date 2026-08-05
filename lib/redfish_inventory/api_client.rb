require "net/http"
require "json"
require "uri"

module RedfishInventory
  class ApiClient
    
    def self.get(path)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Get.new(uri)
      add_auth_header(request)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
      handle_response(response)
    end

    def self.post(path, payload)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      add_auth_header(request)
      request.body = JSON.generate(payload)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      handle_response(response)
    end

    def self.patch(path, payload)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Patch.new(uri)
      request['Content-Type'] = 'application/json'
      add_auth_header(request)
      request.body = JSON.generate(payload)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      handle_response(response)
    end

    def self.delete(path)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")
      request = Net::HTTP::Delete.new(uri)
      add_auth_header(request)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      handle_response(response)
    end

    def self.handle_response(response)
      if response.is_a?(Net::HTTPSuccess)
        return if response.body.nil? || response.body.empty?

        return JSON.parse(response.body)
      end

      body =
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          {}
        end

      raise ApiError.new(
        status: response.code.to_i,
        error_code: body['error'],
        message: body['message'] || "#{response.code} #{response.message}",
        details: body['details']
      )
    end

    def self.login(username, password)
      uri = URI("#{Config::API_URL}/users/login")
      request = Net::HTTP::Post.new(uri)

      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(
        {
          'username' => username,
          'password' => password
        }
      )
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      handle_response(response)
    end


    def self.add_auth_header(request)
      token = Auth::SessionManager.access_token
      return if token.nil? || token.empty?
      request['Authorization'] = "Bearer #{token}" 
    end

    def self.refresh_session
      refresh_token = Auth::TokenStore.refresh_token

      uri = URI("#{Config::API_URL}/users/refresh")

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(
        {
          'token' => refresh_token
        }
      )
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      session = handle_response(response)
      Auth::TokenStore.save_session(session)
      session
    end

  end
end