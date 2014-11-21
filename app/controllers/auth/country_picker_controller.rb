class CountryPickerController < UITableViewController
  attr_accessor :delegate

  COUNTRY_PICKER_CELL_ID = "CountryPickerCell"

  def self.new(args = {})
    s = self.alloc
    s.delegate = args[:delegate]
    s
  end

  def viewDidLoad
    super
    rmq.stylesheet = CountryPickerControllerStylesheet

    init_nav

    view.tap do |table|
      table.delegate = self
      table.dataSource = self
      # table.header_view =  @searchBar
      rmq(table).apply_style :table
    end

    load_data
  end

  def load_data
    data = NSData.dataWithContentsOfFile(NSBundle.mainBundle.pathForResource("countries", ofType:"json"))
    localError = nil
    parsedObject = NSJSONSerialization.JSONObjectWithData(data, options:0, error: localError)
    if localError
      p localError.userInfo
    end

    @data = parsedObject.group_by {|c| c[:name][0] }
    @sections = @data.keys
  end

  def tableView(table_view, titleForHeaderInSection: section)
    @sections[section]
  end

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
    rmq.stylesheet.country_picker_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    data_row = @data[@sections[index_path.section]][index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(COUNTRY_PICKER_CELL_ID) || begin
      rmq.create(CountryPickerCell, :country_picker_cell, reuse_identifier: COUNTRY_PICKER_CELL_ID).get

      # If you want to change the style of the cell, you can do something like this:
      #rmq.create(CountryPickerCell, :country_picker_cell, reuse_identifier: COUNTRY_PICKER_CELL_ID, cell_style: UITableViewCellStyleSubtitle).get
    end

    cell.update(data_row)
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    self.dismissViewControllerAnimated(true, completion:nil)
    @delegate.didSelectCountry(@data[@sections[index_path.section]][index_path.row])
  end

  def init_nav
    UINavigationBar.appearance.setBarStyle UIBarStyleBlack
    UINavigationBar.appearance.setTitleTextAttributes({
      # UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      UITextAttributeTextShadowColor => rmq.color.clear,
      UITextAttributeTextColor => rmq.color.nav_text
    })

    self.title = 'Country'
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
