class API
  class << self
    def post(route, params={}, &block)
      UIApplication.sharedApplication.networkActivityIndicatorVisible = true
      AFMotion::Client.shared.post(route, params) do |result|
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        if result.success?
          block.call(result.object) if block
        elsif result.object && result.operation.response.statusCode.to_s =~ /40\d/
          error = "There is something wrong."
          if result.object["message"].kind_of?(String)
            error = result.object["message"].to_s
          else
            error = result.object["message"].map { |e| e.join(" ") }.join(", ")
          end
          SimpleSI.alert({
            message: error.capitalize,
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