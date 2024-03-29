class AskContactsPermissionControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.clear
  end

  def tips(st)
    st.frame = :full
    st.image = image.resource('contacts_access')
  end
end
