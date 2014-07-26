class User
  attr_accessor :username, :token, :phone

  def initialize
    @keychain = KeychainItemWrapper.alloc.initWithIdentifier 'SelfieWith', accessGroup: nil
    load
  end

  def save
    @keychain.setObject username, forKey: KSecAttrAccount
    @keychain.setObject token, forKey: KSecValueData
    App::Persistence['phone'] = self.phone
  end

  def load
    self.username = @keychain.objectForKey KSecAttrAccount
    self.token = @keychain.objectForKey KSecValueData
    self.phone = App::Persistence['phone']
  end

  def reset
    self.username = ''
    self.token = ''
    App::Persistence.delete('phone')
    @keychain.resetKeychainItem
  end

  def needlogin?
    if self.username == '' or self.token == ''
      true
    else
      false
    end
  end
end