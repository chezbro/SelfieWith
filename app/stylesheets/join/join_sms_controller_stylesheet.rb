class JoinSMSControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def sms_code_field(st)
    text_field st
    st.frame                       = {t: 100}
    st.placeholder                 = "Your confirmation code"
    st.text_alignment              = :center
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.view.keyboardType           = UIKeyboardTypeNumberPad
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end

  def resent_btn(st)
    standard_button st
    st.frame = {t: 160, l: 20, fr:20, h: 45}
  end
  def resent_btn_label(st)
    standard_button st
    st.frame = :full
    st.text_alignment = :center
    st.text = "Resend confirmation code"
  end
end
