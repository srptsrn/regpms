# encoding:utf-8
class PfsController < OrbController
  
  # authorize_resource :class => false
  # skip_authorization_check
  authorize_resource :class => false
  
  before_filter :has_current_evaluation?
  skip_before_filter :verify_authenticity_token, :only => [:upload_job_plan_result, :upload_job_routine_result, :upload_job_vice_result, :upload_job_development_result]
  
  def index
    @result_leaves = get_leaves(@current_evaluation.year - 543, current_user.pid, @current_evaluation.query_start_date, @current_evaluation.query_end_date)
  
    @query_start_date = @current_evaluation.query_start_date
    @query_end_date = @current_evaluation.query_end_date
  end
  
  def x
    @q = User.limit(params[:limit]).search(params[:q])
    @q.sorts = 'firstname, lastname' if @q.sorts.empty?
    @users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 200) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def x_user
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      @result_leaves = get_leaves(@current_evaluation.year - 543, @user.pid, @current_evaluation.query_start_date, @current_evaluation.query_end_date)
    
      @query_start_date = @current_evaluation.query_start_date
      @query_end_date = @current_evaluation.query_end_date
    else
      redirect_to action: 'x'
      return false
    end
  end
  
  def print
    if !params[:evaluation_id].blank? && Evaluation.exists?(params[:evaluation_id])
      @evaluation = Evaluation.find(params[:evaluation_id])
    else
      @evaluation = @current_evaluation
    end
    if User.exists?(params[:id])
      @user = User.find(params[:id])
      
      render layout: "print_landscape"
      return false
    else
      redirect_to action: 'x'
      return false
    end
  end
  
  # plan ##############################################################################################################################################################################################
  def add_job_plan_result
    
    if JobResultTemplate.exists?(params[:job_result_template_id]) && JobPlan.exists?(params[:job_plan_id])
      @job_plan = JobPlan.find(params[:job_plan_id])
      @job_result_template = JobResultTemplate.find(params[:job_result_template_id])
      
      if JobPlanResult.where(["user_id = ? AND evaluation_id = ? AND job_plan_id = ? AND job_result_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_plan.id, @job_result_template.id, :enabled]).size == 0
        @job_plan_result = JobPlanResult.create(
          user_id: current_user.id, 
          evaluation_id: @current_evaluation.id, 
          job_plan_id: @job_plan.id,
          job_result_template_id: @job_result_template.id, 
          unit: @job_result_template.unit, 
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_result_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_plan = JobPlan.find(params[:job_plan_id])
      
      @job_plan_result = JobPlanResult.new(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        job_plan_id: @job_plan.id,
        name: params[:name], 
        workflow_state: :enabled
      )
      unless @job_plan_result.save
        @error_message = "#{@job_plan_result.errors.messages.collect {|kk, vv| "#{kk} #{vv}"}}"
      end
    else
      @error_message = "ไม่พบงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_plan_result
    
    if JobPlanResult.exists?(params[:job_plan_result_id])
      @job_plan_result = JobPlanResult.find(params[:job_plan_result_id])
      params[:edit] = true
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end

  def update_job_plan_result
    
    if JobPlanResult.exists?(params[:job_plan_result_id])
      @job_plan_result = JobPlanResult.find(params[:job_plan_result_id])
      @job_plan_result.name = params[:name] unless params[:name].blank?
      @job_plan_result.qty = params[:qty] unless params[:qty].blank?
      @job_plan_result.unit = params[:unit] unless params[:unit].blank?
      @job_plan_result.description = params[:description] unless params[:description].blank?
      @job_plan_result.save if current_user.id == @job_plan_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_plan_result
    
    if JobPlanResult.exists?(params[:job_plan_result_id])
      @job_plan_result = JobPlanResult.find(params[:job_plan_result_id])
      @job_plan_result.terminate! if current_user.id == @job_plan_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def upload_job_plan_result
    
    if JobPlanResult.exists?(params[:job_plan_result_id])
      @job_plan_result = JobPlanResult.find(params[:job_plan_result_id])
      @job_plan_result_file = JobPlanResultFile.new(
        job_plan_result_id: @job_plan_result.id, 
        file: params["new_job_plan_result_file_#{@job_plan_result.id}"][:file], 
        description: params["new_job_plan_result_file_#{@job_plan_result.id}"][:description], 
        workflow_state: :enabled
      )
      unless @job_plan_result_file.save
        @error_message = @job_plan_result_file.errors.messages.collect {|k, v| "#{k} #{v.join(', ')}"}.join(', ')
      end
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
      format.html {redirect_to action: "index"}
    end
  end
  
  def remove_job_plan_result_file
    
    if JobPlanResultFile.exists?(params[:job_plan_result_file_id])
      @job_plan_result_file = JobPlanResultFile.find(params[:job_plan_result_file_id])
      @job_plan_result_file.terminate! if current_user.id == @job_plan_result_file.job_plan_result.user_id
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_plan_result_file
    
    if JobPlanResultFile.exists?(params[:job_plan_result_file_id])
      @job_plan_result_file = JobPlanResultFile.find(params[:job_plan_result_file_id])
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_plan_result_file
    
    if JobPlanResultFile.exists?(params[:job_plan_result_file_id])
      @job_plan_result_file = JobPlanResultFile.find(params[:job_plan_result_file_id])
      @job_plan_result_file.description = params["job_plan_result_file_#{params[:job_plan_result_file_id]}"][:description]
      @job_plan_result_file.file = params["job_plan_result_file_#{params[:job_plan_result_file_id]}"][:file] unless params["job_plan_result_file_#{params[:job_plan_result_file_id]}"][:file].blank?
      @job_plan_result_file.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_plan_self_point
    
    if JobPlan.exists?(params[:job_plan_id])
      @job_plan = JobPlan.find(params[:job_plan_id])
      @job_plan.self_point = params[:self_point]
      @job_plan.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  # routine ##############################################################################################################################################################################################
  def add_job_routine_result
    
    if JobResultTemplate.exists?(params[:job_result_template_id]) && JobRoutine.exists?(params[:job_routine_id])
      @job_routine = JobRoutine.find(params[:job_routine_id])
      @job_result_template = JobResultTemplate.find(params[:job_result_template_id])
      
      if JobRoutineResult.where(["user_id = ? AND evaluation_id = ? AND job_routine_id = ? AND job_result_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_routine.id, @job_result_template.id, :enabled]).size == 0
        @job_routine_result = JobRoutineResult.create(
          user_id: current_user.id, 
          evaluation_id: @current_evaluation.id, 
          job_routine_id: @job_routine.id,
          job_result_template_id: @job_result_template.id, 
          unit: @job_result_template.unit, 
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_result_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_routine = JobRoutine.find(params[:job_routine_id])
      
      @job_routine_result = JobRoutineResult.new(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        job_routine_id: @job_routine.id,
        name: params[:name], 
        workflow_state: :enabled
      )
      unless @job_routine_result.save
        @error_message = "#{@job_routine_result.errors.messages.collect {|kk, vv| "#{kk} #{vv}"}}"
      end
    else
      @error_message = "ไม่พบงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_routine_result
    
    if JobRoutineResult.exists?(params[:job_routine_result_id])
      @job_routine_result = JobRoutineResult.find(params[:job_routine_result_id])
      params[:edit] = true
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_routine_result
    
    if JobRoutineResult.exists?(params[:job_routine_result_id])
      @job_routine_result = JobRoutineResult.find(params[:job_routine_result_id])
      @job_routine_result.name = params[:name] unless params[:name].blank?
      @job_routine_result.qty = params[:qty] unless params[:qty].blank?
      @job_routine_result.unit = params[:unit] unless params[:unit].blank?
      @job_routine_result.description = params[:description] unless params[:description].blank?
      @job_routine_result.save if current_user.id == @job_routine_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_routine_result
    
    if JobRoutineResult.exists?(params[:job_routine_result_id])
      @job_routine_result = JobRoutineResult.find(params[:job_routine_result_id])
      @job_routine_result.terminate! if current_user.id == @job_routine_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def upload_job_routine_result
    
    if JobRoutineResult.exists?(params[:job_routine_result_id])
      @job_routine_result = JobRoutineResult.find(params[:job_routine_result_id])
      @job_routine_result_file = JobRoutineResultFile.new(
        job_routine_result_id: @job_routine_result.id, 
        file: params["new_job_routine_result_file_#{@job_routine_result.id}"][:file], 
        description: params["new_job_routine_result_file_#{@job_routine_result.id}"][:description], 
        workflow_state: :enabled
      )
      unless @job_routine_result_file.save
        @error_message = @job_routine_result_file.errors.messages.collect {|k, v| "#{k} #{v.join(', ')}"}.join(', ')
      end
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
      format.html {redirect_to action: "index"}
    end
  end
  
  def remove_job_routine_result_file
    
    if JobRoutineResultFile.exists?(params[:job_routine_result_file_id])
      @job_routine_result_file = JobRoutineResultFile.find(params[:job_routine_result_file_id])
      @job_routine_result_file.terminate! if current_user.id == @job_routine_result_file.job_routine_result.user_id
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_routine_result_file
    
    if JobRoutineResultFile.exists?(params[:job_routine_result_file_id])
      @job_routine_result_file = JobRoutineResultFile.find(params[:job_routine_result_file_id])
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_routine_result_file
    
    if JobRoutineResultFile.exists?(params[:job_routine_result_file_id])
      @job_routine_result_file = JobRoutineResultFile.find(params[:job_routine_result_file_id])
      @job_routine_result_file.description = params["job_routine_result_file_#{params[:job_routine_result_file_id]}"][:description]
      @job_routine_result_file.file = params["job_routine_result_file_#{params[:job_routine_result_file_id]}"][:file] unless params["job_routine_result_file_#{params[:job_routine_result_file_id]}"][:file].blank?
      @job_routine_result_file.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_routine_self_point
    
    if JobRoutine.exists?(params[:job_routine_id])
      @job_routine = JobRoutine.find(params[:job_routine_id])
      @job_routine.self_point = params[:self_point]
      @job_routine.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  # vice ##############################################################################################################################################################################################
  def add_job_vice_result
    
    if JobResultTemplate.exists?(params[:job_result_template_id]) && JobVice.exists?(params[:job_vice_id])
      @job_vice = JobVice.find(params[:job_vice_id])
      @job_result_template = JobResultTemplate.find(params[:job_result_template_id])
      
      if JobViceResult.where(["user_id = ? AND evaluation_id = ? AND job_vice_id = ? AND job_result_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_vice.id, @job_result_template.id, :enabled]).size == 0
        @job_vice_result = JobViceResult.create(
          user_id: current_user.id, 
          evaluation_id: @current_evaluation.id, 
          job_vice_id: @job_vice.id,
          job_result_template_id: @job_result_template.id, 
          unit: @job_result_template.unit, 
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_result_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_vice = JobVice.find(params[:job_vice_id])
      
      @job_vice_result = JobViceResult.new(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        job_vice_id: @job_vice.id,
        name: params[:name], 
        workflow_state: :enabled
      )
      unless @job_vice_result.save
        @error_message = "#{@job_vice_result.errors.messages.collect {|kk, vv| "#{kk} #{vv}"}}"
      end
    else
      @error_message = "ไม่พบงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_vice_result
    
    if JobViceResult.exists?(params[:job_vice_result_id])
      @job_vice_result = JobViceResult.find(params[:job_vice_result_id])
      params[:edit] = true
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_vice_result
    
    if JobViceResult.exists?(params[:job_vice_result_id])
      @job_vice_result = JobViceResult.find(params[:job_vice_result_id])
      @job_vice_result.name = params[:name] unless params[:name].blank?
      @job_vice_result.qty = params[:qty] unless params[:qty].blank?
      @job_vice_result.unit = params[:unit] unless params[:unit].blank?
      @job_vice_result.description = params[:description] unless params[:description].blank?
      @job_vice_result.save if current_user.id == @job_vice_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_vice_result
    
    if JobViceResult.exists?(params[:job_vice_result_id])
      @job_vice_result = JobViceResult.find(params[:job_vice_result_id])
      @job_vice_result.terminate! if current_user.id == @job_vice_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def upload_job_vice_result
    
    if JobViceResult.exists?(params[:job_vice_result_id])
      @job_vice_result = JobViceResult.find(params[:job_vice_result_id])
      @job_vice_result_file = JobViceResultFile.new(
        job_vice_result_id: @job_vice_result.id, 
        file: params["new_job_vice_result_file_#{@job_vice_result.id}"][:file], 
        description: params["new_job_vice_result_file_#{@job_vice_result.id}"][:description], 
        workflow_state: :enabled
      )
      unless @job_vice_result_file.save
        @error_message = @job_vice_result_file.errors.messages.collect {|k, v| "#{k} #{v.join(', ')}"}.join(', ')
      end
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
      format.html {redirect_to action: "index"}
    end
  end
  
  def remove_job_vice_result_file
    
    if JobViceResultFile.exists?(params[:job_vice_result_file_id])
      @job_vice_result_file = JobViceResultFile.find(params[:job_vice_result_file_id])
      @job_vice_result_file.terminate! if current_user.id == @job_vice_result_file.job_vice_result.user_id
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end  
  
  def edit_job_vice_result_file
    
    if JobViceResultFile.exists?(params[:job_vice_result_file_id])
      @job_vice_result_file = JobViceResultFile.find(params[:job_vice_result_file_id])
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_vice_result_file
    
    if JobViceResultFile.exists?(params[:job_vice_result_file_id])
      @job_vice_result_file = JobViceResultFile.find(params[:job_vice_result_file_id])
      @job_vice_result_file.description = params["job_vice_result_file_#{params[:job_vice_result_file_id]}"][:description]
      @job_vice_result_file.file = params["job_vice_result_file_#{params[:job_vice_result_file_id]}"][:file] unless params["job_vice_result_file_#{params[:job_vice_result_file_id]}"][:file].blank?
      @job_vice_result_file.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_vice_self_point
    
    if JobVice.exists?(params[:job_vice_id])
      @job_vice = JobVice.find(params[:job_vice_id])
      @job_vice.self_point = params[:self_point]
      @job_vice.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  # development ##############################################################################################################################################################################################
  def add_job_development_result
    
    if JobResultTemplate.exists?(params[:job_result_template_id]) && JobDevelopment.exists?(params[:job_development_id])
      @job_development = JobDevelopment.find(params[:job_development_id])
      @job_result_template = JobResultTemplate.find(params[:job_result_template_id])
      
      if JobDevelopmentResult.where(["user_id = ? AND evaluation_id = ? AND job_development_id = ? AND job_result_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_development.id, @job_result_template.id, :enabled]).size == 0
        @job_development_result = JobDevelopmentResult.create(
          user_id: current_user.id, 
          evaluation_id: @current_evaluation.id, 
          job_development_id: @job_development.id,
          job_result_template_id: @job_result_template.id, 
          unit: @job_result_template.unit, 
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_result_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_development = JobDevelopment.find(params[:job_development_id])
      
      @job_development_result = JobDevelopmentResult.new(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        job_development_id: @job_development.id,
        name: params[:name], 
        workflow_state: :enabled
      )
      unless @job_development_result.save
        @error_message = "#{@job_development_result.errors.messages.collect {|kk, vv| "#{kk} #{vv}"}}"
      end
    else
      @error_message = "ไม่พบงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_development_result
    
    if JobDevelopmentResult.exists?(params[:job_development_result_id])
      @job_development_result = JobDevelopmentResult.find(params[:job_development_result_id])
      params[:edit] = true
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_development_result
    
    if JobDevelopmentResult.exists?(params[:job_development_result_id])
      @job_development_result = JobDevelopmentResult.find(params[:job_development_result_id])
      @job_development_result.name = params[:name] unless params[:name].blank?
      @job_development_result.qty = params[:qty] unless params[:qty].blank?
      @job_development_result.unit = params[:unit] unless params[:unit].blank?
      @job_development_result.description = params[:description] unless params[:description].blank?
      @job_development_result.save if current_user.id == @job_development_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_development_result
    
    if JobDevelopmentResult.exists?(params[:job_development_result_id])
      @job_development_result = JobDevelopmentResult.find(params[:job_development_result_id])
      @job_development_result.terminate! if current_user.id == @job_development_result.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def upload_job_development_result
    
    if JobDevelopmentResult.exists?(params[:job_development_result_id])
      @job_development_result = JobDevelopmentResult.find(params[:job_development_result_id])
      @job_development_result_file = JobDevelopmentResultFile.new(
        job_development_result_id: @job_development_result.id, 
        file: params["new_job_development_result_file_#{@job_development_result.id}"][:file], 
        description: params["new_job_development_result_file_#{@job_development_result.id}"][:description], 
        workflow_state: :enabled
      )
      unless @job_development_result_file.save
        @error_message = @job_development_result_file.errors.messages.collect {|k, v| "#{k} #{v.join(', ')}"}.join(', ')
      end
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
      format.html {redirect_to action: "index"}
    end
  end
  
  def remove_job_development_result_file
    
    if JobDevelopmentResultFile.exists?(params[:job_development_result_file_id])
      @job_development_result_file = JobDevelopmentResultFile.find(params[:job_development_result_file_id])
      @job_development_result_file.terminate! if current_user.id == @job_development_result_file.job_development_result.user_id
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_development_result_file
    
    if JobDevelopmentResultFile.exists?(params[:job_development_result_file_id])
      @job_development_result_file = JobDevelopmentResultFile.find(params[:job_development_result_file_id])
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_development_result_file
    
    if JobDevelopmentResultFile.exists?(params[:job_development_result_file_id])
      @job_development_result_file = JobDevelopmentResultFile.find(params[:job_development_result_file_id])
      @job_development_result_file.description = params["job_development_result_file_#{params[:job_development_result_file_id]}"][:description]
      @job_development_result_file.file = params["job_development_result_file_#{params[:job_development_result_file_id]}"][:file] unless params["job_development_result_file_#{params[:job_development_result_file_id]}"][:file].blank?
      @job_development_result_file.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_development_self_point
    
    if JobDevelopment.exists?(params[:job_development_id])
      @job_development = JobDevelopment.find(params[:job_development_id])
      @job_development.self_point = params[:self_point]
      @job_development.save
    else
      @error_message = "ไม่พบไฟล์ที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
end
