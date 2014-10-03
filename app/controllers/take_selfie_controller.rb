class TakeSelfieController < UIViewController
  attr_accessor :main_screen

  def self.new(args = {})
    s = self.alloc
    s.main_screen = WeakRef.new(args[:main])
    s
  end

  def viewDidLoad
    super

    rmq.stylesheet = TakeSelfieControllerStylesheet
    rmq(self.view).apply_style :root_view

    self.view.insertSubview(UIToolbar.alloc.initWithFrame(self.view.bounds), atIndex: 0)

    UIApplication.sharedApplication.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
    # Create your views here
    rmq.append(UIButton, :close_btn).on(:tap) do
      UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
      # self.dismissModalViewControllerAnimated(true)
      self.dismissViewControllerAnimated(true, completion:nil)
    end

    rmq.append(UIView, :toolbar)
    @take_btn          = rmq(:toolbar).append(UIButton, :take_btn).get
    @chose_btn         = rmq(:toolbar).append(UIButton, :chose_btn).get
    @toggle_camera_btn = rmq(:toolbar).append(UIButton, :toggle_camera_btn).get
    rmq.append(UIView, :use_toolbar).hide
    @retake_btn        = rmq(:use_toolbar).append(UIButton, :retake_btn).get
    @use_btn           = rmq(:use_toolbar).append(UIButton, :use_btn).get

    rmq(:take_btn).on(:touch) do |sender|
      @image_picker.takePicture
    end
    rmq(:chose_btn).on(:touch) do |sender|
      chose_picture
    end
    rmq(:toggle_camera_btn).on(:touch) do |sender|
      toggle_camera(sender)
    end
    rmq(:retake_btn).on(:touch) do |sender|
      retake_photo
    end
    rmq(:use_btn).on(:touch) do |sender|
      rmq(:retake_btn, :use_btn).hide.remove
      rmq.append(UIToolbar, :chose_contact_overlay).animations.slide_in(from_direction: :bottom)
      rmq(:chose_contact_overlay).append(UILabel, :person_reminder)
      rmq(:chose_contact_overlay).append(UIButton, :person_picker).on(:tap) do |sender|
        address_book = AddressBook::AddrBook.new
        if AddressBook.request_authorization
          self.presentViewController(UINavigationController.alloc.initWithRootViewController(ContactPickController.new(delegate: self)), animated:true, completion:nil)
        else
          App.alert('To add a person please enable this app in System Settings > Privacy > Contacts'.t)
        end
      end
      @person_name_label = rmq(:person_picker).append(UILabel, :person_name).get
      @person_name_label.text = "Pick person form your contacts"
    end

    @image_view = rmq.append(UIImageView, :image_view).get
    init_picker

    if @image_picker
      @picker_view = rmq.append(@image_picker.view, :picker_view).get
      @image_picker.viewWillAppear(false)
      @image_picker.viewDidAppear(false)
    end

  end
  def viewWillAppear(animated)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    UIApplication.sharedApplication.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
  end
  def viewWillDisAppear(animated)
    UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
  end

  # def use_this_photo
  #   rmq.animations.start_spinner
  #   puts "Use this photo"
  #   rmq.animations.stop_spinner
  # end

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
        picker.view.backgroundColor     = UIColor.clearColor
        picker.view.frame               = CGRectMake(0, 0, rmq(:image_view).frame.w, rmq(:image_view).frame.h)
        picker.view.layer.cornerRadius  = 100
        picker.view.layer.masksToBounds = true
        # picker.cameraOverlayView      = overlay_for_image_picker(@image_picker)
      end
    end
  end

  def retake_photo
    rmq(:toolbar).animations.fade_in
    @image_view.image = nil
    rmq(:picker_view).show
    rmq(:use_toolbar).hide
  end

  def chose_picture
    rmq(:picker_view).hide
    @image_picker_chose = UIImagePickerController.alloc.init.tap do |picker|
      UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
      picker.modalPresentationStyle = UIModalPresentationCurrentContext
      picker.sourceType             = UIImagePickerControllerSourceTypePhotoLibrary
      picker.delegate               = self
    end
    presentViewController(@image_picker_chose, animated: true, completion: nil)
  end
  def imagePickerController(picker, didFinishPickingMediaWithInfo: info)
    image = info[UIImagePickerControllerOriginalImage]
    # UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil)
    rmq(:toolbar).animations.fade_out
    rmq(:use_toolbar).show

    @image_view.image = image

    rmq(:picker_view).hide
    if @image_picker_chose
      @image_picker_chose.dismissViewControllerAnimated(true, completion: nil)
    end
  end

  def imagePickerControllerDidCancel(picker)
    rmq(:picker_view).hide
    dismissViewControllerAnimated(true, completion: nil)
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

  def update_person(person)
    @person_name_label.text = person.composite_name
    rmq(:chose_contact_overlay).append(UIButton, :person_picker_done).animations.fade_in.on(:tap) do |sender|
      p person
      params={}
      params[:people] = []
      params[:people] << {name: person.composite_name, phones: person.phones.map {|p| p[:value]}, email: person.email}
      # params[:name]   = person.composite_name
      # params[:phones] = person.phones.map {|p| p[:value]}
      # params[:email]  = person.email

      data = UIImageJPEGRepresentation(@image_view.image, 1.0)

      UIApplication.sharedApplication.networkActivityIndicatorVisible = true
      AFMotion::Client.shared.multipart_post("upload", params) do |result, form_data|
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        if form_data
          if data
            form_data.appendPartWithFileData(data, name: "selfie", fileName:"selfie.jpg", mimeType: "image/jpeg")
          end
        elsif result.success?
          rmq.animations.stop_spinner
          UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
          self.dismissViewControllerAnimated(true, completion:nil)
          @main_screen.load_data
        elsif result.object && result.operation.response.statusCode.to_s =~ /401/
          UIApplication.sharedApplication.delegate.logout
          SimpleSI.alert("Your seesion are expired, please try relogin.")
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

    end
  end

  def using_rear_camera?
    @image_picker.cameraDevice == UIImagePickerControllerCameraDeviceRear
  end

  def flash_mode_off?
    @image_picker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff
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
