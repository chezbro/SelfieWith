class AppDelegate
  attr_reader :window
  attr_accessor :contacts, :selfies

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @contacts ||= []
    @selfies  ||= []
    if UIDevice.currentDevice.systemVersion.to_f >= 8.0
      settings = UIUserNotificationSettings.settingsForTypes((UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert), categories:nil)
      UIApplication.sharedApplication.registerUserNotificationSettings(settings)
    else
      UIApplication.sharedApplication.registerForRemoteNotificationTypes(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
    end

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    server
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    if Auth.needlogin?
      open_welcome_controller
    elsif Auth.needconfirm?
      Auth.reset
      open_confirm_controller
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

  def open_welcome_controller
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(WelcomeController.new)
  end
  def open_confirm_controller
    welcome_screen = WelcomeController.new
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(welcome_screen)
    welcome_screen.needconfirm
  end
  def open_main_controller
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

  def server
    # UIApplication.sharedApplication.delegate.server
    if Auth.needlogin?
      AFMotion::Client.build_shared(BASE_URL) do
        header "Accept", "application/json"
        response_serializer :json
      end
    else
      AFMotion::Client.build_shared(BASE_URL) do
        header "Accept", "application/json"
        header "X-Api-Username",  Auth.username
        header "X-Api-Token",  Auth.token
        response_serializer :json
      end
    end
  end
  def logout
    # AFMotion::Client.shared.operationQueue.cancelAllOperations
    Auth.reset
    UIApplication.sharedApplication.setApplicationIconBadgeNumber(0)
    open_welcome_controller
  end

  def get_contacts(&block)
    if AddressBook.authorized?
      UIApplication.sharedApplication.networkActivityIndicatorVisible = true

      # NSLog("AddressBook.authorized!")
      ab = AddressBook::AddrBook.new
      phones_list = []
      # emails_list = []
      ab.people.each do |person|
        phones_list += person.phones.map {|p| p[:value]}
        # emails_list += person.emails.map {|p| p[:value]}
      end

      params = {}
      params[:phones] = phones_list
      # params[:emails] = emails_list
      API.post('contacts', params) do |result|
        UIApplication.sharedApplication.networkActivityIndicatorVisible = false
        if result
          @contacts = []
          # ab.people{|p| p.composite_name}.each do |person|
          ab.people{|p| (p.composite_name || "#")}.each do |person|
            phones = person.phones.map {|p| p[:value]}
            # emails_list += person.emails.map {|p| p[:value]}
            phones.each do |phone|
              if result.keys.include? phone
                person.username = result[phone.to_s][:username]
                person.avatar   = result[phone.to_s][:avatar]
              end
            end
            @contacts << person
          end
          block.call(result) if block
        else
          block.call(nil) if block
        end
      end
    end
  end
  def get_selfies(&block)
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    params = {}
    API.get('selfies', params) do |result|
      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      if result
        p result
        @selfies = result[:selfies]
        block.call(result) if block
      else
        block.call(nil) if block
      end
    end
  end

end
