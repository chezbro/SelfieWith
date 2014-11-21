class Api
  class << self
    # Init API server, with the shared client
    def init_server
      if Auth.needlogin?
        AFMotion::SessionClient.build_shared(BASE_URL) do
          session_configuration :default

          header "Accept", "application/json"

          response_serializer :json
        end
      else
        AFMotion::SessionClient.build_shared(BASE_URL) do
          session_configuration :default

          header "Accept", "application/json"
          header "X-Api-Username",  Auth.username
          header "X-Api-Token",  Auth.token

          response_serializer :json
        end
      end
    end
  end
end