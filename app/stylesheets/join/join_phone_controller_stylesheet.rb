class JoinPhoneControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def country_picker(st)
    st.frame = {t: 100, l: 20, fr:20, h: 45}
    st.background_color = color.darker_black
  end

  def country_picker_global(st)
    st.frame = {w:25, h:25, l:10, centered: :vertical}
    st.image = image.resource('global_icon')
  end
  # def country_picker_next(st)
  #   st.frame = {w:9, h:15, fr:10, centered: :vertical}
  #   st.image = image.resource('next_indicator')
  # end
  def country_picker_label(st)
    st.frame = {h:45, l:45, fr: 45, centered: :vertical}
    st.color = color.white
    st.text_alignment = :center
  end

  def phone_number_field(st)
    text_field st
    st.frame                       = {t: 160}
    st.placeholder                 = "Your phone number"
    st.text_alignment              = :center
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.view.keyboardType           = UIKeyboardTypePhonePad
    st.left_view_mode              = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def country_code_label(st)
    text_field_label st
    st.frame = {l:0, t:0, w: 80, h: 45, centered: :horizontal}
    st.color = color.nav_text
    st.font  = font.msmall
  end

  def hint_label(st)
    st.frame          = {l:10, t:70, fr: 10, h: 17, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.white
    st.font           = font.xsmall
    st.text           = 'Please input your phone number.'
  end

end
