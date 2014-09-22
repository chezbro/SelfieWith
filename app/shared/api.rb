class API
  class << self
    def post(route, params={}, &block)
      UIApplication.sharedApplication.networkActivityIndicatorVisible = true
      AFMotion::Client.shared.post(route, params) do |result|
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        if result.success?
          block.call(result.object) if block
        elsif result.object && result.operation.response.statusCode.to_s =~ /40\d/
          SimpleSI.alert({
            message: result.object["message"].to_s,
            transition: "bounce",
            buttons: [
              {title: "Got it", type: "cancel"} # action is secondary
            ]
          })
          block.call(nil) if block
        else
          SimpleSI.alert({
            message: result.error.localizedDescription,
            transition: "bounce",
            buttons: [
              {title: "Got it", type: "cancel"} # action is secondary
            ]
          })
          block.call(nil) if block
        end
      end
    end
  end
end