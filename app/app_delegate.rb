class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    server
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    main_controller = MainController.new
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_controller)

    @window.makeKeyAndVisible
    true
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
