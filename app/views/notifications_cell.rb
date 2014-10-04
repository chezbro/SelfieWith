class NotificationsCell < UITableViewCell
  attr_accessor :delegate

  def rmq_build
    q = rmq(self.contentView)

    # Add your subviews, init stuff here
    # @foo = q.append(UILabel, :foo).get
    q.append(UIView, :cell_view)
    @selfie = q.find(:cell_view).append(UIImageView, :background_image).get
    @name = q.find(:cell_view).append(UILabel, :title_bg).get.tap do |o|
      gradient = CAGradientLayer.layer
      gradient.frame = o.bounds
      gradient.colors = [rmq.color.from_rgba(0, 0, 0, 0.9).CGColor, rmq.color.from_rgba(0, 0, 0, 0).CGColor]
      gradient.locations = [0, 0.8]
      o.layer.addSublayer(gradient)
    end
    q.find(:cell_view).append(UIView, :btn_bg).get.tap do |o|
      gradient = CAGradientLayer.layer
      gradient.frame = o.bounds
      gradient.colors = [rmq.color.from_rgba(0, 0, 0, 0).CGColor, rmq.color.from_rgba(0, 0, 0, 0.9).CGColor]
      gradient.locations = [0, 0.8]
      o.layer.addSublayer(gradient)
    end
    # @name = q.find(:title_bg).append(UILabel, :cell_label).get
    q.find(:cell_view).append(UIButton, :deny_btn).on(:tap) do |sender|
      @delegate.deny_notification(sender)
    end
    q.find(:cell_view).append(UIButton, :accept_btn).on(:tap) do |sender|
      @delegate.accept_notification(sender)
    end
  end

  def update(data)
    # Update data here
    @name.text = "  #{data[:name].to_s} has a new selfie with you"
    if url = data[:selfie]
      JMImageCache.sharedCache.imageForURL(url.to_url , completionBlock: lambda do |downloadedImage|
          @selfie.image = downloadedImage
      end)
    end
  end

end
