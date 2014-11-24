class NotificationsControllerStylesheet < ApplicationStylesheet

  include NotificationsCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color = color.clear
    st.view.separatorStyle = UITableViewCellSeparatorStyleNone
    st.view.contentInset = UIEdgeInsetsMake(10, 0, 100, 0)
  end

  def no_data(st)
    st.frame = {t:rmq.device.height - 350, fr:50, w: 250, h: 140}
    st.image = image.resource('ask_to_invite')
  end
end
