class MyFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    errors = object.errors[method.to_sym].join(', ')
    if !errors.blank?
      super + @template.content_tag(:span, errors)
    else
      super
    end
  end
  
  def password_field(method, options = {})
    errors = object.errors[method.to_sym].join(', ')
    if !errors.blank?
      super + @template.content_tag(:span, errors)
    else
      super
    end
  end

end
