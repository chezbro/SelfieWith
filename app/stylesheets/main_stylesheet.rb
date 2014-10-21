class MainStylesheet < ApplicationStylesheet

  include TopBarStylesheet
  include SelfieCellStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.bg_black
  end

  def collection_view(st)
    st.view.contentInset = [60, 0, 0, 0]
    st.background_color = color.bg_black
    st.view.alwaysBounceVertical = true

    # st.view.collectionViewLayout.tap do |cl|
    #   cl.invalidateLayout
    #   # cl.itemSize = [cell_size[:w], cell_size[:h]]
    #   # cl.scrollDirection = UICollectionViewScrollDirectionHorizontal
    #   # cl.headerReferenceSize = [cell_size[:w], cell_size[:h]]
    #   # cl.minimumInteritemSpacing = @margin
    #   # cl.minimumLineSpacing = @margin
    #   # cl.sectionInset = [15,15,15,15]
    # end
  end

  def no_data(st)
    st.frame = {t:rmq.device.height - 250, w: 272, h: 140, centered: :horizontal}
    st.image = image.resource('ask_to_take')
  end
end
