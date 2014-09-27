class SelfieCell < UICollectionViewCell
  attr_reader :reused

  def rmq_build
    rmq(self).apply_style :selfie_cell
    rmq(self.contentView).tap do |q|
      @image = q.append(UIImageView, :image).get
      @foo   = q.append(UILabel, :title).get
      q.append(UILabel, :like_count)
    end

  end

  def update(params)
    @foo.text = params[:index]
    if url = params[:url]
      @image.url = url
    end
  end

  def layoutSubviews
    super
    rmq(:image).reapply_styles
    rmq(:title).reapply_styles
    rmq(:like_count).reapply_styles
  end

  def prepareForReuse
    @reused = true
  end

end
