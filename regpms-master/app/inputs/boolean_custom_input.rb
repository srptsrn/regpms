class BooleanCustomInput < SimpleForm::Inputs::Base
  
  def input
    @builder.check_box(attribute_name, input_html_options.merge(style: 'margin-top:11px;')) 
  end

end
