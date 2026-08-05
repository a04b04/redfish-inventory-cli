module RedfishInventory
  module Auth
    class SessionManager
      def self.access_token
        session = TokenStore.load_session

        if session.nil?
          raise ApiError.new(
            status: 401,
            message: 'You are not logged in.'
          )
        end

        if TokenStore.refresh_expired?
          TokenStore.delete

          raise ApiError.new(
            status: 401,
            message: 'Your session has expired. Please log in again.'
          )
        end

        refresh_session if TokenStore.access_expired?

        TokenStore.access_token
      end

      def self.refresh_session
        uri = URI("#{Config::API_URL}/users/refresh")

        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request.body = JSON.generate(
          {
            'token' => TokenStore.refresh_token
          }
        )

        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end

        session = ApiClient.handle_response(response)
        TokenStore.save_session(session)
      end
    end
  end
end