class TextCustomInput < SimpleForm::Inputs::Base
  
  def input
    @builder.text_area(attribute_name, input_html_options)
  end
  
  def input_html_classes
    super.push('form-control input-md')
  end
  
end
