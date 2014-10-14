class ChangeSelfieController < UIViewController
  # include KVO

  def viewDidLoad
    super
    self.edgesForExtendedLayout = UIRectEdgeAll

    rmq.stylesheet                   = ChangeSelfieControllerStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    # Create your views here

    rmq.append(UIButton, :selfie_view_placehoder).on(:tap) do |sender|
      take_avatar
    end
    @selfie = rmq(:selfie_view_placehoder).append(UIImageView, :selfie_view).get
    # rmq(:selfie_view).hide
    JMImageCache.sharedCache.imageForURL(Auth.avatar.to_url, completionBlock: lambda do |downloadedImage|
        @selfie.image = downloadedImage
        #@avatar.url = Auth.avatar
    end)
    @hint = rmq.append(UILabel, :hint_label).get
  end

  def take_avatar
    rmq.wrap(rmq.app.window).tap do |o|
      @overlay = o.append(UIView, :overlay)

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
    self.navigationItem.rightBarButtonItem.enabled = true

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

  def init_nav
    self.title = 'Change Your Selfie'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Change",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :change_selfie)
    end
    self.navigationItem.rightBarButtonItem.enabled = false
    # self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    # self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end

  def scaleImage(image)
    if image.size.width < 512.0
      newimg = image
    else
      scaleBy = 512.0/image.size.width
      size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy)

      UIGraphicsBeginImageContext(size)
      context = UIGraphicsGetCurrentContext()
      transform = CGAffineTransformIdentity

      transform = CGAffineTransformScale(transform, scaleBy, scaleBy)
      CGContextConcatCTM(context, transform)

      image.drawAtPoint(CGPointMake(0, 0))
      newimg = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    end
    UIImageJPEGRepresentation(newimg, 0.7)
  end

  def change_selfie
    rmq.animations.start_spinner

    data = scaleImage(@selfie.image)

    params = {}
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
    AFMotion::Client.shared.multipart_post("auth/changeselfie", params) do |result, form_data|
      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      if form_data
        if data
          form_data.appendPartWithFileData(data, name: "avatar", fileName:"avatar.jpg", mimeType: "image/jpeg")
        end
      elsif result.success?
        p result.object
        JMImageCache.sharedCache.removeImageForURL(Auth.avatar.to_url)
        # Auth.set(result.object[:user][:id], result.object[:user][:username], result.object[:user][:phone], result.object[:user][:full_name], result.object[:user][:gender], result.object[:user][:email], result.object[:user][:auth_token], result.object[:user][:avatar_url], result.object[:user][:confirmed_at])
        rmq.animations.stop_spinner
        self.navigationController.popToRootViewControllerAnimated(true)
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

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end
end
