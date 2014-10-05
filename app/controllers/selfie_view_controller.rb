class SelfieViewController < UIViewController
  attr_accessor :selfie

  def self.new(args = {})
    s = self.alloc
    s.selfie = args[:selfie]
    s
  end

  def viewDidLoad
    super

    rmq.stylesheet = SelfieViewControllerStylesheet
    rmq(self.view).apply_style :root_view

    # Create your views here
    @selfie_view = rmq.append(UIImageView, :selfie_view).get
    # @selfie_view.url = @selfie["image"]["url"]
    JMImageCache.sharedCache.imageForURL(@selfie["image"].to_url , completionBlock: lambda do |downloadedImage|
        @selfie_view.image = downloadedImage
        # @image.url = url
    end)

    rmq.append(UIButton, :like_btn).on(:touch) { like_selfie }
    rmq.append(UIButton, :comment_btn).on(:touch) { comment_selfie }
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
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("SelfieWith #{@selfie[:non_taker_names] if @selfie}",
                                                                    style: UIBarButtonItemStylePlain,
                                                                    target: self, action: :goto_profile)
    end

  end

  def like_selfie
    # SimpleSI.alert("Need to do")
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true

    params = {selfie: @selfie[:id]}
    API.post('like', params) do |result|
      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
      if result
        if result[:action] == "like"
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

  def comment_selfie
    SimpleSI.alert("Need to do")
  end

  def goto_profile
    # SimpleSI.alert("Will open the profile screen, or send invite to hime")
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
