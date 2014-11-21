class CountryPickerCell < UITableViewCell

  def rmq_build
    q = rmq(self.contentView)

    @name = q.append(UILabel, :cell_label).get
    @code = q.append(UILabel, :cell_code_label).get
  end

  def update(data)
    # Update data here
    @name.text = data[:name]
    @code.text = data[:dial_code]
  end

end
