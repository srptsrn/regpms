class DatetimeCustomInput < SimpleForm::Inputs::Base
  
  def input
    %{<div class="input-group" style="width:335px;">} + 
    %{<span class="input-group-addon"><i class="fa fa-clock-o"></i></span>} + 
    "#{@builder.text_field(attribute_name, input_html_options.merge("data-date-format" => "dd/mm/yyyy hh:ii"))}" +
    %{<span class="input-group-addon">DD/MM/YYYY HH:MM</span>} + 
    "</div>".html_safe
  end
  
  def input_html_classes
    super.push('form-control input-md datetime_picker')
  end
  
end