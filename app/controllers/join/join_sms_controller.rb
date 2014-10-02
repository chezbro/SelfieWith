class JoinSMSController < UIViewController
  attr_accessor :user

  def self.new(args = {})
    s = self.alloc
    s.user = args[:user]
    s
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = JoinSMSControllerStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here
    @sms_code          = rmq.append(UITextField, :sms_code_field).focus.get
    @sms_code.delegate = self
    @resent_btn        = rmq.append(UIButton, :resent_btn).get
    @resent_btn_label  = rmq(:resent_btn).append(UILabel, :resent_btn_label).get
    rmq(:resent_btn).on(:tap) do |sender|
      p "Resent"
      resent_confirmation_code
      reset_resent_btn
    end
    # reset_resent_btn
    # resent_confirmation_code
  end
  def resent_confirmation_code
    params              = {}
    params[:username]   = @user[:username]
    params[:auth_token] = @user[:auth_token]

    API.post("auth/resend", params)

    SimpleSI.alert("Confirmation code had been to send to your phone number: #{@user[:phone]}")

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

  def enable_next_button
    if @sms_code.text.length > 0
      self.navigationItem.rightBarButtonItem.enabled = true
    else
      self.navigationItem.rightBarButtonItem.enabled = false
    end
  end

  def init_nav
    self.title = 'Join us'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Next",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :next_action)
    end
    self.navigationItem.rightBarButtonItem.enabled      = false
    self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def next_action
    if @sms_code.text.length > 0
      rmq.animations.start_spinner

      params = {}
      params[:username]   = @user[:username]
      params[:auth_token] = @user[:auth_token]
      params[:sms_code]   = @sms_code.text

      API.post("auth/confirm", params) do |result|
        if result
          p result
          rmq.animations.stop_spinner
          Auth.set(result[:user][:id], result[:user][:username], result[:user][:phone], result[:user][:full_name], result[:user][:gender], result[:user][:email], result[:user][:auth_token], result[:user][:avatar_url], result[:user][:confirmed_at])
          UIApplication.sharedApplication.delegate.open_main_controller
        else
          rmq.animations.stop_spinner
        end
      end
    else
      rmq(:sms_code_field).animations.sink_and_throb
    end
    #
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
