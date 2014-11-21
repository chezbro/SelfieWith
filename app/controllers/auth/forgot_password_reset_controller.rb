class ForgotPasswordResetController < UIViewController
  attr_accessor :user

  def self.new(args = {})
    s = self.alloc
    s.user = args[:user]
    s
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = ForgotPasswordResetControllerStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here
    @sms_code                   = rmq.append(UITextField, :sms_code_field).get
    @sms_code.delegate          = self
    @new_password               = rmq.append(UITextField, :new_password_field).focus.get
    @new_password.delegate      = self
    @new_password.returnKeyType = UIReturnKeyNext
    @resent_btn                 = rmq.append(UIButton, :resent_btn).get
    @resent_btn_label           = rmq(:resent_btn).append(UILabel, :resent_btn_label).get
    rmq(:resent_btn).on(:tap) do |sender|
      p "Resent"
      resent_confirmation_code
      reset_resent_btn
    end
    # reset_resent_btn
    # resent_confirmation_code
  end
  def resent_confirmation_code
    params={}
    params[:username] = @user[:username]
    params[:phone]    = @user[:phone]

    AFMotion::SessionClient.shared.post("auth/reset", params) do |result|
      Motion::Blitz.dismiss
      if result.success?
        SimpleSI.alert("Reset password code had been sent to your phone number: #{@user[:phone]}")
      else
        SimpleSI.alert({
          message: "Send the password reset token to your phone failed, please check your username and phone number, or try again later.",
          buttons: [
            {title: "Got it", type: "cancel"} # action is secondary
          ]
        })
      end
    end
  end

  def reset_resent_btn
    @resent_btn.enabled = false
    @seconds = 20
    @timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:'updateTimer', userInfo:nil, repeats:true)
  end
  def updateTimer
    @seconds -= 1
    if @seconds < 0
      @resent_btn.enabled = true
      @timer.invalidate
      @resent_btn_label.text = "Resend confirmation code"
    else
      @resent_btn_label.text = "Resend confirmation code (#{@seconds})"
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
    next_action
    true
  end

  def textFieldShouldReturn(textField)
    if @new_password.isFirstResponder
      @sms_code.becomeFirstResponder
    else
      next_action
    end
    true
  end

  def enable_next_button
    if @sms_code.text.length > 0 and @new_password.text.length > 0
      self.navigationItem.rightBarButtonItem.enabled = true
    else
      self.navigationItem.rightBarButtonItem.enabled = false
    end
  end

  def init_nav
    self.title = 'Reset your password'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Reset",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :next_action)
    end
    self.navigationItem.rightBarButtonItem.enabled      = false
    self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def next_action
    Motion::Blitz.show(:black)
    if @sms_code.text.length > 0
      if rmq.validation.valid?(@new_password.text, :length, min_length: 8)

        params={}
        params[:username] = @user[:username]
        params[:sms_code] = @sms_code.text
        params[:password] = @new_password.text

        AFMotion::SessionClient.shared.post("auth/resetpass", params) do |result|
          Motion::Blitz.dismiss
          if result.success?
            # SimpleSI.alert("Reset password code had been sent to your phone number: #{@user[:phone]}")
            UIApplication.sharedApplication.delegate.open_intro_controller
          else
            SimpleSI.alert({
              message: "Please checke your confirmation code, and try again.",
              buttons: [
                {title: "Got it", type: "cancel"} # action is secondary
              ]
            })
          end
        end
      else
        Motion::Blitz.dismiss
        SimpleSI.alert({
          title: "You new password is week",
          message: "Your password need to be at least 8 characters.",
          transition: "bounce",
          buttons: [
            {title: "Got it", type: "cancel"} # action is secondary
          ]
        })
      end
    else
      Motion::Blitz.dismiss
      SimpleSI.alert({
        message: "You need to enter your reset code from your SMS",
        transition: "bounce",
        buttons: [
          {title: "Got it", type: "cancel"} # action is secondary
        ]
      })
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
