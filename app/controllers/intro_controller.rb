class IntroController < UIViewController

  def viewDidLoad
    super

    # Sets a top of 0 to be below the navigation control, it's best not to do this
    # self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = IntroStylesheet
    rmq(self.view).apply_style :root_view

    # Create your UIViews here
    init_intro

    rmq.append(UIButton, :join_us_btn).on(:touch) { open_join_us_controller }
    rmq.append(UIButton, :log_in_btn).on(:touch) { open_login_controller }
  end

  def viewWillAppear(animated)
    self.navigationController.setNavigationBarHidden(true, animated: false)
  end

  def open_join_us_controller
    self.navigationController.pushViewController(JoinUsernameController.new, animated:true)
  end

  def open_login_controller
    self.navigationController.pushViewController(LoginController.new, animated:true)
  end

  def init_intro
    page1                      = EAIntroPage.page
    # page1.titleIconView      = UIImageView.alloc.initWithImage(rmq.image.resource("icon-60"))
    # page1.titleIconPositionY = 120
    page1.bgImage              = rmq.image.resource("Default-568h")
    # page1.title              = "imHome"
    # page1.titleFont          = rmq.font.large
    # page1.titleColor         = rmq.color.red
    # page1.titlePositionY     = 380
    # page1.desc               = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
    # page1.descFont           = rmq.font.small
    # page1.descColor          = rmq.color.red
    # page1.descWidth          = 300
    # page1.descPositionY      = 300

    intro = EAIntroView.alloc.initWithFrame(self.view.bounds,
                        andPages: [page1])

    # intro.pageControlY         = 80
    # intro.titleView          = UIImageView.alloc.initWithImage(rmq.image.resource("icon-76"))
    # intro.titleViewY         = 100
    intro.swipeToExit          = false
    # intro.tapToNext          = true
    intro.hideOffscreenPages   = true
    intro.easeOutCrossDisolves = true
    intro.useMotionEffects     = true

    intro.setDelegate self
    intro.showInView(self.view, animateDuration:0.0)
  end

  def needconfirm
    if Auth.phone == ""
      self.navigationController.pushViewController(JoinPhoneController.new(user: Auth.user), animated:true)
    elsif Auth.confirmed_at == ""
      params              = {}
      params[:username]   = Auth.username
      params[:auth_token] = Auth.token
      params[:phone]      = Auth.phone

      AFMotion::SessionClient.shared.post("auth/validatephone", params) do |result|
        if result.success?
          if result.object[:user]
            user = result.object[:user]
            self.navigationController.pushViewController(JoinSMSController.new(user: user), animated:true)
          end
        else
          SimpleSI.alert("Please check with your phone number, and try again.")
          Motion::Blitz.dismiss
        end
      end
    end
  end

  # Remove these if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    # Called before rotation
    rmq.all.reapply_styles
  end
  def viewWillLayoutSubviews
    # Called anytime the frame changes, including rotation, and when the in-call status bar shows or hides
    #
    # If you need to reapply styles during rotation, do it here instead
    # of willAnimateRotationToInterfaceOrientation, however make sure your styles only apply the layout when
    # called multiple times
  end
  def didRotateFromInterfaceOrientation(from_interface_orientation)
    # Called after rotation
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


