# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :orb_bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'col-md-4 control-label'
    b.wrapper tag: 'div', class: 'col-md-6' do |ba|
      ba.use :input, class: 'form-control input-md'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :full, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'col-md-12 control-label text-left'
    b.wrapper tag: 'div', class: 'col-md-12' do |ba|
      ba.use :input, class: 'form-control input-md'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :no_wrap, tag: 'div', class: '', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :input, class: 'form-control input-md'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end
  
  config.wrappers :nested_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-md-12' do |ba|
      ba.use :input, class: 'form-control input-md'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :placeholder, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-md-12' do |ba|
      ba.use :input, class: 'form-control input-md'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group, tag: 'div', class: 'form-group margin-bottom-5', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-md-12' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon'
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end

  config.wrappers :login, tag: 'section', error_class: 'state-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'row' do |bb|
      bb.wrapper tag: 'div', class: 'col col-xs-12' do |bbb|
        bbb.wrapper tag: 'div', class: 'input' do |bbbb|
          bbbb.use :hint,  wrap_with: { tag: 'span', class: 'icon-append' }
          bbbb.use :input
        end
        bbb.use :error, wrap_with: { tag: 'span', class: 'help-block text-red' }
      end
    end
  end
  
  config.wrappers :input_group_12, tag: 'div', class: 'col-sm-12 col-md-12', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_11, tag: 'div', class: 'col-sm-12 col-md-11', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_10, tag: 'div', class: 'col-sm-12 col-md-10', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_9, tag: 'div', class: 'col-sm-12 col-md-9', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_8, tag: 'div', class: 'col-sm-12 col-md-8', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_7, tag: 'div', class: 'col-sm-12 col-md-7', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_6, tag: 'div', class: 'col-sm-12 col-md-6', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_5, tag: 'div', class: 'col-sm-12 col-md-5', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_4, tag: 'div', class: 'col-sm-12 col-md-4', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_3, tag: 'div', class: 'col-sm-12 col-md-3', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_2, tag: 'div', class: 'col-sm-12 col-md-2', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end
  
  config.wrappers :input_group_1, tag: 'div', class: 'col-sm-12 col-md-1', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'form-group no-margin-right' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |bb|
        bb.use :label, class: 'input-group-addon small', style: "min-width:100px; text-align:right;"
        bb.use :input, class: 'form-control input-md'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block pull-right' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :orb_bootstrap
end
