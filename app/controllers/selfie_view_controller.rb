class SelfieViewController < UIViewController
  attr_accessor :selfie, :photos

  def self.new(args = {})
    s = self.alloc
    s.selfie = args[:selfie]
    s
  end

  def viewDidLoad
    super
    @photos = []
    @photos[0] = @selfie

    rmq.stylesheet = SelfieViewControllerStylesheet
    rmq(self.view).apply_style :root_view

    # photoPagesController = EBPhotoPagesController.alloc.initWithDataSource(self, delegate:self)
    # @selfie_view = rmq.append(photoPagesController.view, :selfie_view).get
  #   # Create your views here
    @selfie_view = rmq.append(UIImageView, :selfie_view).get
    # @selfie_view.on(:tap) {
    #   p "tap"
    # }
    # @selfie_view.url = @selfie["image"]["url"]
    JMImageCache.sharedCache.imageForURL(@selfie["image_url"].to_url , completionBlock: lambda do |downloadedImage|
      @selfie_view.image = downloadedImage
      # @image.url = url
    end)

    rmq.append(UIButton, :like_btn).on(:touch) { like_selfie }
    # rmq.append(UIButton, :comment_btn).hide.on(:touch) { comment_selfie }
    @like_btn = rmq(:like_btn).get

    if @selfie["like"]
      @like_btn.setImage(rmq.image.resource('heart_like'), forState:UIControlStateNormal)
      @like_btn.setTitle("  Unlike", forState:UIControlStateNormal)
    else
      @like_btn.setImage(rmq.image.resource('heart_unlike'), forState:UIControlStateNormal)
      @like_btn.setTitle("  Like", forState:UIControlStateNormal)
    end
    if @selfie["status"] == "pendding"
      rmq(:like_btn, :comment_btn).hide
    end


    self.navigationItem.tap do |nav|
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("More",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :more_action)
    end

  end

  def more_action
    @action_sheet = UIActionSheet.alloc.init
    @action_sheet.delegate = self

    @action_sheet.destructiveButtonIndex = 0
    @action_sheet.addButtonWithTitle "Report abuse"
    @action_sheet.cancelButtonIndex = (@action_sheet.addButtonWithTitle "Cancel")

    @action_sheet.showInView self.view
  end
  def actionSheet(actionSheet, clickedButtonAtIndex: index)
    case actionSheet.buttonTitleAtIndex(index)
    when "Report abuse"
      # Report abuse
      AFMotion::SessionClient.shared.get("selfies/#{@selfie[:id]}/abuse") do |result|
        if result
          self.navigationController.popViewControllerAnimated(true)
        else
        end
      end
    when "Cancel"
    else
      p "Unrecognized button title #{actionSheet.buttonTitleAtIndex(index)}"
    end
  end


  def like_selfie
    AFMotion::SessionClient.shared.get("selfies/#{@selfie[:id]}/like") do |result|
      if result
        if result.object[:action] == "like"
          @like_btn.setImage(rmq.image.resource('heart_like'), forState:UIControlStateNormal)
          @like_btn.setTitle("  Unlike", forState:UIControlStateNormal)
        else
          @like_btn.setImage(rmq.image.resource('heart_unlike'), forState:UIControlStateNormal)
          @like_btn.setTitle("  Like", forState:UIControlStateNormal)
        end
      else
      end
    end
  end

  # def comment_selfie
  #   SimpleSI.alert("Need to do")
  # end

  # def goto_profile
  #   # SimpleSI.alert("Will open the profile screen, or send invite to hime")
  # end

  # For PhotoPageController
  def photoPagesController(photoPagesController, shouldExpectPhotoAtIndex: index)
    if index < @photos.count
      if index >= 0
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def photoPagesController(controller, imageAtIndex:index, completionHandler: handler)
    selfie = @photos[index]
    JMImageCache.sharedCache.imageForURL(selfie[:image_url].to_url, completionBlock: lambda do |downloadedImage|
      handler.call(downloadedImage)
    end)
  end


  def photoPagesController(controller, attributedCaptionForPhotoAtIndex:index, completionHandler: handler)

      # dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      # dispatch_async(queue, ^{
      #     DEMOPhoto *photo = self.photos[index];
      #     if(self.simulateLatency){
      #         sleep(arc4random_uniform(2)+arc4random_uniform(2));
      #     }

      #     handler(photo.attributedCaption);
      # });
  end

  def photoPagesController(controller, captionForPhotoAtIndex:index,completionHandler:handler)
    selfie = @photos[index]
    p selfie
    handler.call("SelfeWith #{selfie[:non_taker_names]}")
  end


  def photoPagesController(controller, metaDataForPhotoAtIndex:index, completionHandler: handler)
      # dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      # dispatch_async(queue, ^{
      #     DEMOPhoto *photo = self.photos[index];
      #     if(self.simulateLatency){
      #         sleep(arc4random_uniform(2)+arc4random_uniform(2));
      #     }

      #     handler(photo.metaData);
      # });
  end

  def photoPagesController(controller, tagsForPhotoAtIndex:index, completionHandler: handler)
      # dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      # dispatch_async(queue, ^{
      #     DEMOPhoto *photo = self.photos[index];
      #     if(self.simulateLatency){
      #         sleep(arc4random_uniform(2)+arc4random_uniform(2));
      #     }

      #     handler(photo.tags);
      # });
  end

  def photoPagesController(controller, commentsForPhotoAtIndex:index, completionHandler: handler)
    # selfie = @photos[index]
    # p selfie
    # handler.call("SelfeWith #{selfie[:non_taker_names]}")
      # dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      # dispatch_async(queue, ^{
      #     DEMOPhoto *photo = self.photos[index];
      #     if(self.simulateLatency){
      #         sleep(arc4random_uniform(2)+arc4random_uniform(2));
      #     }

      #     handler(photo.comments);
      # });
  end


  def photoPagesController(controller, numberOfcommentsForPhotoAtIndex:index, completionHandler: handler)
    0
    # photo = @photos[index]
    # handler(photo.comments.count);
  end


  def photoPagesController(photoPagesController, didReportPhotoAtIndex:index)
    p "Reported photo at index #{index}"
      # Do something about this image someone reported.
  end


  def photoPagesController(controller, didDeleteComment: deletedComment, forPhotoAtIndex:index)
    photo = @photos[index]
    remainingComments = NSMutableArray.arrayWithArray(photo.comments)
    remainingComments.removeObject(deletedComment)
    photo.setComments(NSArray.arrayWithArray(remainingComments))
  end


  def photoPagesController(controller, didDeleteTagPopover: tagPopover, inPhotoAtIndex:index)
    photo = @photos[index]
    remainingTags = NSMutableArray.arrayWithArray(photo.tags)
    tagData = tagPopover.dataSource
    remainingTags.removeObject(tagData)
    photo.setTags(NSArray.arrayWithArray(remainingTags))
  end

  def photoPagesController(photoPagesController, didDeletePhotoAtIndex:index)
    p "Delete photo at index #{index}"
    deletedPhoto = @photos[index]
    remainingPhotos = NSMutableArray.arrayWithArray(@photos)
    remainingPhotos.removeObject(deletedPhoto)
    self.setPhotos(remainingPhotos)
  end

  def photoPagesController(photoPagesController, didAddNewTagAtPoint: tagLocation, withText: tagText, forPhotoAtIndex: index, tagInfo: tagInfo)
    p "Add new tag #{tagText}"
    photo = @photos[index]
    newTag = DEMOTag.tagWithProperties({})
      # newTag = [DEMOTag tagWithProperties:@{
      #                                                @"tagPosition" : [NSValue valueWithCGPoint:tagLocation],
      #                                                @"tagText" : tagText}];

    mutableTags = NSMutableArray.arrayWithArray(photo.tags)
    mutableTags.addObject(newTag)
    photo.setTags(NSArray.arrayWithArray(mutableTags))
  end


  def photoPagesController(controller, didPostComment: comment, forPhotoAtIndex:index)
    newComment = DEMOComment.commentWithProperties({})
      # DEMOComment *newComment = [DEMOComment
      #                            commentWithProperties:@{@"commentText": comment,
      #                                                    @"commentDate": [NSDate date],
      #                                                    @"authorImage": [UIImage imageNamed:@"guestAv.png"],
      #                                                    @"authorName" : @"Guest User"}];
    newComment.setUserCreated(true)
    photo = @photos[index]
    photo.addComment(newComment)
    controller.setComments(photo.comments, forPhotoAtIndex:index)
  end

  #pragma mark - User Permissions

  def photoPagesController(photoPagesController, shouldAllowTaggingForPhotoAtIndex: index)
    return false
  end

  def photoPagesController(controller, shouldAllowDeleteForComment: comment, forPhotoAtIndex:index)
    # We assume all comment objects used in the demo are of type DEMOComment
    demoComment = comment;

    if(demoComment.isUserCreated)
      # Demo user can only delete his or her own comments.
      return true
    end

    return false
  end


  def photoPagesController(photoPagesController, shouldAllowCommentingForPhotoAtIndex:index)
    if @photos.count
      return false
    end

    photo = @photos[index]

    if photo.disabledCommenting
      return false
    else
      return true
    end
  end


  def photoPagesController(photoPagesController, shouldAllowActivitiesForPhotoAtIndex:index)
    if @photos.count
      return false
    end

    photo = @photos[index]

    if photo.disabledActivities
      return false
    else
      return true
    end
  end

  def photoPagesController(photoPagesController, shouldAllowMiscActionsForPhotoAtIndex:index)
    if @photos.count
      return false
    end

    photo = @photos[index]

    if photo.disabledMiscActions
      return false
    else
      return true
    end
  end

  def photoPagesController(photoPagesController, shouldAllowDeleteForPhotoAtIndex: index)
    # Disable
    return false
  end

  def photoPagesController(photoPagesController, shouldAllowDeleteForTag: tagPopover, inPhotoAtIndex: index)
    # Disable Tag
    return false
  end

  def photoPagesController(photoPagesController, shouldAllowEditingForTag: tagPopover, inPhotoAtIndex: index)
    # Disable Tag
    return false
  end

  def photoPagesController(photoPagesController, shouldAllowReportForPhotoAtIndex: index)
    true
  end

  def photoPagesControllerDidDismiss(photoPagesController)
    p "Finished using #{photoPagesController}"
  end
  # END PhotoPageController


  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end
end


__END__

# You don't have to reapply styles to all UIViews, if you want to optimize,
# another way to do it is tag the views you need to restyle in your stylesheet,
# then only reapply the tagged views, like so:
def logo(st)
  st.frame = {t: 10, w: 200, h: 96}
  st.centered = :horizontal
  st.image = image.resource('logo')
  st.tag(:reapply_style)
end

# Then in willAnimateRotationToInterfaceOrientation
rmq(:reapply_style).reapply_styles
