class TakeSelfieControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    # st.background_color = color.bg_black
    st.background_color   = color.clear
    # st.background_color = color.from_rgba(0,0,0,0.8)
  end

  def close_btn(st)
    st.frame               = {l:15, t:15, w:40 , h:40}
    st.image_normal        = image.resource('close_btn')
    # st.image_highlighted = image.resource('logo')
  end
  def toolbar(st)
    st.frame              = {l:0, fr:0, h:80, fb: 0}
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
  def use_toolbar(st)
    st.frame              = {l:0, fr:0, h:80, fb: 0}
    # st.background_color = color.red
    st.layer.zPosition    = 100
  end
  def retake_btn(st)
    st.frame = {centered: :vertical, l:0, w:st.superview.size.width/2, h:80}
    st.text  = "Retake"
  end
  def use_btn(st)
    st.frame = {centered: :vertical, fr: 0, w:st.superview.size.width/2, h:80}
    st.text  = "Use"
  end
  def image_view(st)
    st.frame               = {l:15, fr:15, t:56, h: four_inch? ? 430:430-88}
    st.background_color    = color.bg_black
    st.layer.cornerRadius  = 5
    st.layer.masksToBounds = true
    st.view.contentMode    = UIViewContentModeScaleAspectFill
  end
  def picker_view(st)
    st.frame               = {l:15, fr:15, t:56, h: four_inch? ? 430:430-88}
    st.background_color    = color.red
    st.layer.cornerRadius  = 5
    st.layer.masksToBounds = true
  end

  def chose_contact_overlay(st)
    st.frame = {fb:0, t: st.superview.size.height/2, l:0, fr:0}
  end
  def person_reminder(st)
    st.frame          = {t: 10, l:0, fr:0, h: 30}
    st.text           = "Who is this selfie with you?"
    st.color          = color.white
    st.text_alignment = :center
    st.font           = font.medium
  end

  def person_picker(st)
    st.frame            = {t: 60, l: 20, fr:20, h: 45}
    st.background_color = color.darker_black
    # st.text           = "Pick person form your contacts"
  end
  def person_name(st)
    st.frame          = {h:45, l:0, fr: 0, centered: :vertical}
    st.color          = color.white
    st.text_alignment = :center
  end
  def person_picker_done(st)
    standard_button st
    st.frame            = {t: 130, l: 20, fr:20, fb: 50}
    # st.background_color = color.darker_black
    st.text             = "Done"
    st.color            = color.white
    st.font             = font.medium
  end
end
