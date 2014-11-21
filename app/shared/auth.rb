# Try to use this
# Auth.set({id: 1, email: "ichunlea@me.com", role: "user", token: "app-token"})
class Auth
  class << self
    ATTRIBUTES = %w(id username email phone token avatar confirmed_at).freeze

    def set(arguments={})
      reset
      arguments.each do |key, value|
        MotionKeychain.set(key.to_s, value.to_s)
      end
      Api.init_server
    end

    def reset
      ATTRIBUTES.each do |attribute|
        MotionKeychain.remove(attribute)
      end
      Api.init_server
    end

    def user
      Hash[ATTRIBUTES.collect { |v| [v, MotionKeychain.get(v.to_s)] }]
    end

    def needlogin?
      return true if MotionKeychain.get('email').nil? or MotionKeychain.get('token').nil?
      false
    end

    def needconfirm?
      return true if MotionKeychain.get('confirmed_at').nil? or MotionKeychain.get('confirmed_at')==""
      false
    end

    ATTRIBUTES.each do |method|
      define_method method do |*args, &block|
        MotionKeychain.get(method)
      end
    end
  end
end