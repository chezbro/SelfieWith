class ContactsCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)

    rmq(self.contentView).tap do |q|
      @image = q.append(UIImageView, :photo).get
      @foo   = q.append(UILabel, :name).get
      @btn   = q.append(UIButton, :btn).get
    end
  end

  def update(data)
    # Update data here
    person    = data
    @foo.text = person.composite_name
    if person.photo
      @image.image = UIImage.alloc.initWithData(person.photo)
    elsif person.avatar
      JMImageCache.sharedCache.imageForURL(person.avatar.to_url , completionBlock: lambda do |downloadedImage|
          @image.image = downloadedImage
      end)
    end

    if person.username
      @btn.setImage(rmq.image.resource('photos_icon'), forState:UIControlStateNormal)
    else
      @btn.setImage(rmq.image.resource('invite_icon'), forState:UIControlStateNormal)
    end
  end
end
