class SelfieCell < UICollectionViewCell
  attr_reader :reused

  def rmq_build
    rmq(self).apply_style :selfie_cell
    rmq(self.contentView).tap do |q|
      @image      = q.append(UIImageView, :image).get
      @title      = q.append(UILabel, :title).get.tap do |o|
        gradient = CAGradientLayer.layer
        gradient.frame = o.bounds
        gradient.colors = [rmq.color.from_rgba(0, 0, 0, 0.9).CGColor, rmq.color.from_rgba(0, 0, 0, 0).CGColor]
        gradient.locations = [0, 0.8]
        o.layer.addSublayer(gradient)
      end
      @like_count = q.append(UILabel, :like_count).get
      rmq(@like_count).append(UIImageView, :like_icon)
      # @like_count = q.append(UIButton, :like_count).get
    end

  end

  def update(params)
    if params[:non_taker]
      # @title.text = "  Selfie with " + params[:non_taker][0][:name]
      @title.text = "  Selfie with # Bug here"
    else
      @title.text = "  "
    end
    if url = params[:image]
      JMImageCache.sharedCache.imageForURL(url.to_url , completionBlock: lambda do |downloadedImage|
          @image.image = downloadedImage
          # @image.url = url
      end)
    end
    @like_count.text = "      " + params[:likes].to_s
    rmq(@like_count).reapply_styles
  end

  def layoutSubviews
    super
    rmq(@like_count).reapply_styles
    rmq(@image).reapply_styles
    rmq(@title).reapply_styles
  end

  def prepareForReuse
    @reused = true
  end

end
