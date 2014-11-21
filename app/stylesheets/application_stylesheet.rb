class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup

    # Change the default grid if desired
    #   rmq.app.grid.tap do |g|
    #     g.num_columns =  12
    #     g.column_gutter = 10
    #     g.num_rows = 18
    #     g.row_gutter = 10
    #     g.content_left_margin = 10
    #     g.content_top_margin = 74
    #     g.content_right_margin = 10
    #     g.content_bottom_margin = 10
    #   end

    # An example of setting standard fonts and colors
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 18
    font.add_named :msmall,   font_family, 16
    font.add_named :xsmall,   font_family, 14

    color.add_named :tint, '236EB7'
    color.add_named :translucent_black, color.from_rgba(0, 0, 0, 0.4)
    color.add_named :battleship_gray,   '#7F7F7F'
    color.add_named :bg_black,          '#303134'
    color.add_named :darker_black,      '#1E1E1E'
    color.add_named :gray_black,        '#2A2A2A'
    color.add_named :nav_text,          '#999995'

    # UINavigationBar.appearance.setBarTintColor color.bg_black
    UINavigationBar.appearance.setBarStyle UIBarStyleBlack
    UINavigationBar.appearance.setTitleTextAttributes({
      # UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      UITextAttributeTextShadowColor => color.clear,
      UITextAttributeTextColor       => color.nav_text
    })
    UINavigationBar.appearance.setShadowImage UIImage.alloc.init
    # UITabBar.appearance.setBarTintColor color.bg_black
    UITabBar.appearance.setBarStyle UIBarStyleBlack
    UITabBar.appearance.setSelectionIndicatorImage image.resource('tabBarItem_selected')
    UITabBar.appearance.setSelectedImageTintColor color.white
    UIToolbar.appearance.setBarStyle UIBarStyleBlack
  end

  def standard_button(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.tint
    st.color = color.white
  end

  def standard_label(st)
    st.frame = {w: 40, h: 18}
    st.background_color = color.clear
    st.color = color.black
  end

  def text_field(st)
    st.frame                   = {l: 20, fr:20, h: 45}
    st.background_color        = color.darker_black
    st.view.font               = font.msmall
    st.text_alignment          = :center
    st.corner_radius           = 0
    st.text_color              = color.white
    st.clear_button_mode       = UITextFieldViewModeWhileEditing
    # st.view.color            = color.white
    # st.view.setKeyboardType(UIKeyboardTypeEmailAddress)
    # st.reloadInputViews
    st.view.keyboardAppearance = UIKeyboardAppearanceDark
    st.view.setValue(color.bg_black, forKeyPath:"_placeholderLabel.textColor")
    clearButton = st.view.valueForKey("_clearButton")
    clearButton.setImage(image.resource('clear_btn'), forState:UIControlStateNormal)
  end
  def text_field_label(st)
    st.frame          = {l:0, t:0, w: 80, h: 45, centered: :horizontal}
    st.text_alignment = :center
    st.color          = color.nav_text
    st.font           = font.xsmall
  end
end
