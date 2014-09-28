module SelfieCellStylesheet

  def selfie_cell(st)
    st.background_color    = color.random
    st.clips_to_bounds     = true
    st.layer.cornerRadius  = 4
    st.layer.masksToBounds = true
  end

  def selfie_cell_content(st)
    st.frame = {fb: 0, fr:0, t:0, l:0}
  end

  def image(st)
    st.frame            = {fb: 0, fr:0, t:0, l:0}
    st.view.contentMode = UIViewContentModeScaleAspectFill
  end
  def title(st)
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
  def like_count(st)
    st.frame            = {fb: 5, fr:5, h:20}
    st.color            = color.white
    st.font             = font.xsmall
    st.text_alignment   = :right
    st.resize_to_fit_text
    st.view.layer.tap do |l|
      l.shadowColor   = color.black.CGColor
      l.shadowOpacity = 0.6
      l.shadowRadius  = 1.0
      l.shadowOffset  = [1.0, 2.0]
    end
  end
  def like_icon(st)
    st.frame            = {t:0, l:0, w: 20, h:20}
    st.view.contentMode = UIViewContentModeScaleAspectFit
    st.image            = image.resource('like_icon')
    st.view.layer.tap do |l|
      l.shadowColor   = color.black.CGColor
      l.shadowOpacity = 0.6
      l.shadowRadius  = 1.0
      l.shadowOffset  = [1.0, 2.0]
    end
  end
end
