class NSString
  # Fixed the emoji bug
  def safe_range(min, max)
    max_length = [self.size - min, max].min
    range = self.rangeOfComposedCharacterSequencesForRange(NSMakeRange(min, max_length))
    self[min...range.length]
  end

  def get_first
    safe_range(0, 1)
  end
end