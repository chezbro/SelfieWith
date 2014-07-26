class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)
    showWelcomeScreen
  end

  def user
    @user ||= User.new
  end

  def server
    @user = app_delegate.user
    PM.logger.info "@user username #{@user.username}, token: #{@user.token}, phone: #{@user.phone}"
    if @user.needlogin?
      AFMotion::Client.build_shared(BASE_URL) do
        header "Accept", "application/json"
        response_serializer :json
      end
    else
      AFMotion::Client.build_shared(BASE_URL) do
        header "Accept", "application/json"
        @user = UIApplication.sharedApplication.delegate.user
        header "X-Api-Username",  @user.username
        header "X-Api-Token",     @user.token
        response_serializer :json
      end
    end
  end

  def showWelcomeScreen
    server
    @user = app_delegate.user
    PM.logger.info @user
    if @user.needlogin?
      open WelcomeScreen.new(nav_bar: false)
    else
      open HomeScreen.new(nav_bar: false)
    end
  end

  def logout
    @user = app_delegate.user
    @user.reset
    app_delegate.server
    app_delegate.showWelcomeScreen
  end

end