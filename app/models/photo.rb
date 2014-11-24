class Photo
  attr_accessor :image, :caption, :attributedCaption, :tags, :comments, :metaData, :disabledTagging, :disabledCommenting, :disabledActivities, :disabledDelete, :disabledDeleteForTags, :disabledDeleteForComments, :disabledMiscActions

  class << self
    def photoWithProperties(photoInfo)
      self.initWithProperties(photoInfo)
    end

    def initWithProperties(photoInfo)
      @image = UIImage.imageNamed(photoInfo["imageFile"])
      # if self

      #   self.setImage UIImage.imageNamed(photoInfo["imageFile"])
      #   self.setCaption photoInfo["caption"]
      #   self.setAttributedCaption photoInfo["attributedCaption"]
      #   self.setTags photoInfo["tags"]
      #   self.setComments photoInfo["comments"]
      #   self.setMetaData photoInfo["metaData"]
      # end
      self
    end

    def addComment
      mutableComments = NSMutableArray.arrayWithArray(self.comments)
      unless mutableComments
        mutableComments = NSMutableArray.array
      end
      mutableComments.addObject(comment)

      self.setComments(NSArray.arrayWithArray(mutableComments))
    end
  end
end