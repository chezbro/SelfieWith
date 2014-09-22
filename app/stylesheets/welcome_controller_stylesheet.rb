class WelcomeControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_image = image.resource('Default-568h')
  end

  def join_us_view(st)
    st.background_color = color.clear
    st.frame            = {l:0, w:st.superview.size.width/2, t:300, h: st.superview.size.height - 300}
  end

  def log_in_view(st)
    st.background_color = color.clear
    st.frame            = {l:st.superview.size.width/2, w:st.superview.size.width/2, t:300, h: st.superview.size.height - 300}
  end

  def join_us_btn(st)
    standard_button st
    st.frame = {l:20, fr:10, fb:25, h: 40}
    st.text  = "Sign Up"
  end

  def log_in_btn(st)
    standard_button st
    st.frame = {l:10, fr:20, fb:25, h: 40}
    st.text  = "Sign In"
  end

  def hello_world(st)
    st.frame = {t: 100, w: 200, h: 18}
    st.centered = :horizontal
    st.text_alignment = :center
    st.text = 'Hello World'
    st.color = color.battleship_gray
    st.font = font.medium
  end

end
