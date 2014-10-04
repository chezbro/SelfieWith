module NotificationsCellStylesheet
  def notifications_cell_height
    160
  end

  def notifications_cell(st)
    # Style overall cell here
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_view(st)
    st.frame = {t: 5, w: st.superview.size.width - 30, h: 150, centered: :horizontal}
    st.background_color = color.random
    st.corner_radius = 4
    st.layer.masksToBounds = true
  end

  def cell_label(st)
    st.color = color.white
    st.frame = {l:5, t:5, fr:5}
  end

  def title_bg(st)
    st.frame            = {t:0, l:0, fr:0, h:25}
    st.color            = color.white
    st.font             = font.xsmall
    st.text_alignment   = :left
    st.background_color = color.clear
    st.view.layer.tap do |l|
      l.shadowColor   = color.black.CGColor
      l.shadowOpacity = 0.6
      l.shadowRadius  = 1.0
      l.shadowOffset  = [1.0, 2.0]
    end
  end
  def btn_bg(st)
    st.frame = {fb:0, l:0, fr:0, h:25}
  end

  def background_image(st)
    st.frame = {w: st.superview.size.width, h: st.superview.size.height, centered: :both}
    # st.image = image.resource('icon-512')
    st.view.contentMode = UIViewContentModeScaleAspectFill
    st.layer.masksToBounds = true
    st.corner_radius = 4
  end

  def deny_btn(st)
    st.frame = {fb:0, h:30, w: st.superview.size.width/2, l: 0}
    st.color = color.white
    # st.background_color = color.red
    st.text = "Deny"
    st.view.layer.tap do |l|
      l.shadowColor = color.black.CGColor
      l.shadowOpacity = 0.2
      l.shadowRadius = 1.0
      l.shadowOffset = [0.5, 1.0]
    end
  end

  def accept_btn(st)
    st.frame = {fb:0, h:30, w: st.superview.size.width/2, fr: 0}
    st.color = color.white
    st.text = "Accept"
    # st.background_color = color.blue
    st.view.layer.tap do |l|
      l.shadowColor = color.black.CGColor
      l.shadowOpacity = 0.2
      l.shadowRadius = 1.0
      l.shadowOffset = [0.5, 1.0]
    end
  end

end
