module ContactsCellStylesheet
  def contacts_cell_height
    60
  end

  def contacts_cell(st)
    # Style overall cell here
    st.background_color    = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def photo(st)
    st.frame               = {l: 10, t: 5, w: 50, h: 50}
    st.clips_to_bounds     = true
    st.layer.cornerRadius  = 25
    st.layer.masksToBounds = true
    st.image               = image.resource('avatar')
  end

  def name(st)
    st.color          = color.white
    st.text_alignment = :left
    st.frame          = {l: 70, t: 0, fr: 100, h: 60}
  end
  def btn(st)
    st.frame = {t: 10, fr: 20, w: 40, h: 40}
  end
end
