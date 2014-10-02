class ProfileTopBar < UIToolbar
  attr_accessor :delegate

  def rmq_build
    q = rmq(self)
    q.apply_style :profile_top_bar

    q.append(UIView, :avatar_view).tap do |o|
      @avatar = o.append(UIImageView, :avatar).get
      @avatar.url = Auth.avatar
    end
    q.append(UIView, :photos_view).tap do |o|
      o.append(UIImageView, :photos_icon)
    end
    q.append(UIView, :likes_view).tap do |o|
      o.append(UIImageView, :likes_icon)
    end

    @username = q.append(UILabel, :username).get
    @username.text = Auth.username


    q.append(UIButton, :take_selfie).on(:tap) do |sender|
      @delegate.take_selfie
    end
    q.append(UIButton, :back_btn).on(:tap) do |sender|
      @delegate.close
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
