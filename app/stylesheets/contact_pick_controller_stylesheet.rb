class ContactPickControllerStylesheet < ApplicationStylesheet

  include ContactPickCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color = color.bg_black
    # st.view.separatorInset = UIEdgeInsetsMake(-10, 0, 0, 0)
    # st.view.contentInset = UIEdgeInsetsMake(60, 0, 0, 0)
    st.view.sectionIndexBackgroundColor = color.light_gray
    st.view.sectionIndexTrackingBackgroundColor = color.white
  end
end
