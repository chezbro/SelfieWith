class LoginController < UIViewController
  # include KVO

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = LoginStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here
    @username = rmq.append(UITextField, :username_text_field).focus.get
    @password = rmq.append(UITextField, :password_text_field).get
    # Label for TextField
    @username.leftView = rmq.append(UILabel, :username_text_label).get
    @password.leftView = rmq.append(UILabel, :password_text_label).get
    @username.delegate = self
    @password.delegate = self
    @username.returnKeyType = UIReturnKeyNext
    @password.returnKeyType = UIReturnKeyGo

    rmq.append(UIButton, :forget_password).on(:tap) do |sender|
      self.navigationController.pushViewController(ForgotPasswordUsernameController.new, animated:true)
    end
  end
  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    enable_next_button
    true
  end
  def textFieldDidBeginEditing(textField)
    enable_next_button
    true
  end
  def textFieldShouldEndEditing(textField)
    enable_next_button
    true
  end
  def textFieldShouldReturn(textField)
    if @username.isFirstResponder
      @password.becomeFirstResponder
    else
      login
    end
    true
  end

  def enable_next_button
    if @username.text.length > 0 and @password.text.length > 0
      self.navigationItem.rightBarButtonItem.enabled = true
    else
      self.navigationItem.rightBarButtonItem.enabled = false
    end
  end

  def init_nav
    self.title = 'Sign In'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Login",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :login)
    end
    self.navigationItem.rightBarButtonItem.enabled = false
    self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def login
    Motion::Blitz.show(:black)
    if @username.text.length > 0 and @password.text.length > 0
      params={}
      params[:username] = @username.text
      params[:password] = @password.text
      params[:device_token] = App::Persistence["device_token"]

      AFMotion::SessionClient.shared.post("auth/login", params) do |result|
        Motion::Blitz.dismiss
        if result.success?
          if result.object[:user]
            user = result.object[:user]
            Auth.set({id: user[:id], username: user[:username], email: user[:email], phone: user[:phone], token: user[:token], avatar: user[:avatar_url], confirmed_at: user[:confirmed_at]})
            UIApplication.sharedApplication.delegate.open_main_controller
          else
            SimpleSI.alert({
              message: "We didn't get your user information, please try again later.",
              buttons: [
                {title: "Got it", type: "cancel"} # action is secondary
              ]
            })
          end
        else
          Motion::Blitz.dismiss
          SimpleSI.alert({
            message: "Login failed, please check your email and password.",
            buttons: [
              {title: "Got it", type: "cancel"} # action is secondary
            ]
          })
        end
      end
    else
      Motion::Blitz.dismiss
      SimpleSI.alert({
        message: "You need to enter your username and password",
        buttons: [
          {title: "Got it", type: "cancel"} # action is secondary
        ]
      })
      rmq(:username_text_field).animations.sink_and_throb unless @username.text.length > 0
      rmq(:password_text_field).animations.sink_and_throb unless @password.text.length > 0
    end
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end
end


__END__

# You don't have to reapply styles to all UIViews, if you want to optimize,
# another way to do it is tag the views you need to restyle in your stylesheet,
# then only reapply the tagged views, like so:
def logo(st)
  st.frame = {t: 10, w: 200, h: 96}
  st.centered = :horizontal
  st.image = image.resource('logo')
  st.tag(:reapply_style)
end

# Then in willAnimateRotationToInterfaceOrientation
rmq(:reapply_style).reapply_styles
