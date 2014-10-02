class TopBar < UIToolbar
  attr_accessor :delegate

  def rmq_build
    q = rmq(self)
    q.apply_style :top_bar

    q.append(UIButton, :user_info_view).on(:tap) do |sender|
      q.animate(
        duration: 0.5,
        animations: -> (q) {
          q.find(:user_info_view, :notification_view).hide
          q.layout t:0, h: 200

          @menu_view ||= MenusController.new(delegate: @delegate)
          q.append(@menu_view.view, :menu_view).hide

          q.append(UIToolbar, :navigation_bar).animations.fade_in.tap do |o|
            o.append(UIButton, :top_bar_back_btn).on(:tap) do |sender|
              o.animations.fade_out.remove
              q.animate(
                duration: 0.3,
                animations: lambda{|q|
                  q.find(:user_info_view, :notification_view).show
                  q.layout t:0, h: 80
                  q.find(:avatar_view, :username_view).animations.fade_out.remove
                  q.find(:menu_view).hide.remove
                }
              )
            end
            o.append(UIButton, :top_bar_menu_btn).on(:tap) do |sender|
              q.animate(
                duration: 0.3,
                animations: lambda{|q|
                  q.layout t:0, fb: 0
                  @top_bar_label.text = "Settings"
                  o.find(:top_bar_back_btn, :top_bar_menu_btn).hide
                  o.find(:top_bar_menu_close_btn).show
                  q.find(:avatar_view, :username_view).hide
                  q.find(:menu_view).show
                }
              )
            end
            o.append(UIButton, :top_bar_menu_close_btn).hide.on(:tap) do |sender|
              o.find(:top_bar_menu_close_btn).hide
              q.animate(
                duration: 0.3,
                animations: lambda{|q|
                  q.layout t:0, h: 200
                  @top_bar_label.text = "Your Profile"
                  q.find(:avatar_view, :username_view).animations.fade_in
                  q.find(:menu_view).hide
                }
              )
              o.find(:top_bar_back_btn, :top_bar_menu_btn).animations.fade_in
            end
            @top_bar_label = o.append(UILabel, :top_bar_label).get
          end
          @avatar = q.append(UIImageView, :avatar_view).get
          @avatar.url = Auth.avatar
          @username = q.append(UILabel, :username_view).get
          @username.text = Auth.username
        },
        completion: -> (did_finish, q) {
        }
      )
      # SimpleSI.alert("User Info")
      # rmq.wrap(rmq.app.window).tap do |o|
      #   o.append(UIView, :profile_overlay).animations.fade_in.on(:tap) do |sender|
      #     o.find(sender, :profile_overlay).hide.remove
      #   end
      # end
    end
    q.append(UIButton, :notification_view).on(:tap) do |sender|
      SimpleSI.alert("Notification")
    end
    @avatar = q.find(:user_info_view).append(UIImageView, :avatar).get
    @avatar.url = Auth.avatar
    @username = q.find(:user_info_view).append(UILabel, :username).get
    @username.text = Auth.username
    q.find(:notification_view).append(UIImageView, :notification_icon)
    @notification_count = q.find(:notification_view).append(UILabel, :notification_count).get
    @notification_count.text = "999"
  end

  def rmq_appended
    # p @delegate
    # q = rmq(self)
    # q.apply_style :top_bar

    # @menu_view = MenusController.new(delegate: @delegate)
    # q.append(@menu_view.view, :menu_view).hide
  end

  def rmq_created
    # p "From created"
    # p @delegate
    # p "End created"
  end

end

# To style this view include its stylesheet at the top of each controller's
# stylesheet that is going to use it:
#   class SomeStylesheet < ApplicationStylesheet
#     include TopBarStylesheet

# Another option is to use your controller's stylesheet to style this view. This
# works well if only one controller uses it. If you do that, delete the
# view's stylesheet with:
#   rm app/stylesheets/views/top_bar.rb
