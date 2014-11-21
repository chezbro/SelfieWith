class IntroStylesheet < ApplicationStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def button_intro_screen(st)
    standard_button st
    st.frame = {w: (st.superview.size.width - 75)/2, fb:25, h: 50}
  end
  def join_us_btn(st)
    button_intro_screen st
    st.frame = {l:25}
    st.text  = "Sign Up"
  end

  def log_in_btn(st)
    button_intro_screen st
    st.frame = {fr:25}
    st.text  = "Sign In"
  end

end
