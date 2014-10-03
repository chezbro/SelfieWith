class ProfileController < UICollectionViewController
  attr_accessor :person
  SELFIE_CELL_ID = "SelfieCell"

  def self.new(args = {})
    # Set layout
    # layout = UICollectionViewFlowLayout.alloc.init
    layout = SelfieLayout.alloc.init
    s = self.alloc.initWithCollectionViewLayout(layout)
    s.person = args[:person]
    s
  end

  def viewDidLoad
    super
    @selfies ||= []
    UIApplication.sharedApplication.delegate.get_contacts
    load_data

    if AddressBook.authorized?
      ab = AddressBook::AddrBook.new
      ab.observe!

      App.notification_center.observe :addressbook_updated do |notification|
        UIApplication.sharedApplication.delegate.get_contacts
      end
    end

    # Sets a top of 0 to be below the navigation control, it's best not to do this
    # self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = ProfileStylesheet
    init_nav
    rmq(self.view).apply_style :root_view

    @top_bar = rmq(self.navigationController.view).append(ProfileTopBar).get.tap do |top_bar|
      top_bar.delegate = self
    end

    @top_bar.update(person: @person)

    # Create your UIViews here
    # @hello_world_label = rmq.append(UILabel, :hello_world).get
    # rmq.append(UIButton, :logout_btn).on(:tap) do |sender|
    #   UIApplication.sharedApplication.delegate.logout
    # end

    collectionView.tap do |cv|
      cv.registerClass(SelfieCell, forCellWithReuseIdentifier: SELFIE_CELL_ID)
      cv.delegate                      = self
      cv.dataSource                    = self
      cv.collectionViewLayout.delegate = self
      rmq(cv).apply_style :collection_view
    end

    # Refresh
    @refresh_control = UIRefreshControl.alloc.init
    @refresh_control.tintColor = rmq.color.white
    @refresh_control.backgroundColor = rmq.color.clear
    @refresh_control.attributedTitle = NSAttributedString.alloc.initWithString("Pull to refresh", attributes: {NSForegroundColorAttributeName:UIColor.redColor})
    @refresh_control.addTarget(self, action:'refreshView:', forControlEvents:UIControlEventValueChanged)
    self.collectionView.addSubview(@refresh_control)
  end
  def refreshView(refresh)
    refresh.attributedTitle = NSAttributedString.alloc.initWithString("Refreshing data...", attributes: {NSForegroundColorAttributeName:UIColor.redColor})
    UIApplication.sharedApplication.delegate.get_selfies do
      refresh.attributedTitle = NSAttributedString.alloc.initWithString(sprintf("Last updated at %s", Time.now.strftime("%l:%M %p")), attributes: {NSForegroundColorAttributeName:UIColor.redColor})
      load_data
      refresh.endRefreshing
    end

    # if @refreshable_callback && self.respond_to?(@refreshable_callback)
    #   self.send(@refreshable_callback)
    # else
    #   PM.logger.warn "You must implement the '#{@refreshable_callback}' method in your TableScreen."
    # end
  end


  def viewWillAppear(animated)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
    self.navigationController.setNavigationBarHidden(true, animated: true)
    self.navigationController.view.rmq(ProfileTopBar).show
    self.tabBarController.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
    self.tabBarController.tabBar.subviews.first.frame = CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, 80)
    # self.navigationController.view.rmq(TopBar).show
    if AddressBook.authorized?
    else
      @ask_permission = AskContactsPermissionController.new
      @ask_permission.transitioningDelegate = self
      @ask_permission.modalPresentationStyle = UIModalPresentationCustom
      self.tabBarController.presentViewController(@ask_permission, animated:false, completion:nil)
    end
  end

  def load_data
    UIApplication.sharedApplication.delegate.get_selfies do |result|
      @selfies       = result[:selfies]
      @total_selfies = result[:total_selfies]
      @total_likes   = result[:total_likes]
      @top_bar.update({total_selfies: @total_selfies, total_likes: @total_likes})
      collectionView.reloadData
    end
  end

  def numberOfSectionsInCollectionView(view)
    1
  end
  def collectionView(view, numberOfItemsInSection: section)
    @selfies.length
  end
  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(SELFIE_CELL_ID, forIndexPath: index_path).tap do |cell|
      rmq.build(cell) unless cell.reused
    #   # p indexPath.row

    #   # Update cell's data here
      cell.update(@selfies[index_path.row])
    end
  end
  def collectionView(view, didSelectItemAtIndexPath: index_path)
    cell = view.cellForItemAtIndexPath(index_path)
    self.navigationController.view.rmq(ProfileTopBar).animations.fade_out
    self.navigationController.setNavigationBarHidden(false, animated: true)
    a = SelfieViewController.new(selfie: @selfies[index_path.row])
    a.hidesBottomBarWhenPushed = true
    self.navigationController.pushViewController(a, animated:true)
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

  def take_selfie
    p "take!!"
    @takeSelfie = TakeSelfieController.new
    @takeSelfie.transitioningDelegate = self
    @takeSelfie.modalPresentationStyle = UIModalPresentationCustom
    p @takeSelfie
    self.presentViewController(@takeSelfie, animated:true, completion:nil)
  end

  def close
    self.navigationController.view.rmq(ProfileTopBar).hide.remove
    self.navigationController.popViewControllerAnimated(true)
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


