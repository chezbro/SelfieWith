class Auth
  attr_accessor :id, :username, :phone, :full_name, :gender, :email, :token, :avatar, :confirmed_at
  def initialize(params = {})
    self.id           = MotionKeychain.get('id')
    self.username     = MotionKeychain.get('username')
    self.phone        = MotionKeychain.get('phone')
    self.full_name    = MotionKeychain.get('full_name')
    self.gender       = MotionKeychain.get('gender')
    self.email        = MotionKeychain.get('email')
    self.token        = MotionKeychain.get('token')
    self.avatar       = MotionKeychain.get('avatar')
    self.confirmed_at = MotionKeychain.get('confirmed_at')
    UIApplication.sharedApplication.delegate.server
  end

  def reset
    MotionKeychain.remove('id')
    MotionKeychain.remove('username')
    MotionKeychain.remove('phone')
    MotionKeychain.remove('full_name')
    MotionKeychain.remove('gender')
    MotionKeychain.remove('email')
    MotionKeychain.remove('token')
    MotionKeychain.remove('avatar')
    MotionKeychain.remove('confirmed_at')
    self.id           = MotionKeychain.get('id')
    self.username     = MotionKeychain.get('username')
    self.phone        = MotionKeychain.get('phone')
    self.full_name    = MotionKeychain.get('full_name')
    self.gender       = MotionKeychain.get('gender')
    self.email        = MotionKeychain.get('email')
    self.token        = MotionKeychain.get('token')
    self.avatar       = MotionKeychain.get('avatar')
    self.confirmed_at = MotionKeychain.get('confirmed_at')
    UIApplication.sharedApplication.delegate.server
  end

  class << self
    def set(id, username, phone, full_name, gender, email, token, avatar, confirmed_at)
      MotionKeychain.set('id', id.to_s)
      MotionKeychain.set('username', username.to_s)
      MotionKeychain.set('phone', phone.to_s)
      MotionKeychain.set('full_name', full_name.to_s)
      MotionKeychain.set('gender', gender.to_s)
      MotionKeychain.set('email', email.to_s)
      MotionKeychain.set('token', token.to_s)
      MotionKeychain.set('avatar', avatar.to_s)
      MotionKeychain.set('confirmed_at', confirmed_at.to_s)
      UIApplication.sharedApplication.delegate.server
    end

    def reset
      MotionKeychain.remove('id')
      MotionKeychain.remove('username')
      MotionKeychain.remove('phone')
      MotionKeychain.remove('full_name')
      MotionKeychain.remove('gender')
      MotionKeychain.remove('email')
      MotionKeychain.remove('token')
      MotionKeychain.remove('avatar')
      MotionKeychain.remove('confirmed_at')
      UIApplication.sharedApplication.delegate.server
    end

    def needlogin?
      return true if MotionKeychain.get('username').nil? and MotionKeychain.get('token').nil?
      false
    end
    def needconfirm?
      return true if MotionKeychain.get('confirmed_at').nil? or MotionKeychain.get('confirmed_at')==""
      false
    end

    def id
      MotionKeychain.get('id').to_i
    end

    def username
      MotionKeychain.get('username')
    end

    def phone
      MotionKeychain.get('phone')
    end

    def full_name
      MotionKeychain.get('full_name')
    end

    def gender
      MotionKeychain.get('gender')
    end

    def email
      MotionKeychain.get('email')
    end

    def token
      MotionKeychain.get('token')
    end

    def avatar
      MotionKeychain.get('avatar')
    end

    def confirmed_at
      MotionKeychain.get('confirmed_at')
    end
  end
end