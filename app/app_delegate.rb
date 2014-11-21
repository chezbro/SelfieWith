class AppDelegate
  attr_reader :window
  attr_accessor :contacts, :selfies

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    Api.init_server
    # Cache
    url_cache = NSURLCache.alloc.initWithMemoryCapacity(4 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
    NSURLCache.setSharedURLCache(url_cache)

    AFNetworkActivityIndicatorManager.sharedManager.enabled = true

    # Init
    @contacts ||= []
    @selfies  ||= []

    if UIDevice.currentDevice.systemVersion.to_f >= 8.0
      settings = UIUserNotificationSettings.settingsForTypes((UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert), categories:nil)
      UIApplication.sharedApplication.registerUserNotificationSettings(settings)
    else
      UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
    end

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent

    return true if RUBYMOTION_ENV == "test"

    if Auth.needlogin?
      open_intro_controller
    else
      open_main_controller
    end

    @window.makeKeyAndVisible
    true
  end

  def application(application, didRegisterUserNotificationSettings: notificationSettings)
    application.registerForRemoteNotifications
  end

  def application(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
    if identifier.isEqualToString("declineAction")
      NSLog("declineAction")
    elsif identifier.isEqualToString("answerAction")
      NSLog("answerAction")
    else
      NSLog("application(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)")
    end
  end

  def application(application, didRegisterForRemoteNotificationsWithDeviceToken: device_token)
    if device_token
      clean_token = device_token.description.gsub(" ", "").gsub("<", "").gsub(">", "")
      App::Persistence["device_token"] = clean_token
      NSLog("Token: %@", App::Persistence["device_token"])
    end
  end

  def application(application, didReceiveRemoteNotification:push)
    SimpleSI.alert(push['aps']['alert'])
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    NSLog(error.inspect)
  end

  def open_intro_controller
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(IntroController.new)
  end

  def open_confirm_controller
    intro_controller = IntroController.new
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(intro_controller)
    intro_controller.needconfirm
  end
  def open_main_controller
    if Auth.needconfirm?
      Auth.reset
      open_confirm_controller
    else
      @takeSelfieTab = UIViewController.alloc.init
      @tabBar = UITabBarController.alloc.init
      UITabBar.appearance.setBarStyle UIBarStyleBlack
      UITabBar.appearance.setSelectionIndicatorImage rmq.image.resource('tabBarItem_selected')
      UITabBar.appearance.setSelectedImageTintColor rmq.color.white
      @main_screen = MainController.new
      @tabBar.viewControllers = [
        UINavigationController.alloc.initWithRootViewController(@main_screen),
        @takeSelfieTab,
        UINavigationController.alloc.initWithRootViewController(ContactsController.new),
      ]
      @tabBar.tabBar.items[0].image = rmq.image.resource('tabbar_home')
      @tabBar.tabBar.items[1].image = rmq.image.resource('tabbar_take')
      @tabBar.tabBar.items[2].image = rmq.image.resource('tabbar_contacts')
      @tabBar.tabBar.items[0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
      @tabBar.tabBar.items[1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
      @tabBar.tabBar.items[2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
      @tabBar.selectedIndex = 0
      @tabBar.delegate = self
      @tabBar.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
      @tabBar.tabBar.subviews.first.frame = CGRectMake(0, 0, @tabBar.tabBar.frame.size.width, 80)
      @tabBar
      @window.rootViewController = @tabBar
    end
  end
  def tabBarController(tabBarController, shouldSelectViewController: viewController)
    tabBarController.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
    tabBarController.tabBar.subviews.first.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 80)
    if viewController == @takeSelfieTab
      @takeSelfie = TakeSelfieController.new(main: @main_screen)
      @takeSelfie.transitioningDelegate = self
      @takeSelfie.modalPresentationStyle = UIModalPresentationCustom
      # @takeSelfie.delegate
      viewController.presentViewController(@takeSelfie, animated:true, completion:nil)
      # vc2 = TakeSelfieController.new
      # viewController.modalPresentationStyle = UIModalPresentationCurrentContext
      # viewController.presentViewController(TakeSelfieController.new, animated:true, completion:-> {
      #   viewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed
      # })
    end
    return viewController != @takeSelfieTab
  end

  def logout
    # AFMotion::Client.shared.operationQueue.cancelAllOperations
    Auth.reset
    UIApplication.sharedApplication.setApplicationIconBadgeNumber(0)
    open_welcome_controller
  end

  # Remove this if you are only supporting portrait
  def application(application, willChangeStatusBarOrientation: new_orientation, duration: duration)
    # Manually set RMQ's orientation before the device is actually oriented
    # So that we can do stuff like style views before the rotation begins
    rmq.device.orientation = new_orientation
  end
end
