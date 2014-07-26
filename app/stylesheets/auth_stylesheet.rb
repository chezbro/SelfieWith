class AuthStylesheet < ApplicationStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_image = image.resource('screen-background')
  end

  def logo_white(st)
    st.frame = {t: 30, w: 250, h: 80}
    st.centered = :horizontal
    st.image = image.resource('logo-white')
  end

  def copyright_label(st)
    st.frame = {fb: -55, l: 10, fr: 10, h: 10}
    st.centered = :horizontal
    st.text_alignment = :center
    st.text = 'Copyright @ 2014 SelfieWith.co'
    st.color = color.white
    st.font = font.coypright
  end

  def username(st)
    text_field st
    st.frame = {l: 30, t: 125, fr:30, h: 40}
    st.placeholder = "Username"
    st.view.spellCheckingType = UITextSpellCheckingTypeNo
    st.view.autocorrectionType = UITextAutocorrectionTypeNo
  end

  def password(st)
    text_field st
    st.frame = {l: 30, t: 180, fr:30, h: 40}
    st.placeholder = "Password"
    st.view.secureTextEntry = true
  end

  def login_button(st)
    standard_button st
    st.frame = {l: 30, t: 235, fr:30, h: 40}
    st.text = "Log in"
  end

end
