class TopBar < UIToolbar
  attr_accessor :delegate

  def rmq_build
    q = rmq(self)
    q.apply_style :top_bar

    q.append(UIView, :photos_view).hide.tap do |o|
      o.append(UIImageView, :photos_icon)
      @total_selfies = o.append(UILabel, :total_selfies).get
    end
    q.append(UIView, :likes_view).hide.tap do |o|
      o.append(UIImageView, :likes_icon)
      @total_likes = o.append(UILabel, :total_likes).get
    end
    @avatar = q.append(UIImageView, :avatar_view).hide.get
    # JMImageCache.sharedCache.imageForURL(Auth.avatar , completionBlock: lambda do |downloadedImage|
    #     @avatar.image = downloadedImage
    #     #@avatar.url = Auth.avatar
    # end)
    @avatar.url = Auth.avatar
    @username = q.append(UILabel, :username_view).hide.get
    @username.text = Auth.username


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
                  q.find(:avatar_view, :username_view).animations.fade_out
                  q.find(:photos_view, :likes_view).animations.fade_out
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
                  q.find(:avatar_view, :username_view, :photos_view, :likes_view).hide
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
                  q.find(:avatar_view, :username_view, :photos_view, :likes_view).animations.fade_in
                  q.find(:menu_view).hide
                }
              )
              o.find(:top_bar_back_btn, :top_bar_menu_btn).animations.fade_in
            end
            @top_bar_label = o.append(UILabel, :top_bar_label).get
          end
          q.find(:avatar_view, :username_view).show
          q.find(:photos_view, :likes_view).show
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

  end

  def update(params)
    @total_selfies.text      = params[:total_selfies].to_s
    @total_likes.text        = params[:total_likes].to_s
    if params[:notification].to_i > 99
      @notification_count.text = "99+"
    else
      @notification_count.text = params[:notification].to_s
    end
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
