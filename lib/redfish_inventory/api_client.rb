require "net/http"
require "json"
require "uri"

module RedfishInventory
  class ApiClient
    def self.get(path)
      uri = URI("#{Config::API_URL}#{path}")
      response = Net::HTTP.get_response(uri)

      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed: #{response.code} #{response.message}"
      end

      JSON.parse(response.body)
    end

    def self.post(path, payload)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(payload)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed: #{response.code} #{response.message} - #{response.body}"
      end

      JSON.parse(response.body)
    end

    def self.patch(path, payload)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Patch.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = JSON.generate(payload)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed: #{response.code} #{response.message} - #{response.body}"
      end

      JSON.parse(response.body)
    end

    def self.delete(path)
      uri = URI("#{RedfishInventory::Config::API_URL}#{path}")

      request = Net::HTTP::Delete.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "API request failed: #{response.code} #{response.message} - #{response.body}"
      end

      return if response.body.nil? || response.body.empty?

      JSON.parse(response.body)
    end
  end
end