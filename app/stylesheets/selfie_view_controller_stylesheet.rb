class SelfieViewControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.black
  end

  def selfie_view(st)
    st.frame = :full
    st.view.contentMode = UIViewContentModeScaleAspectFit
  end

  def like_btn(st)
    standard_button st
    st.frame = {l:10, fb:10, w:(st.superview.size.width-20), h: 40}
    st.text  = "  Like"
    st.image = image.resource('heart_unlike')
  end

  def comment_btn(st)
    standard_button st
    st.frame = {fr:10, fb:10, w:(st.superview.size.width-30)/2, h: 40}
    st.text  = "Comment"
  end

end
