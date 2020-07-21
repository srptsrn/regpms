class AttachmentCustomInput < SimpleForm::Inputs::Base
  
  def input
    
    an = "#{attribute_name}?"

    atc = ''
    atc += %{<div class='fileupload fileupload-new' data-provides='fileupload'>}
    atc += %{<div class='fileupload-new thumbnail' style='width: 150px; height: 150px;'>}
    atc += %{<img src='#{object.send(an) ? object.send(attribute_name) : ""}' alt='' />}
    atc += %{</div>}
    atc += %{<div class='fileupload-preview fileupload-exists thumbnail' style='max-width: 150px; max-height: 150px; line-height: 20px;'></div>}
    unless input_html_options[:disabled]
      atc += %{<div>}
      atc += %{<span class='btn btn-default btn-file'>}
      atc += %{<span class='fileupload-new'><i class='fa fa-paper-clip'></i> #{t(:select_image)}</span>}
      atc += %{<span class='fileupload-exists'><i class='fa fa-undo'></i> #{t(:change_image)}</span>}
      atc += %{#{@builder.file_field(attribute_name, input_html_options)}}
      atc += %{</span>}
      atc += %{</div>}
    end
    atc += %{<div class='clearfix'></div>}
    atc += %{</div>}
    atc.html_safe
    
  end
  
end
