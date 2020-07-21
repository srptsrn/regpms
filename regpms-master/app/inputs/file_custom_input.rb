class FileCustomInput < SimpleForm::Inputs::Base
  
  def input
    
    an = "#{attribute_name}?"
    obj = object.send(an) ? object.send(attribute_name) : nil

    atc = ''
    atc += %{<div class='fileupload fileupload-new pull-left' data-provides='fileupload'>}
    if obj
      atc += %{<a href="#{obj.url}" target="_blank" class='btn btn-link' style="width:180px; overflow:hidden; text-align:left;">}
      atc += %{<i class="fa fa-download"></i> #{obj.original_filename}}
      atc += %{</a>}
    end 
    unless input_html_options[:disabled]
      atc += %{<div class='fileupload-preview fileupload-exists btn btn-link' style="width:180px; overflow:hidden; text-align:left;"></div>}
      atc += %{<span class='btn btn-default btn-file'>}
      atc += %{<span class='fileupload-new'><i class='fa fa-paper-clip'></i> #{t(:select_file)}</span>}
      atc += %{<span class='fileupload-exists'><i class='fa fa-undo'></i> #{t(:change_file)}</span>}
      atc += %{#{@builder.file_field(attribute_name, input_html_options)}}
      atc += %{</span>}
    end
    atc += %{</div>}
    atc += %{<div class="clearfix"></div>}
    atc.html_safe
    
  end
  
end
