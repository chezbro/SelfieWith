class LoginStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def username_text_field(st)
    text_field st
    st.frame = {t: 100}
    st.placeholder = "Your username"
    st.text_alignment = :left
    st.view.spellCheckingType = UITextSpellCheckingTypeNo
    st.view.autocorrectionType = UITextAutocorrectionTypeNo
    st.left_view_mode = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def username_text_label(st)
    text_field_label st
    st.text = 'Username'
  end

  def password_text_field(st)
    text_field st
    st.frame = {t: 160}
    st.placeholder = "Your password"
    st.text_alignment = :left
    st.view.secureTextEntry = true
    st.left_view_mode = UITextFieldViewModeAlways
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def password_text_label(st)
    text_field_label st
    st.text = 'Password'
  end

  def forget_password(st)
    standard_button st
    st.background_color = color.clear
    st.font = font.xsmall
    st.color = color.nav_text
    st.frame = {l:20, fr: 20, t:220, h:40}
    st.text  = "Forgot Password"
    st.view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight

  end

  def hint_label(st)
    st.frame          = {l:10, t:70, fr: 10, h: 17, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.red
    st.font           = font.xsmall
    st.text           = 'Your password or user name are wrong'
  end
end
