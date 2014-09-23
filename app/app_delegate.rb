class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    server
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    if Auth.needlogin?
      open_welcome_controller
    elsif Auth.needconfirm?
      Auth.reset
      open_confirm_controller
      # open_confirm_controller
    else
      open_main_controller
    end
    # main_controller = CountryPickerController.new
    # @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_controller)

    @window.makeKeyAndVisible
    true
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
    @tabBar.viewControllers = [
      UINavigationController.alloc.initWithRootViewController(MainController.new),
      @takeSelfieTab,
      UINavigationController.alloc.initWithRootViewController(MainController.new),
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
    # main_controller = MainController.new
    # @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_controller)
  end
  def tabBarController(tabBarController, shouldSelectViewController: viewController)
    tabBarController.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
    tabBarController.tabBar.subviews.first.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 80)
    if viewController == @takeSelfieTab
      @takeSelfie = TakeSelfieController.new
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
    Auth.reset
    open_welcome_controller
  end

end
