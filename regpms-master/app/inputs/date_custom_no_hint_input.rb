class DateCustomNoHintInput < SimpleForm::Inputs::Base
  
  def input
    %{<div class="input-group" style="width:175px;">} + 
    %{<span class="input-group-addon"><i class="fa fa-calendar"></i></span>} + 
    "#{@builder.text_field(attribute_name, input_html_options.merge("data-date-format" => "dd/mm/yyyy"))}" +
    "</div>".html_safe
  end
  
  def input_html_classes
    super.push('form-control input-md date_picker')
  end
  
end
