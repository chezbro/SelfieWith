class JoinPhoneController < UIViewController
  attr_accessor :user

  def self.new(args = {})
    s = self.alloc
    s.user = args[:user]
    s
  end

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet = JoinPhoneControllerStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here
    rmq.append(UIButton, :country_picker).on(:tap) do |sender|
      # self.presentViewController(UINavigationController.alloc.initWithRootViewController(CountryPickerController.new(delegate: self)), animated:true, completion:nil)
    end
    rmq(:country_picker).append(UIImageView, :country_picker_global)
    # rmq(:country_picker).append(UIImageView, :country_picker_next)
    @country_picker      = rmq(:country_picker).append(UILabel, :country_picker_label).get
    @country_picker.text = "United States"

    @phone_number               = rmq.append(UITextField, :phone_number_field).focus.get
    @phone_number.delegate      = self
    @phone_number.leftView      = rmq.append(UILabel, :country_code_label).get
    @phone_number.leftView.text = "+1"

    @hint = rmq.append(UILabel, :hint_label).get
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
    if @phone_number.text.length > 0
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
    self.navigationItem.rightBarButtonItem.enabled = false
    self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def next_action
    Motion::Blitz.show(:black)
    if @phone_number.text.length > 0
      phone_number = @phone_number.leftView.text + ' ' + @phone_number.text
      p phone_number

      params              = {}
      params[:username]   = @user[:username]
      params[:auth_token] = @user[:auth_token]
      params[:phone]      = phone_number

      AFMotion::SessionClient.shared.post("auth/validatephone", params) do |result|
        Motion::Blitz.dismiss
        if result.success?
          if result.object[:user]
            user = result.object[:user]
            self.navigationController.pushViewController(JoinSMSController.new(user: user), animated:true)
          end
        else
          SimpleSI.alert("Please check with your phone number, and try again.")
          Motion::Blitz.dismiss
        end
      end
    else
      @hint.text = "You need to enter your phone number"
      @hint.color = rmq.color.red
      rmq(:hint_label).animations.sink_and_throb
    end
  end

  def didSelectCountry(country)
    @country_picker.text = country[:name]
    @phone_number.leftView.text = country[:dial_code]
    @phone_number.text = ""
    rmq(:phone_number_field).focus
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
