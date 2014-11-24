module ContactPickCellStylesheet
  def contact_pick_cell_height
    60
  end

  def contact_pick_cell(st)
    # Style overall cell here
    st.background_color = color.clear
    st.view.selectionStyle = UITableViewCellSelectionStyleNone
  end

  def cell_label(st)
    st.color = color.white
  end
end
