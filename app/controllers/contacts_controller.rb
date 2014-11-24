class ContactsController < UITableViewController

  CONTACTS_CELL_ID = "ContactsCell"

  def viewDidLoad
    super

    rmq.stylesheet = ContactsControllerStylesheet
    rmq(self.view).apply_style :root_view

    @top_bar = rmq(self.navigationController.view).append(TopBar).get.tap do |top_bar|
      top_bar.delegate = self
    end

    view.tap do |table|
      table.delegate = self
      table.dataSource = self
      table.setSeparatorInset UIEdgeInsetsZero
      rmq(table).apply_style :table
    end
  end

  def viewWillAppear(animated)
    @top_bar.update({total_selfies: App::Persistence["total_selfies"], total_likes: App::Persistence["total_likes"], notification: App::Persistence["notification"]})
    @top_bar.update_avatar
    load_data
    tableView.reloadData

    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent
    UIApplication.sharedApplication.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
    self.navigationController.setNavigationBarHidden(true, animated: true)
    self.tabBarController.tabBar.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-80, UIScreen.mainScreen.bounds.size.width, 80)
    self.navigationController.view.rmq(TopBar).show
  end

  def load_data
    @contacts = UIApplication.sharedApplication.delegate.contacts
    if @contacts.empty?
      UIApplication.sharedApplication.delegate.get_contacts do |result|
        if result
          load_data
        end
        tableView.reloadData
      end
    end

    @data = @contacts.group_by {|c| (c.composite_name || "#").get_first }
    @sections = @data.keys
  end

  # def tableView(table_view, titleForHeaderInSection: section)
  #   @sections[section]
  # end

  def numberOfSectionsInTableView(table_view)
    @sections.count
  end

  def sectionIndexTitlesForTableView(table_view)
    @sections
  end

  def tableView(table_view, numberOfRowsInSection: section)
    @data[@sections[section]].length
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.contacts_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    data_row = @data[@sections[index_path.section]][index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(CONTACTS_CELL_ID) || begin
      rmq.create(ContactsCell, :contacts_cell, reuse_identifier: CONTACTS_CELL_ID).get

      # If you want to change the style of the cell, you can do something like this:
      #rmq.create(ContactsCell, :contacts_cell, reuse_identifier: CONTACTS_CELL_ID, cell_style: UITableViewCellStyleSubtitle).get
    end
    cell.update(data_row)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    person = @data[@sections[index_path.section]][index_path.row]
    if person.username
      self.navigationController.view.rmq(TopBar).animations.fade_out
      self.navigationController.setNavigationBarHidden(false, animated: true)
      a = ProfileController.new(person: person)
      a.hidesBottomBarWhenPushed = true
      self.navigationController.pushViewController(a, animated:true)
      # SimpleSI.alert({
      #   title: "TODO: Should open the profile screen",
      #   message: "This person is #{person.composite_name} #{person.username.nil?? "You should invite him/her to join SelfieWith":"and in our database, his/her username is #{person.username}"}",
      #   transition: "bounce",
      #   buttons: [
      #     {title: "Got it", type: "cancel"} # action is secondary
      #   ]
      # })
    else
      @invite_person = person
      SimpleSI.alert({
        title: "Invite #{person.composite_name}",
        message: "Invite your friends to use SefieWith.",
        transition: "drop_down",
        buttons: [
          {title: "Send Invite", type: "default", action: :send_invite},
          {title: "No Thanks", type: "cancel"} # action is secondary
        ],
        delegate: self
      })
    end

    # self.navigationController.view.rmq(TopBar).animations.fade_out
    # self.navigationController.setNavigationBarHidden(false, animated: true)
    # a = ProfileController.new
    # a.hidesBottomBarWhenPushed = true
    # self.navigationController.pushViewController(a, animated:true)
  end

  def send_invite
    params={}
    params[:phones] = @invite_person.phones.map {|p| p[:value]}

    AFMotion::SessionClient.shared.post("invite", params) do |result|
      if result.success?
        SimpleSI.alert("Your invite had been send to \n #{@invite_person.composite_name}")
      else
        SimpleSI.alert("We can't send invite to \n #{@invite_person.composite_name}, please try again later.")
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
