class ChangePasswordController < UIViewController
  # include KVO

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = LoginControllerStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here
    @old_password       = rmq.append(UITextField, :old_password_text_field).focus.get
    @new_password       = rmq.append(UITextField, :new_password_text_field).get
    @new_password_again = rmq.append(UITextField, :new_password_again_text_field).get
    # Label for TextField
    # @old_password.leftView       = rmq.append(UILabel, :old_password_text_label)
    # @new_password.leftView       = rmq.append(UILabel, :new_password_text_label)
    # @new_password_again.leftView = rmq.append(UILabel, :new_password_again_text_label)

    @old_password.delegate       = self
    @new_password.delegate       = self
    @new_password_again.delegate = self

    @old_password.returnKeyType       = UIReturnKeyNext
    @new_password.returnKeyType       = UIReturnKeyNext
    @new_password_again.returnKeyType = UIReturnKeyGo

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
    if @old_password.isFirstResponder
      @new_password.becomeFirstResponder
    elsif @new_password.isFirstResponder
      @new_password_again.becomeFirstResponder
    else
      change_password
    end
    true
  end

  def enable_next_button
    if @old_password.text.length > 0 and @new_password.text.length > 0 and @new_password_again.text.length > 0
      self.navigationItem.rightBarButtonItem.enabled = true
    else
      self.navigationItem.rightBarButtonItem.enabled = false
    end
  end

  def init_nav
    self.title = 'Change Password'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Change",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :change_password)
    end
    self.navigationItem.rightBarButtonItem.enabled = false
    # self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    # self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def change_password
    if @old_password.text.length > 0 and @new_password.text.length > 0 and @new_password_again.text.length > 0
      if rmq.validation.valid?(@new_password.text, :strong_password)
        if @new_password.text == @new_password_again.text
          rmq.animations.start_spinner

          params={}
          params[:old_password] = @old_password.text
          params[:new_password] = @new_password.text

          API.post("auth/change", params) do |result|
            if result
              rmq.animations.stop_spinner
              self.navigationController.popToRootViewControllerAnimated(true)
            else
              rmq.animations.stop_spinner
            end
          end

        else
          SimpleSI.alert({
            title: "Enter your new passwrod twice",
            message: "Please enter your new password twice.",
            transition: "bounce",
            buttons: [
              {title: "Got it", type: "cancel"} # action is secondary
            ]
          })
        end
      else
        SimpleSI.alert({
          title: "Your new password is week",
          message: "You need a strong password, which at least 8 characters comprised of numbers, uppercase, and lowercase",
          transition: "bounce",
          buttons: [
            {title: "Got it", type: "cancel"} # action is secondary
          ]
        })
      end
    else
      # rmq(:hint_label).show
      # @hint.text = "You need to enter your username and password"
      SimpleSI.alert({
        message: "You need to enter your old and new password",
        transition: "bounce",
        buttons: [
          {title: "Got it", type: "cancel"} # action is secondary
        ]
      })
      rmq(:old_password_text_field).animations.sink_and_throb unless @old_password.text.length > 0
      rmq(:new_password_text_field).animations.sink_and_throb unless @new_password.text.length > 0
      rmq(:new_password_again_text_field).animations.sink_and_throb unless @new_password_again.text.length > 0
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
