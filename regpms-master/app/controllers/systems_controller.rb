class SystemsController < OrbController
  
  skip_authorization_check
  
  def workflow_states
    models = Dir['app/models/*.rb'].map {|f| File.basename(f, '.*').camelize.constantize.name }
    @models = models.select {|m| eval(m).respond_to?(:workflow_spec)}.collect {|m| eval(m)}
  end
  
end
