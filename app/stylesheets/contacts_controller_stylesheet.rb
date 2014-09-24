class ContactsControllerStylesheet < ApplicationStylesheet

  include ContactsCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def table(st)
    st.background_color = color.bg_black
    # st.view.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0)
    st.view.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
    st.view.sectionIndexBackgroundColor = color.light_gray
    st.view.sectionIndexTrackingBackgroundColor = color.white
  end
end
