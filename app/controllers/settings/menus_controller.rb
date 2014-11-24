class MenusController < UITableViewController
  attr_accessor :delegate

  MENUS_CELL_ID = "MenusCell"

  def self.new(args = {})
    s = self.alloc
    s.delegate = args[:delegate]
    s
  end

  def viewDidLoad
    super

    load_data

    rmq.stylesheet = MenusControllerStylesheet

    view.tap do |table|
      table.delegate = self
      table.dataSource = self
      rmq(table).apply_style :table
    end
  end

  def load_data
    # @data = 0.upto(rand(100)).map do |i| # Test data
    #   {
    #     name: %w(Lorem ipsum dolor sit amet consectetur adipisicing elit sed).sample,
    #     num: rand(100),
    #   }
    # end
    @data = [
      {
        title: "Account",
        items: [
          {
            title: "Change Selfie",
            action: "change_selfie"
          },
          {
            title: "Change Password",
            action: "change_password"
          },
          {
            title: "Log Out",
            action: "logout"
          },
        ]
      },
      {
        title: "App Infomation",
        items: [
          {
            title: "Report a Problem",
            action: "report_bug"
          },
        ]
      }
    ]
  end

  def numberOfSectionsInTableView(table_view)
    @data.count
  end

  # def tableView(table_view, viewForHeaderInSection: section)
  #   @data[section][:title]
  # end

  def tableView(table_view, viewForHeaderInSection: section)
    if @data[section][:title]
      header = rmq.append(UIToolbar, :menu_section_header)
      header_label = header.append(UILabel, :menu_section_header_label).get
      header_label.text =  @data[section][:title].to_s.upcase
      header.get
    else
      nil
    end
  end

  def tableView(tableView, heightForHeaderInSection:section)
    40
  end

  def tableView(table_view, numberOfRowsInSection: section)
    @data[section][:items].length
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.menus_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    data_row = @data[index_path.section][:items][index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(MENUS_CELL_ID) || begin
      rmq.create(MenusCell, :menus_cell, reuse_identifier: MENUS_CELL_ID).get

      # If you want to change the style of the cell, you can do something like this:
      #rmq.create(MenusCell, :menus_cell, reuse_identifier: MENUS_CELL_ID, cell_style: UITableViewCellStyleSubtitle).get
    end

    cell.update({name: data_row[:title]})
    cell
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    data_row = @data[index_path.section][:items][index_path.row]
    trigger_action(data_row[:action], data_row[:arguments], index_path) if data_row[:action]
    # @delegate.navigationController.view.rmq(TopBar).animations.fade_out
    # @delegate.navigationController.pushViewController(ContactsController.new, animated:true)
  end

  def trigger_action(action, arguments, index_path)
    return p "Action not implemented: #{action.to_s}" unless self.respond_to?(action)

    case self.method(action).arity
    when 0 then self.send(action) # Just call the method
    when 2 then self.send(action, arguments, index_path) # Send arguments and index path
    else self.send(action, arguments) # Send arguments
    end
  end

  def action
    SimpleSI.alert("TODO: This menu's function will be done later, but you can try Log Out")
  end

  def change_selfie
    @delegate.navigationController.view.rmq(TopBar).animations.fade_out
    @delegate.navigationController.setNavigationBarHidden(false, animated: true)
    a = ChangeSelfieController.new
    a.hidesBottomBarWhenPushed = true
    @delegate.navigationController.pushViewController(a, animated:true)
  end
  def change_password
    @delegate.navigationController.view.rmq(TopBar).animations.fade_out
    @delegate.navigationController.setNavigationBarHidden(false, animated: true)
    a = ChangePasswordController.new
    a.hidesBottomBarWhenPushed = true
    @delegate.navigationController.pushViewController(a, animated:true)
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end

  def report_bug
    BW::Mail.compose(
      delegate: @delegate, # optional, defaults to rootViewController
      to: [ "support@selfiewith.co" ],
      # cc: [ "itchy@example.com", "scratchy@example.com" ],
      # bcc: [ "jerry@example.com" ],
      html: true,
      subject: "Report a Problem",
      message: "Please descript your problem.",
      animated: false
    ) do |result, error|
      if result.sent?      # => boolean
        SimpleSI.alert({
          title: "Thank you",
          message: "Thank you for your mail",
          transition: "drop_down",
          buttons: [
            {title: "OK", type: "cancel"} # action is secondary
          ]
        })
      elsif result.canceled?  # => boolean
      elsif result.saved?     # => boolean
      elsif result.failed?    # => boolean
        NSLog("%@", error)             # => NSError
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
