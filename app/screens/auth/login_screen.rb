class LoginScreen < PM::Screen
  title 'Login'

  def on_load
    # Sets a top of 0 to be below the navigation control
    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = AuthStylesheet
    rmq(self.view).apply_style :root_view

    # Create your UIViews here
    @selfie_logo = rmq.append(UIImageView, :logo_white)
    @copyright_label = rmq.append(UILabel, :copyright_label).get

    @username = rmq.append(UITextField, :username).focus.get
    @password = rmq.append(UITextField, :password).get

    rmq.append(UIButton, :login_button).on(:tap) do |sender|
      on_login
    end
  end

  def on_login
    rmq.animations.start_spinner
    @user = app_delegate.user
    if @username.text == '' or @password.text == ''
      App.alert("Username and password can't be blank.")
      rmq.animations.stop_spinner
      return
    end

    params={}
    params[:username] = @username.text
    params[:password] = @password.text
    PM.logger.info params

    AFMotion::Client.shared.post("token", params) do |result|
      if result.success?
        @user.username = @username.text
        @user.token = result.object["token"]
        @user.save
        app_delegate.showWelcomeScreen
        rmq.animations.stop_spinner
      elsif result.object && result.operation.response.statusCode.to_s =~ /40\d/
        rmq.animations.stop_spinner
        App.alert(result.object["errors"])
      else
        p result.object
        rmq.animations.stop_spinner
        App.alert(result.error.localizedDescription)
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
