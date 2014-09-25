module MenusCellStylesheet
  def menus_cell_height
    40
  end

  def menus_cell(st)
    # Style overall cell here
    st.background_color = color.clear
  end

  def cell_label(st)
    st.color = color.nav_text
  end
end
