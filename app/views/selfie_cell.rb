class SelfieCell < UICollectionViewCell
  attr_reader :reused

  def rmq_build
    rmq(self).apply_style :selfie_cell
    rmq(self.contentView).tap do |q|
      @image        = q.append(UIImageView, :image).get
      @pedding_icon = q.append(UIImageView, :pedding_icon).hide.get
      @title        = q.append(UILabel, :title).get.tap do |o|
        gradient = CAGradientLayer.layer
        # gradient.frame = o.bounds
        gradient.frame = CGRectMake(0, 0, rmq.app.window.size.width, 25)
        gradient.colors = [rmq.color.from_rgba(0, 0, 0, 0.9).CGColor, rmq.color.from_rgba(0, 0, 0, 0).CGColor]
        gradient.locations = [0, 0.8]
        # o.layer.addSublayer(gradient)
        o.layer.insertSublayer(gradient, atIndex:0)
      end
      @like_count = q.append(UILabel, :like_count).get
      rmq(@like_count).append(UIImageView, :like_icon)
      @pedding_icon = q.append(UIImageView, :pedding_icon).get
      # @like_count = q.append(UIButton, :like_count).get
    end

  end

  def update(params)
    if params[:non_taker_names]
      # @title.text = "  Selfie with " + params[:non_taker][0][:name]
      if rmq(self).frame.w > 100
        @title.text = "  SelfieWith #{params[:non_taker_names]}"
      else
        @title.text = " #{params[:non_taker_names]}"
      end
    else
      @title.text = "  "
    end
    if url = params[:image_url]
      JMImageCache.sharedCache.imageForURL(url.to_url , completionBlock: lambda do |downloadedImage|
          @image.image = downloadedImage
          # @image.url = url
      end)
    end
    if params[:status] == "pendding"
      rmq(@like_count).hide
      rmq(@pedding_icon).show.reapply_styles
    else
      @like_count.text = "      " + params[:likes].to_s
      rmq(@like_count).show.reapply_styles
      rmq(@pedding_icon).hide
    end
  end

  def layoutSubviews
    super
    rmq(@like_count).reapply_styles
    rmq(@image).reapply_styles
    rmq(@title).reapply_styles
    rmq(@pedding_icon).reapply_styles
  end

  def prepareForReuse
    @reused = true
  end

end
