class JoinUsernameControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end
  def main_view(st)
    st.frame = {t: 64, fb: 0, w: st.superview.size.width, l: 0}
    st.content_size = CGSizeMake(st.superview.size.width, 280)
  end

  def selfie_view(st)
    st.frame               = {t:0, w:80, h:80, centered: :horizontal}
    st.layer.cornerRadius  = 40
    st.layer.masksToBounds = true
    st.view.contentMode    = UIViewContentModeScaleAspectFill
  end
  def selfie_view_placehoder(st)
    st.frame               = {t:0, w:80, h:80, centered: :horizontal}
    st.image               = image.resource('add_selfie')
    st.layer.cornerRadius  = 40
    st.layer.masksToBounds = true
    st.view.contentMode    = UIViewContentModeScaleAspectFill
  end

  def overlay(st)
    st.frame = :full
    st.background_color = color.from_rgba(0,0,0,0.8)
  end
  def toolbar(st)
    st.frame              = {l:0, fr:0, h:80, fb: 10}
    # st.background_color = color.red
    st.layer.zPosition    = 100
  end
  def take_btn(st)
    st.frame             = {centered: :both, w:st.superview.size.width/3, h:80}
    st.image_normal      = image.resource('take_btn')
    st.image_highlighted = image.resource('take_btn')
  end
  def chose_btn(st)
    st.frame             = {centered: :vertical, l: 0, w:st.superview.size.width/3, h:80}
    st.image_normal      = image.resource('pickphoto_btn')
    st.image_highlighted = image.resource('pickphoto_btn')
  end
  def toggle_camera_btn(st)
    st.frame             = {centered: :vertical,fr: 0, w:st.superview.size.width/3, h:80}
    st.image_normal      = image.resource('toggle_camera_btn')
    st.image_highlighted = image.resource('toggle_camera_btn')
  end
  def image_view(st)
    st.frame               = {w:256, h:256, centered: :both}
    st.background_color    = color.bg_black
    st.layer.cornerRadius  = 128
    st.layer.masksToBounds = true
    st.view.contentMode    = UIViewContentModeScaleAspectFill
  end
  def picker_view(st)
    st.frame               = {w:256, h:256, centered: :both}
    st.background_color    = color.red
    st.layer.cornerRadius  = 128
    st.layer.masksToBounds = true
  end

  def username_text_field(st)
    text_field st
    st.frame                       = {t: 130}
    st.placeholder                 = "Choose your username"
    st.text_alignment              = :left
    st.view.spellCheckingType      = UITextSpellCheckingTypeNo
    st.view.autocorrectionType     = UITextAutocorrectionTypeNo
    st.left_view_mode              = UITextFieldViewModeAlways
    st.view.autocapitalizationType = UITextAutocapitalizationTypeNone
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def username_text_label(st)
    text_field_label st
    st.text = 'Username'
  end

  def password_text_field(st)
    text_field st
    st.frame = {t: 180}
    st.placeholder = "Choose your password"
    st.text_alignment = :left
    st.view.secureTextEntry = true
    st.left_view_mode = UITextFieldViewModeAlways
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def password_text_label(st)
    text_field_label st
    st.text = 'Password'
  end

  def email_text_field(st)
    text_field st
    st.frame                   = {t: 230}
    st.placeholder             = "Enter your email"
    st.text_alignment          = :left
    st.view.spellCheckingType  = UITextSpellCheckingTypeNo
    st.view.autocorrectionType = UITextAutocorrectionTypeNo
    st.view.keyboardType       = UIKeyboardTypeEmailAddress
    st.left_view_mode          = UITextFieldViewModeAlways
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
  end
  def email_text_label(st)
    text_field_label st
    st.text = 'Email'
  end

  def hint_label(st)
    st.frame          = {l:10, t:100, fr: 10, h: 17, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.white
    st.font           = font.xsmall
    st.text           = 'Please chose your username and password.'
  end

end
