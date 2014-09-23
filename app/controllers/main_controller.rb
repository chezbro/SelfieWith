class MainController < UIViewController

  def viewDidLoad
    super

    # Sets a top of 0 to be below the navigation control, it's best not to do this
    # self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = MainStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    # Create your UIViews here
    @hello_world_label = rmq.append(UILabel, :hello_world).get
    rmq.append(UIButton, :logout_btn).on(:tap) do |sender|
      UIApplication.sharedApplication.delegate.logout
    end
  end

  def viewWillAppear(animated)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    self.navigationController.setNavigationBarHidden(true, animated: true)
    self.tabBarController.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
    self.tabBarController.tabBar.subviews.first.frame = CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, 80)
    # self.navigationController.view.rmq(TopBar).show
    if AddressBook.authorized?
      puts "This app is authorized!"
    else
      puts "This app is not authorized!"
      @takeSelfie = AskContactsPermissionController.new
      @takeSelfie.transitioningDelegate = self
      @takeSelfie.modalPresentationStyle = UIModalPresentationCustom
      self.tabBarController.presentViewController(@takeSelfie, animated:true, completion:nil)
    end
  end


  def init_nav
    self.navigationItem.tap do |nav|
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                                                           target: self, action: :nav_left_button)
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                           target: self, action: :nav_right_button)
    end
  end

  def nav_left_button
    puts 'Left button'
  end

  def nav_right_button
    puts 'Right button'
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


