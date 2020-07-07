class ConfirmsController < OrbController
  
  # authorize_resource :class => false
  # skip_authorization_check
  authorize_resource :class => false
  
  def user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      redirect_to action: "index"
      return false
    end
  end
  
  def confirm_selected
    unless User.exists?(params[:id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    
    params[:job_plan_ids] ||= []
    params[:job_plan_ids].each do |job_plan_id|
      job_plan = @user.job_plans.find(job_plan_id)
      job_plan.confirm! if job_plan.current_state.to_sym == :enabled
    end
    
    params[:job_routine_ids] ||= []
    params[:job_routine_ids].each do |job_routine_id|
      job_routine = @user.job_routines.find(job_routine_id)
      job_routine.confirm! if job_routine.current_state.to_sym == :enabled
    end
    
    params[:job_vice_ids] ||= []
    params[:job_vice_ids].each do |job_vice_id|
      job_vice = @user.job_vices.find(job_vice_id)
      job_vice.confirm! if job_vice.current_state.to_sym == :enabled
    end
    
    params[:job_development_ids] ||= []
    params[:job_development_ids].each do |job_development_id|
      job_development = @user.job_developments.find(job_development_id)
      job_development.confirm! if job_development.current_state.to_sym == :enabled
    end
    
    #####
    
    params[:job_plan_result_ids] ||= []
    params[:job_plan_result_ids].each do |job_plan_result_id|
      job_plan_result = @user.job_plan_results.find(job_plan_result_id)
      job_plan_result.confirm! if job_plan_result.current_state.to_sym == :enabled
    end
    
    params[:job_routine_result_ids] ||= []
    params[:job_routine_result_ids].each do |job_routine_result_id|
      job_routine_result = @user.job_routine_results.find(job_routine_result_id)
      job_routine_result.confirm! if job_routine_result.current_state.to_sym == :enabled
    end
    
    params[:job_vice_result_ids] ||= []
    params[:job_vice_result_ids].each do |job_vice_result_id|
      job_vice_result = @user.job_vice_results.find(job_vice_result_id)
      job_vice_result.confirm! if job_vice_result.current_state.to_sym == :enabled
    end
    
    params[:job_development_result_ids] ||= []
    params[:job_development_result_ids].each do |job_development_result_id|
      job_development_result = @user.job_development_results.find(job_development_result_id)
      job_development_result.confirm! if job_development_result.current_state.to_sym == :enabled
    end
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_plan
    unless User.exists?(params[:id]) && JobPlan.exists?(params[:job_plan_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_plan = @user.job_plans.find(params[:job_plan_id])
    @job_plan.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_plan
    unless User.exists?(params[:id]) && JobPlan.exists?(params[:job_plan_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_plan = @user.job_plans.find(params[:job_plan_id])
    @job_plan.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_routine
    unless User.exists?(params[:id]) && JobRoutine.exists?(params[:job_routine_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_routine = @user.job_routines.find(params[:job_routine_id])
    @job_routine.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_routine
    unless User.exists?(params[:id]) && JobRoutine.exists?(params[:job_routine_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_routine = @user.job_routines.find(params[:job_routine_id])
    @job_routine.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_vice
    unless User.exists?(params[:id]) && JobVice.exists?(params[:job_vice_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_vice = @user.job_vices.find(params[:job_vice_id])
    @job_vice.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_vice
    unless User.exists?(params[:id]) && JobVice.exists?(params[:job_vice_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_vice = @user.job_vices.find(params[:job_vice_id])
    @job_vice.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_development
    unless User.exists?(params[:id]) && JobDevelopment.exists?(params[:job_development_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_development = @user.job_developments.find(params[:job_development_id])
    @job_development.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_development
    unless User.exists?(params[:id]) && JobDevelopment.exists?(params[:job_development_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_development = @user.job_developments.find(params[:job_development_id])
    @job_development.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  
  
  
  
  
  
  
  def confirm_job_plan_result
    unless User.exists?(params[:id]) && JobPlan.exists?(params[:job_plan_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_plan_result = @user.job_plan_results.find(params[:job_plan_result_id])
    @job_plan_result.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_plan_result
    unless User.exists?(params[:id]) && JobPlan.exists?(params[:job_plan_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_plan_result = @user.job_plan_results.find(params[:job_plan_result_id])
    @job_plan_result.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_routine_result
    unless User.exists?(params[:id]) && JobRoutine.exists?(params[:job_routine_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_routine_result = @user.job_routine_results.find(params[:job_routine_result_id])
    @job_routine_result.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_routine_result
    unless User.exists?(params[:id]) && JobRoutine.exists?(params[:job_routine_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_routine_result = @user.job_routine_results.find(params[:job_routine_result_id])
    @job_routine_result.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_vice_result
    unless User.exists?(params[:id]) && JobVice.exists?(params[:job_vice_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_vice_result = @user.job_vice_results.find(params[:job_vice_result_id])
    @job_vice_result.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_vice_result
    unless User.exists?(params[:id]) && JobVice.exists?(params[:job_vice_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_vice_result = @user.job_vice_results.find(params[:job_vice_result_id])
    @job_vice_result.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def confirm_job_development_result
    unless User.exists?(params[:id]) && JobDevelopment.exists?(params[:job_development_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_development_result = @user.job_development_results.find(params[:job_development_result_id])
    @job_development_result.confirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
  def unconfirm_job_development_result
    unless User.exists?(params[:id]) && JobDevelopment.exists?(params[:job_development_result_id])
      redirect_to action: "index"
      return false
    end
    
    @user = User.find(params[:id])
    @job_development_result = @user.job_development_results.find(params[:job_development_result_id])
    @job_development_result.unconfirm!
    
    redirect_to action: "user", id: @user
    return false
  end
  
end
