class ContactPickController < UITableViewController
  attr_accessor :delegate

  CONTACT_PICK_CELL_ID = "ContactPickCell"

  def self.new(args = {})
    s = self.alloc
    s.delegate = args[:delegate]
    s
  end

  def viewDidLoad
    super
    init_nav

    rmq.stylesheet = ContactPickControllerStylesheet

    view.tap do |table|
      table.delegate = self
      table.dataSource = self
      rmq(table).apply_style :table
    end

    @ab = AddressBook::AddrBook.new
    @ab.observe!
    App.notification_center.observe :addressbook_updated do |notification|
      load_data
    end
    load_data

  end

  def load_data
    @contacts = []
    @ab.people{|p| p.composite_name}.map do |contact|
      unless contact.organization?
        @contacts << contact
      end
    end

    @data = @contacts.group_by {|c| c.composite_name[0] }
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
    rmq.stylesheet.contact_pick_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    data_row = @data[@sections[index_path.section]][index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(CONTACT_PICK_CELL_ID) || begin
      rmq.create(ContactPickCell, :contact_pick_cell, reuse_identifier: CONTACT_PICK_CELL_ID).get

      # If you want to change the style of the cell, you can do something like this:
      #rmq.create(ContactPickCell, :contact_pick_cell, reuse_identifier: CONTACT_PICK_CELL_ID, cell_style: UITableViewCellStyleSubtitle).get
    end

    cell.update({name: data_row.composite_name})
    cell
  end
  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    @delegate.update_person(@data[@sections[index_path.section]][index_path.row])
    self.dismissViewControllerAnimated(true, completion:nil)
  end

  def init_nav
    UINavigationBar.appearance.setBarStyle UIBarStyleBlack
    UINavigationBar.appearance.setTitleTextAttributes({
      # UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      UITextAttributeTextShadowColor => rmq.color.clear,
      UITextAttributeTextColor => rmq.color.nav_text
    })

    self.title = 'Pick Contact'
    self.navigationController.setNavigationBarHidden(false, animated: true)

    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Cancel",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :close_action)
    end
    # self.navigationController.navigationBar.setBackgroundImage(UIImage.alloc.init, forBarPosition:UIBarPositionAny,barMetrics:UIBarMetricsDefault)
    self.navigationController.navigationBar.setShadowImage UIImage.alloc.init
  end
  def close_action
    self.dismissViewControllerAnimated(true, completion:nil)
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
