module ApplicationHelper

  def my_form_for(record, options = {}, &block)
    form_for(record, options.merge!(builder: MyFormBuilder), &block)
  end

  def options_tag_for_rating(selected=nil)
    options_for_select( [5,4,3,2,1].map { |number| [pluralize(number, "Star"), number] }, selected)
  end

end
