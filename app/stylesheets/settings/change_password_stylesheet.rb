class LoginControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def old_password_text_field(st)
    text_field st
    st.frame                       = {t: 100}
    st.placeholder                 = "Your Current Password"
    st.text_alignment              = :center
    st.view.secureTextEntry = true
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.left_view_mode              = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def old_password_text_label(st)
    text_field_label st
    st.text = 'Username'
  end

  def new_password_text_field(st)
    text_field st
    st.frame                       = {t: 160}
    st.placeholder                 = "Your New Password"
    st.text_alignment              = :center
    st.view.secureTextEntry = true
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.left_view_mode              = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def new_password_text_label(st)
    text_field_label st
    st.text = 'Username'
  end

  def new_password_again_text_field(st)
    text_field st
    st.frame                       = {t: 220}
    st.placeholder                 = "Confirmation Your New Password"
    st.text_alignment              = :center
    st.view.secureTextEntry = true
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.left_view_mode              = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def new_password_again_text_label(st)
    text_field_label st
    st.text = 'Username'
  end

end
