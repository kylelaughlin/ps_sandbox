module ApplicationHelper

  def money amount
    "$#{amount/100}"
  end

end
