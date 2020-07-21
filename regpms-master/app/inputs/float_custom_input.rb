class FloatCustomInput < SimpleForm::Inputs::Base
  
  def input
    @builder.text_field(attribute_name, input_html_options)
  end
  
  def input_html_classes
    super.push('col-xs-11 col-md-9 col-lg-6 number_decimal_comma')
  end
  
end
