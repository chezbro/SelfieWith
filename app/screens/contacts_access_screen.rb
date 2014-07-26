class ContactsAccessScreen < PM::Screen
  title 'ContactsAccessScreen'

  def on_load
    # Sets a top of 0 to be below the navigation control
    self.edgesForExtendedLayout = UIRectEdgeNone

    rmq.stylesheet = HomeStylesheet
    rmq(self.view).apply_style :root_view

    if AddressBook.request_authorization do |granted|
        # this block is invoked sometime later
        if granted
          # do something now that the user has said "yes"
          close
        else
          # do something now that the user has said "no"
        end
      end
    # do something here before the user has decided
    end

    # Create your UIViews here
    @hello_world_label = rmq.append(UILabel, :hello_world).get
    @hello_world_label.text = "ContactsAccessScreen"
    @hello_world_label.color = rmq.color.white
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
