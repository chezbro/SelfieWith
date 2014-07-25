class AppDelegate < PM::Delegate
  def on_load(app, options)
    # open HomeScreen.new(nav_bar: true)
    open WelcomeScreen.new(nav_bar: false)
  end
end