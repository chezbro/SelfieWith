class ForgotPasswordUsernameController < UIViewController

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = ForgotPasswordUsernameControllerStylesheet
    rmq(self.view).apply_style :root_view
    init_nav

    # Create your views here

    @username               = rmq.append(UITextField, :username_text_field).focus.get
    # Label for TextField
    @username.leftView      = rmq.append(UILabel, :username_text_label).get
    @username.delegate      = self
    @username.returnKeyType = UIReturnKeyNext

    rmq.append(UIButton, :country_picker).on(:tap) do |sender|
      self.presentViewController(UINavigationController.alloc.initWithRootViewController(CountryPickerController.new(delegate: self)), animated:true, completion:nil)
    end
    rmq(:country_picker).append(UIImageView, :country_picker_global)
    rmq(:country_picker).append(UIImageView, :country_picker_next)
    @country_picker      = rmq(:country_picker).append(UILabel, :country_picker_label).get
    @country_picker.text = "United States"

    @phone_number               = rmq.append(UITextField, :phone_number_field).get
    @phone_number.delegate      = self
    @phone_number.leftView      = rmq.append(UILabel, :country_code_label).get
    @phone_number.leftView.text = "+1"

    @hint = rmq(:main_view).append(UILabel, :hint_label).get
  end

  def viewDidAppear(animated)
    Auth.reset
  end
  def init_nav
    self.title = 'Forgot Password'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Next",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :next_action)
    end
    self.navigationItem.rightBarButtonItem.enabled = false
    self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    enable_next_button

    if textField == @phone_number and @phone_number.leftView.text == "+1"
      newText = textField.text.stringByReplacingCharactersInRange(range, withString:string)
      deleting = newText.length < textField.text.length

      stripppedNumber = newText.stringByReplacingOccurrencesOfString("[^0-9]", withString:"", options: NSRegularExpressionSearch, range:NSMakeRange(0, newText.length))
      digits = stripppedNumber.length

      if digits > 10
        stripppedNumber = stripppedNumber.substringToIndex(10)
      end

      selectedRange = textField.selectedTextRange
      oldLength = textField.text.length

      if digits == 0
        textField.text = ""
      elsif digits < 3 || (digits == 3 && deleting)
        textField.text = NSString.stringWithFormat("(%@", stripppedNumber)
      elsif digits < 6 || (digits == 6 && deleting)
        textField.text = NSString.stringWithFormat("(%@) %@", stripppedNumber.substringToIndex(3), stripppedNumber.substringFromIndex(3))
      else
        textField.text = NSString.stringWithFormat("(%@) %@-%@", stripppedNumber.substringToIndex(3), stripppedNumber.substringWithRange(NSMakeRange(3, 3)), stripppedNumber.substringFromIndex(6))
      end

      newPosition = textField.positionFromPosition(selectedRange.start, offset:textField.text.length - oldLength)
      newRange = textField.textRangeFromPosition(newPosition, toPosition:newPosition)
      textField.setSelectedTextRange(newRange)

      return false
    end
    true
  end
  def textFieldDidBeginEditing(textField)
    enable_next_button
    @activeTextView = textField
    true
  end
  def textViewDidEndEditing(textField)
    @activeTextView = nil
  end
  def textFieldShouldEndEditing(textField)
    enable_next_button
    true
  end
  def textFieldShouldReturn(textField)
    if @username.isFirstResponder
      @phone_number.becomeFirstResponder
    else
      next_action
    end
    true
  end

  def enable_next_button
    if @username.text.length > 0 and @phone_number.text.length > 0
      self.navigationItem.rightBarButtonItem.enabled = true
    else
      self.navigationItem.rightBarButtonItem.enabled = false
    end
  end

  def next_action
    Motion::Blitz.show(:black)
    if @username.text.length > 0 and @phone_number.text.length > 0

      params={}
      params[:username] = @username.text
      params[:phone]    = @phone_number.leftView.text + ' ' + @phone_number.text

      AFMotion::SessionClient.shared.post("auth/reset", params) do |result|
        Motion::Blitz.dismiss
        if result.success?
          self.navigationController.pushViewController(ForgotPasswordResetController.new(user: result.object["user"]), animated:true)
        else
          SimpleSI.alert({
            message: "Send the password reset token to your phone failed, please check your username and phone number, or try again later.",
            buttons: [
              {title: "Got it", type: "cancel"} # action is secondary
            ]
          })
        end
      end
    else
      Motion::Blitz.dismiss
      SimpleSI.alert({
        message: "You need to enter your username and your phone number to get the password reset token",
        buttons: [
          {title: "Got it", type: "cancel"} # action is secondary
        ]
      })
    end
  end

  def didSelectCountry(country)
    @country_picker.text = country[:name]
    @phone_number.leftView.text = country[:dial_code]
    @phone_number.text = ""
    rmq(:phone_number_field).focus
  end

  def update_hint_error(text=nil)
    @hint.textColor = rmq.color.red
    if text
      @hint.text = text
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
