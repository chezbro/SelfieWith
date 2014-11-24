class MenusControllerStylesheet < ApplicationStylesheet

  include MenusCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color           = color.clear
    st.view.separatorStyle        = UITableViewCellSeparatorStyleNone
    st.view.contentInset          = UIEdgeInsetsMake(0, 0, 80, 0)
    st.view.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 80, 0)
  end

  def menu_section_header(st)
    st.frame            = {l:0, fb:0, fr:0, h: 50}
    st.background_color = color.clear
  end
  def menu_section_header_label(st)
    st.frame            = {l:15, fb:15, fr:15, h: 20}
    st.background_color = color.clear
    st.color            = color.nav_text
    st.font             = font.xsmall
  end

end
