class WelcomeScreen < PM::Screen
  title 'Welcome'

  def on_load
    # Sets a top of 0 to be below the navigation control
    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = WelcomeStylesheet
    rmq(self.view).apply_style :root_view

    # Create your UIViews here
    @selfie_logo = rmq.append(UIImageView, :logo_white)
    @selfie_icon = rmq.append(UIImageView, :icon_white)
    @slogan_label = rmq.append(UILabel, :slogan_label).get
    @copyright_label = rmq.append(UILabel, :copyright_label).get

    rmq.append(UIButton, :login_button).on(:tap) do |sender|
      open HomeScreen
    end

    rmq.append(UIButton, :signup_button).on(:tap) do |sender|
      open HomeScreen
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
