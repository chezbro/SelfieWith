module ProfileTopBarStylesheet

  def profile_top_bar(st)
    st.frame = {l:0, fr:0, h:150, t: 0}
    st.layer.masksToBounds = true
    # st.background_color = color.light_gray

    # Style overall view here
  end

  def avatar_view(st)
    st.frame = {t:66, w: st.superview.size.width/3, centered: :horizontal, h: st.superview.size.height-66}
  end
  def photos_view(st)
    st.frame = {t:66, l: 0, w: st.superview.size.width/3, h: st.superview.size.height-66}
  end
  def likes_view(st)
    st.frame = {t:66, fr: 0, w: st.superview.size.width/3, h: st.superview.size.height-66}
  end

  def avatar(st)
    st.frame               = {w:64, h:64, centered: :both}
    st.layer.borderWidth   = 1
    st.layer.borderColor   = color.white.CGColor
    st.layer.cornerRadius  = 32
    st.layer.masksToBounds = true
    st.view.contentMode    = UIViewContentModeScaleAspectFill
  end
  def username(st)
    st.frame          = {t:22, l:60, fr:60, h: 44, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.nav_text
  end

  def photos_icon(st)
    st.frame = {w:30, h:24, centered: :horizontal, t:15}
    st.image = image.resource('photos_icon')
  end
  def likes_icon(st)
    st.frame = {w:30, h:24, centered: :horizontal, t:15}
    st.image = image.resource('like_icon')
  end
  def total_selfies(st)
    st.frame          = {w:st.superview.size.width, h:24, centered: :horizontal, t:50}
    st.text_alignment = :center
    st.color          = color.white
    # st.text         = "120"
  end
  def total_likes(st)
    st.frame          = {w:st.superview.size.width, h:24, centered: :horizontal, t:50}
    st.text_alignment = :center
    st.color          = color.white
    # st.text         = "120"
  end

  def take_selfie(st)
    st.background_color = color.clear
    st.image_normal = image.resource('take_selfie')
    st.frame = {fr:0, t:22, w: 60, h:44}
  end
  def back_btn(st)
    st.background_color = color.clear
    st.text = " Back"
    st.color = color.nav_text
    st.image_normal = image.resource('back_indicator')
    st.frame = {l:0, t:22, w: 80, h:44}
  end
end
