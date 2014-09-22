class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
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
    # main_controller = MainController.new
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
    main_controller = MainController.new
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_controller)
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
