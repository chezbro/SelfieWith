class SelfieLayout < UICollectionViewLayout
  attr_accessor :delegate

  def delegate
    @delegate
  end

  def shortestColumnIndex
    @columns.find_index(@columns.min).to_i
  end

  def longestColumnIndex
    @columns.find_index(@columns.max).to_i
  end

  def columnWidth
    return (self.collectionView.bounds.size.width - 30 - 20).to_f / 3
  end

  def prepareLayout
    @columns = Array.new(3){10}

    itemsCount = self.collectionView.numberOfItemsInSection(0)
    @itemsAttributes = []

    0..itemsCount.times do |i|
      indexPath = NSIndexPath.indexPathForItem(i, inSection:0)
      columnIndex = shortestColumnIndex

      if i < 3
        itemWidth = columnWidth * 3 + 20
        itemHeight = columnWidth * 2 + 10

        xOffset = 15
        yOffset = @columns[0]

        @columns[0] = yOffset + itemHeight + 10
        @columns[1] = yOffset + itemHeight + 10
        @columns[2] = yOffset + itemHeight + 10
        # case columnIndex
        # when 2
        #   if @columns.uniq.count == 1
        #     columnIndex = 1

        #     xOffset = columnIndex * columnWidth + 15 + 10*columnIndex
        #     yOffset = @columns[columnIndex].to_i

        #     @columns[columnIndex] = yOffset + itemHeight + 10
        #     @columns[columnIndex+1] = yOffset + itemHeight + 10
        #   else
        #     xOffset = 0 * columnWidth + 15 + 10*0
        #     yOffset = @columns[0].to_i

        #     @columns[0] = yOffset + itemHeight + 10
        #     @columns[1] = yOffset + itemHeight + 10
        #   end
        # when 0
        #   if @columns.uniq.count == 1
        #     columnIndex = 1

        #     xOffset = columnIndex * columnWidth + 15 + 10*columnIndex
        #     yOffset = @columns[columnIndex].to_i

        #     @columns[columnIndex] = yOffset + itemHeight + 10
        #     @columns[columnIndex+1] = yOffset + itemHeight + 10
        #   else
        #     xOffset = 0 * columnWidth + 15 + 10*0
        #     yOffset = @columns[0].to_i

        #     @columns[0] = yOffset + itemHeight + 10
        #     @columns[1] = yOffset + itemHeight + 10
        #   end
        # else
        #   xOffset = columnIndex * columnWidth + 15 + 10*columnIndex
        #   yOffset = @columns[columnIndex].to_i

        #   @columns[columnIndex] = yOffset + itemHeight + 10
        #   @columns[columnIndex+1] = yOffset + itemHeight + 10
        # end
      else
        itemWidth = columnWidth
        itemHeight = columnWidth

        xOffset = columnIndex * columnWidth + 15 + 10*columnIndex
        yOffset = @columns[columnIndex].to_i

        @columns[columnIndex] = yOffset + columnWidth + 10
      end

      attributes = UICollectionViewLayoutAttributes.layoutAttributesForCellWithIndexPath(indexPath)
      attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight)
      @itemsAttributes << attributes
    end
  end

  def layoutAttributesForElementsInRect(rect)
    retVal = []
    @itemsAttributes.each do |i|
      retVal << i if CGRectIntersectsRect(rect, i.frame)
    end
    retVal
  end

  def layoutAttributesForItemAtIndexPath(indexPath)
    @itemsAttributes[indexPath]
  end

  def collectionViewContentSize
    retVal = self.collectionView.bounds.size
    retVal.height = @columns[longestColumnIndex].to_f
    retVal
  end
end
