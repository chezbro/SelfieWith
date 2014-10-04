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
  end

  def load_data
    @data = 0.upto(rand(100)).map do |i| # Test data
      {
        name: %w(Lorem ipsum dolor sit amet consectetur adipisicing elit sed).sample,
        num: rand(100),
      }
    end
  end

  def tableView(table_view, numberOfRowsInSection: section)
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
    @data.delete_at(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationLeft)
    tableView.endUpdates
  end
  def accpet_notification(sender)
    indexPath = tableView.indexPathForCell(sender.superview.superview.superview)
    tableView.beginUpdates
    @data.delete_at(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationMiddle)
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
