class AskContactsPermissionController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = AskContactsPermissionControllerStylesheet
    rmq(self.view).apply_style :root_view

    self.view.insertSubview(UIToolbar.alloc.initWithFrame(self.view.bounds), atIndex: 0)

    if AddressBook.request_authorization do |granted|
        if granted
          p "UIApplication.sharedApplication.delegate.open_main_controller"
          self.dismissViewControllerAnimated(true, completion:nil)
        end
      end
    end

    # TODO:: We need to setup a instruction about get access of contacts
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
