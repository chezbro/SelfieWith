class NotificationsController < UITableViewController

  NOTIFICATIONS_CELL_ID = "NotificationsCell"

  def viewDidLoad
    super

    load_data

    rmq.stylesheet = NotificationsControllerStylesheet

    view.tap do |table|
      table.delegate = self
      table.dataSource = self
      rmq(table).apply_style :table
    end

    @no_data = rmq.append(UIImageView, :no_data)
  end

  def load_data
    @data ||= []
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    AFMotion::SessionClient.shared.get("notifications") do |result|
      if result
        @data = result.object
        tableView.reloadData
      end
    end
  end

  def tableView(table_view, numberOfRowsInSection: section)
    if @data.length > 0
      @no_data.hide
    else
      @no_data.show
    end
    @data.length
  end

  def tableView(table_view, heightForRowAtIndexPath: index_path)
    rmq.stylesheet.notifications_cell_height
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    data_row = @data[index_path.row]

    cell = table_view.dequeueReusableCellWithIdentifier(NOTIFICATIONS_CELL_ID) || begin
      rmq.create(NotificationsCell, :notifications_cell, reuse_identifier: NOTIFICATIONS_CELL_ID).get

      # If you want to change the style of the cell, you can do something like this:
      #rmq.create(NotificationsCell, :notifications_cell, reuse_identifier: NOTIFICATIONS_CELL_ID, cell_style: UITableViewCellStyleSubtitle).get
    end

    cell.delegate = self
    cell.update(data_row)
    cell
  end

  def deny_notification(sender)
    indexPath = tableView.indexPathForCell(sender.superview.superview.superview)
    tableView.beginUpdates

    AFMotion::SessionClient.shared.post("notifications/#{@data[indexPath.row][:id]}/deny") do |result|
      if result
        @data.delete_at(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationLeft)
        App::Persistence["notification"] -= 1
        UIApplication.sharedApplication.setApplicationIconBadgeNumber(App::Persistence["notification"].to_i)
      end
    end
    tableView.endUpdates
  end
  def accept_notification(sender)
    indexPath = tableView.indexPathForCell(sender.superview.superview.superview)
    tableView.beginUpdates

    AFMotion::SessionClient.shared.post("notifications/#{@data[indexPath.row][:id]}/accept") do |result|
      if result
        @data.delete_at(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationMiddle)
        App::Persistence["notification"] -= 1
        UIApplication.sharedApplication.setApplicationIconBadgeNumber(App::Persistence["notification"].to_i)
      end
    end
    tableView.endUpdates
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
