class JoinUsernameController < UIViewController

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet                   = JoinUsernameControllerStylesheet
    rmq(self.view).apply_style :root_view
    @main_view                       = rmq.append(UIScrollView, :main_view).get
    contentInsets                    = UIEdgeInsetsMake(-50, 0.0, 230, 0.0)
    @main_view.contentInset          = contentInsets
    @main_view.scrollIndicatorInsets = contentInsets

    init_nav

    # Create your views here

    rmq(:main_view).append(UIButton, :selfie_view_placehoder).on(:tap) do |sender|
      take_avatar
    end
    @selfie = rmq(:selfie_view_placehoder).append(UIImageView, :selfie_view).get
    # rmq(:selfie_view).hide

    @username               = rmq(:main_view).append(UITextField, :username_text_field).get
    @password               = rmq(:main_view).append(UITextField, :password_text_field).get
    @email                  = rmq(:main_view).append(UITextField, :email_text_field).get
    # Label for TextField
    @username.leftView      = rmq.append(UILabel, :username_text_label).get
    @password.leftView      = rmq.append(UILabel, :password_text_label).get
    @email.leftView         = rmq.append(UILabel, :email_text_label).get
    @username.delegate      = self
    @password.delegate      = self
    @email.delegate         = self
    @username.returnKeyType = UIReturnKeyNext
    @password.returnKeyType = UIReturnKeyNext
    @email.returnKeyType    = UIReturnKeyGo

    @hint = rmq(:main_view).append(UILabel, :hint_label).get
  end

  def take_avatar
    rmq.wrap(rmq.app.window).tap do |o|
      @overlay = o.append(UIView, :overlay)
      if @activeTextView
        @activeTextView.resignFirstResponder
      end
      o.find(:overlay).append(UIView, :toolbar)
      @take_btn          = o.find(:toolbar).append(UIButton, :take_btn).get
      @chose_btn         = o.find(:toolbar).append(UIButton, :chose_btn).get
      @toggle_camera_btn = o.find(:toolbar).append(UIButton, :toggle_camera_btn).get

      init_picker

      o.find(:take_btn).on(:touch) do |sender|
        @image_picker.takePicture
      end
      o.find(:chose_btn).on(:touch) do |sender|
        o.find(:overlay).hide
        @image_picker_chose = UIImagePickerController.alloc.init.tap do |picker|
          UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
          picker.modalPresentationStyle = UIModalPresentationCurrentContext
          picker.sourceType             = UIImagePickerControllerSourceTypePhotoLibrary
          picker.delegate               = self
        end
        presentViewController(@image_picker_chose, animated: true, completion: nil)
      end
      o.find(:toggle_camera_btn).on(:touch) do |sender|
        toggle_camera(sender)
      end

      if @image_picker
        @picker_view = o.find(:overlay).append(@image_picker.view, :picker_view).get
        @image_picker.viewWillAppear(false)
        @image_picker.viewDidAppear(false)
      end

      o.find(:overlay).animations.fade_in.on(:tap) do |sender|
        o.find(sender).hide.remove
        if @activeTextView
          @activeTextView.becomeFirstResponder
        end
        # self.navigationController.setNavigationBarHidden(true, animated: true)
      end
    end
  end
  def init_picker
    if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera))
      @image_picker = UIImagePickerController.alloc.init.tap do |picker|
        picker.delegate                 = self
        picker.sourceType               = UIImagePickerControllerSourceTypeCamera
        picker.mediaTypes               = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceTypeCamera)
        picker.allowsEditing            = false
        picker.showsCameraControls      = false
        picker.cameraDevice             = UIImagePickerControllerCameraDeviceFront
        picker.cameraViewTransform      = CGAffineTransformScale(picker.cameraViewTransform, 1, 1)
      end
    end
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo: info)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    image = info[UIImagePickerControllerOriginalImage]

    @selfie.image = image

    if @image_picker_chose
      @image_picker_chose.dismissViewControllerAnimated(true, completion: nil)
    end
    @overlay.remove
    if @activeTextView
      @activeTextView.becomeFirstResponder
    end
  end

  def imagePickerControllerDidCancel(picker)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    @image_picker_chose.dismissViewControllerAnimated(true, completion: nil)
    @overlay.show
  end

  def toggle_flash(sender)
    if flash_mode_off?
      @image_picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn
      # sender.setTitle('Flash On', forState: UIControlStateNormal)
    else
      @image_picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff
      # sender.setTitle('Flash Off', forState: UIControlStateNormal)
    end
  end

  def toggle_camera(sender)
    if using_rear_camera?
      @image_picker.cameraDevice = UIImagePickerControllerCameraDeviceFront
      # sender.setTitle('Front Camera', forState: UIControlStateNormal)
    else
      @image_picker.cameraDevice = UIImagePickerControllerCameraDeviceRear
      # sender.setTitle('Rear Camera', forState: UIControlStateNormal)
    end
  end

  def using_rear_camera?
    @image_picker.cameraDevice == UIImagePickerControllerCameraDeviceRear
  end

  def flash_mode_off?
    @image_picker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff
  end

  def viewDidAppear(animated)
    Auth.reset
  end
  def init_nav
    self.title = 'Sign Up'
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
      @password.becomeFirstResponder
    elsif @password.isFirstResponder
      @email.becomeFirstResponder
    else
      next_action
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

  def next_action
    if @username.text.length > 0 and @password.text.length > 0 and @email.text.length > 0
      if rmq.validation.valid?(@username.text, :length, min_length: 4)
        if rmq.validation.valid?(@password.text, :strong_password)
          if rmq.validation.valid?(@email.text, :email)
            rmq.animations.start_spinner

            params={}
            params[:username] = @username.text
            params[:password] = @password.text
            params[:email]    = @email.text

            data = UIImageJPEGRepresentation(@selfie.image, 0.6)

            UIApplication.sharedApplication.networkActivityIndicatorVisible = true
            AFMotion::Client.shared.multipart_post("auth/register", params) do |result, form_data|
              UIApplication.sharedApplication.networkActivityIndicatorVisible = false
              if form_data
                if data
                  form_data.appendPartWithFileData(data, name: "avatar", fileName:"avatar.jpg", mimeType: "image/jpeg")
                end
              elsif result.success?
                Auth.set(result.object[:user][:id], result.object[:user][:username], result.object[:user][:phone], result.object[:user][:full_name], result.object[:user][:gender], result.object[:user][:email], result.object[:user][:auth_token], result.object[:user][:avatar], result.object[:user][:confirmed_at])
                rmq.animations.stop_spinner
                self.navigationController.pushViewController(JoinPhoneController.new(user: result.object["user"]), animated:true)
              elsif result.object && result.operation.response.statusCode.to_s =~ /40\d/
                if result.object["message"].kind_of?(String)
                  error = result.object["message"].to_s
                else
                  error = result.object["message"].map { |e| e.join(" ") }.join(", ")
                end
                SimpleSI.alert({
                  message: error.capitalize!,
                  transition: "bounce",
                  buttons: [
                    {title: "Got it", type: "cancel"} # action is secondary
                  ]
                })
                rmq.animations.stop_spinner
              else
                SimpleSI.alert({
                  message: result.error.localizedDescription,
                  transition: "bounce",
                  buttons: [
                    {title: "Got it", type: "cancel"} # action is secondary
                  ]
                })
                rmq.animations.stop_spinner
              end
            end
            # API.post("auth/register", params) do |result|
            #   if result
            #     p result
            #     Auth.set(result[:user][:id], result[:user][:username], result[:user][:phone], result[:user][:full_name], result[:user][:gender], result[:user][:email], result[:user][:auth_token])
            #     rmq.animations.stop_spinner
            #     self.navigationController.pushViewController(JoinPhoneController.new(user: result["user"]), animated:true)
            #   else
            #     rmq.animations.stop_spinner
            #   end
            # end
          else
            update_hint_error("The Email is not a correct format")
            rmq(:email_text_field).animations.sink_and_throb
          end
        else
          update_hint_error("You need a strong password")
          rmq(:password_text_field).animations.sink_and_throb
        end
      else
        update_hint_error("Username need length than 4")
        rmq(:username_text_field).animations.sink_and_throb
      end
    else
      update_hint_error
      rmq(:username_text_field).animations.sink_and_throb unless @username.text.length > 0
      rmq(:password_text_field).animations.sink_and_throb unless @password.text.length > 0
      rmq(:email_text_field).animations.sink_and_throb unless @password.text.length > 0
    end
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
