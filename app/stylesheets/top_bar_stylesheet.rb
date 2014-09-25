module TopBarStylesheet

  def top_bar(st)
    st.frame = {l:0, fr:0, h:80, t: 0}
    st.layer.masksToBounds = true
    # st.background_color = color.light_gray

    # Style overall view here
  end

  def user_info_view(st)
    st.background_color = color.clear
    st.frame = {l:0, t:20, w: st.superview.size.width/3*2, h:60}
  end
  def notification_view(st)
    st.background_color = color.clear
    st.frame = {fr:0, t:20, w: st.superview.size.width/3, h:60}
  end

  def navigation_bar(st)
    st.frame = {t:20, l:0, fr:0, h:44}
    st.layer.masksToBounds = true
    st.background_color = color.clear
  end
  def top_bar_back_btn(st)
    st.frame = {t:0, l:8, w: 62, h:44}
    st.text = " Back"
    st.color = color.nav_text
    st.image = image.resource('back_indicator')
  end
  def top_bar_menu_btn(st)
    st.frame = {t:0, fr:0, w: 70, h:44}
    st.text  = "Menu"
    st.color = color.nav_text
  end
  def top_bar_menu_close_btn(st)
    st.frame = {t:0, fr:0, w: 60, h:44}
    st.text  = "close"
  end
  def top_bar_label(st)
    st.frame          = {t:0, l:70, fr:70, h:44}
    st.text           = "Your Profile"
    st.text_alignment = :center
    st.color          = color.nav_text
  end
  def avatar_view(st)
    st.frame               = {w:64, h:64, centered: :both}
    st.layer.borderWidth   = 1
    st.layer.borderColor   = color.white.CGColor
    st.layer.cornerRadius  = 32
    st.layer.masksToBounds = true
  end
  def username_view(st)
    st.frame          = {fb:22, l:60, fr:60, h: 44, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.white
  end

  def menu_view(st)
    st.frame = {l:0, t:75, fb:0, fr:0}
  end

  def notification_icon(st)
    st.frame = {fr:15, w:20, h:20, centered: :vertical}
    st.image = image.resource('notification_tones')
  end
  def notification_count(st)
    st.frame               = {fr:40, w:40, h:20, centered: :vertical}
    st.background_color    = color.black
    st.layer.cornerRadius  = 10
    st.layer.masksToBounds = true
    st.text_alignment      = :center
    st.color               = color.white
    st.adjusts_font_size
  end
  def avatar(st)
    st.frame               = {l:15, w:40, h:40, centered: :vertical}
    st.layer.borderWidth   = 1
    st.layer.borderColor   = color.white.CGColor
    st.layer.cornerRadius  = 20
    st.layer.masksToBounds = true
  end
  def username(st)
    st.frame          = {l:65, fr:0, h: 18, centered: :vertical}
    st.text_alignment = :left
    st.color          = color.white
  end

  def avatar_profile(st)
    st.frame               = {t:80, w:64, h:64, centered: :horizontal}
    st.layer.borderWidth   = 1
    st.layer.borderColor   = color.white.CGColor
    st.layer.cornerRadius  = 32
    st.layer.masksToBounds = true
  end
  def username_profile(st)
    st.frame          = {t:158, l:10, fr:10, h: 18, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.white
  end

  def profile_overlay(st)
    st.frame = {l:0, fr:0, t:82, fb:0}
    st.background_color = color.from_rgba(0,0,0,0.8)
  end

  def notification_list(st)
    st.frame = {l:0, t:100, fb:0, fr:0}

  end
  def close_notification(st)
    st.background_color = color.red
    st.text = "close"
    st.frame = {fr:0, t:20, w: st.superview.size.width/3, h:60}
  end


end
