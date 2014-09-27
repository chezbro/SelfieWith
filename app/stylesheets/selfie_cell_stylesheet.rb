module SelfieCellStylesheet

  def selfie_cell(st)
    st.background_color = color.random
    st.clips_to_bounds = true
    st.layer.cornerRadius  = 4
    st.layer.masksToBounds = true
  end

  def selfie_cell_content(st)
    st.frame = {fb: 0, fr:0, t:0, l:0}
  end

  def image(st)
    # st.frame = :full
    # st.frame = st.superview.bounds
    st.frame = {fb: 0, fr:0, t:0, l:0}
    st.view.contentMode = UIViewContentModeScaleAspectFill
  end
  def title(st)
    st.frame = {t:2, l:2, fr:2, h:15}
    st.text = "Frank & you"
    st.color = color.white
    st.font  = font.xsmall
    st.text_alignment = :left
  end
  def like_count(st)
    st.frame = {fb: 2, fr:2, h:15, w:10}
    st.color = color.white
    st.font  = font.xsmall
    st.text_alignment = :right
    st.text = "120"
    st.adjusts_font_size
  end
end
