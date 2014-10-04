class NotificationsCell < UITableViewCell
  attr_accessor :delegate

  def rmq_build
    q = rmq(self.contentView)

    # Add your subviews, init stuff here
    # @foo = q.append(UILabel, :foo).get
    q.append(UIView, :cell_view)
    q.find(:cell_view).append(UIImageView, :background_image)
    @name = q.find(:cell_view).append(UILabel, :title_bg).get.tap do |o|
      gradient = CAGradientLayer.layer
      gradient.frame = o.bounds
      gradient.colors = [rmq.color.from_rgba(0, 0, 0, 0.9).CGColor, rmq.color.from_rgba(0, 0, 0, 0).CGColor]
      gradient.locations = [0, 0.8]
      o.layer.addSublayer(gradient)
    end
    # @name = q.find(:title_bg).append(UILabel, :cell_label).get
    q.find(:cell_view).append(UIButton, :deny_btn).on(:tap) do |sender|
      @delegate.deny_notification(sender)
    end
    q.find(:cell_view).append(UIButton, :accept_btn).on(:tap) do |sender|
      @delegate.accpet_notification(sender)
    end
  end

  def update(data)
    # Update data here
    # @name.text = data[:name]
    @name.text = "  John has a new selfie with you"

  end

end
