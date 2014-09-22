class WelcomeController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = WelcomeControllerStylesheet
    rmq(self.view).apply_style :root_view

    # Create your views here
    rmq.append(UIView, :join_us_view).on(:tap) do
      open_join_us_controller
    end
    rmq.append(UIView, :log_in_view).on(:tap) do
      open_login_controller
    end
    rmq(:join_us_view).append(UIButton, :join_us_btn).on(:touch) { open_join_us_controller }
    rmq(:log_in_view).append(UIButton, :log_in_btn).on(:touch) { open_login_controller }

    self.navigationController.setNavigationBarHidden(true)
  end

  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(true, animated: true)
  end
  def open_join_us_controller
    self.navigationController.pushViewController(JoinUsernameController.new, animated:true)
  end

  def open_login_controller
    self.navigationController.pushViewController(LoginController.new, animated:true)
  end

  def needconfirm
    user = {id: Auth.id, username: Auth.username, phone: Auth.phone, full_name: Auth.full_name, gender: Auth.gender, email: Auth.email, token: Auth.token, avatar: Auth.avatar, confirmed_at: Auth.confirmed_at, }
    if Auth.phone == ""
      self.navigationController.pushViewController(JoinPhoneController.new(user: user), animated:true)
    elsif Auth.confirmed_at == ""
      self.navigationController.pushViewController(JoinSmsController.new(user: user), animated:true)
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
