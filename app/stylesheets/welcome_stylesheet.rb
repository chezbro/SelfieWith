class WelcomeStylesheet < ApplicationStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_image = image.resource('welcome-background')
  end

  def logo_white(st)
    st.frame = {t: 60, w: 250, h: 80}
    st.centered = :horizontal
    st.image = image.resource('logo-white')
  end

  def icon_white(st)
    st.frame = {t: 200, w: 150, h: 150}
    st.centered = :horizontal
    st.image = image.resource('icon-white')
  end

  def slogan_label(st)
    st.frame = {t: 150, l: 10, fr: 10, h: 18}
    st.centered = :horizontal
    st.text_alignment = :center
    st.text = 'one selfie with each contacts'
    st.color = color.white
    st.font = font.small
  end

  def copyright_label(st)
    st.frame = {fb: -55, l: 10, fr: 10, h: 10}
    st.centered = :horizontal
    st.text_alignment = :center
    st.text = 'Copyright @ 2014 SelfieWith.co'
    st.color = color.white
    st.font = font.coypright
  end

  def login_button(st)
    st.frame = {l: 30, fb: 15, fr:30, h: 40}
    st.background_color = color.from_rgba(255,255,255, 0.32)
    st.layer.borderWidth = 1
    st.layer.borderColor = color.white.CGColor
    st.color = color.white
    st.corner_radius = 3
    st.text = "Log in"
    st.view.setTitleColor(color.gray, forState: UIControlStateHighlighted)
  end

  def signup_button(st)
    st.frame = {l: 30, fb: -40, fr:30, h: 40}
    st.background_color = color.from_rgba(255,255,255, 0.12)
    st.layer.borderWidth = 1
    st.layer.borderColor = color.white.CGColor
    st.color = color.white
    st.corner_radius = 3
    st.text = "Sign up"
    st.view.setTitleColor(color.gray, forState: UIControlStateHighlighted)
  end
end
