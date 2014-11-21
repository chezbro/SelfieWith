module CountryPickerCellStylesheet
  def country_picker_cell_height
    44
  end

  def country_picker_cell(st)
    # Style overall cell here
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_label(st)
    st.frame = {fr: 70, l: 16, h:44, centered: :vertical}
    st.color = color.white
    st.text_alignment = :left
  end

  def cell_code_label(st)
    st.color          = color.light_gray
    st.frame          = {fr: 30, w: 70, h:44, centered: :vertical}
    st.text_alignment = :right
  end
end
