# encoding:utf-8
class DirectorConfirmsController < OrbController
  
  # authorize_resource :class => false
  # skip_authorization_check
  authorize_resource :class => false
  
  before_filter :check_current_evaluation
  before_filter :check_role
  before_filter :get_user, except: [:index]
  
  def index
    
  end
  
  def pd
    
  end
  
  def add_job_plan
    
    if JobTemplate.exists?(params[:job_template_id])
      @job_template = JobTemplate.find(params[:job_template_id])
      
      if JobPlan.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", @user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_plan = JobPlan.create(
          user_id: @user.id, 
          evaluation_id: @current_evaluation.id, 
          job_template_id: @job_template.id, 
          expect_qty: params[:expect_qty],  
          unit: @job_template.unit,
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_plan = JobPlan.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
      if @job_plan.save
        
      else
        @error_message = "มีข้อผิดพลาด"
      end
    else
      @job_plan = JobPlan.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        workflow_state: :enabled
      )
      @job_plan.save
      @error_message = "กรอกข้อมูลไม่ครบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_plan
    
    if JobPlan.exists?(params[:job_plan_id])
      @job_plan = JobPlan.find(params[:job_plan_id])
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_plan
    
    if JobPlan.exists?(params[:job_plan_id])
      
      @job_plan_log = JobPlanLog.new
      
      @job_plan = JobPlan.find(params[:job_plan_id])
      
      @job_plan_log.job_plan_id = @job_plan.id
      @job_plan_log.name = @job_plan.name
      @job_plan_log.expect = @job_plan.expect
      @job_plan_log.weight = @job_plan.weight
      
      @job_plan.name = params[:name]
      @job_plan.expect = params[:expect]
      @job_plan.weight = params[:weight]
      if @user.id == @job_plan.user_id && @job_plan.save
          @job_plan_log.save unless @job_plan_log.name == @job_plan.name
      else
        @error_message = "มีข้อผิดพลาด"
      end 
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_plan
    
    if JobPlan.exists?(params[:job_plan_id])
      @job_plan = JobPlan.find(params[:job_plan_id])
      @job_plan.terminate! if @user.id == @job_plan.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def chose_job_template_group_job_routine
    
    if JobTemplateGroup.exists?(params[:job_template_group_id])
      @job_template_group = JobTemplateGroup.find(params[:job_template_group_id])
    else
      @error_message = "ไม่พบหมวดงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def add_job_routine
    
    if JobTemplate.exists?(params[:job_template_id])
      @job_template = JobTemplate.find(params[:job_template_id])
      
      if JobRoutine.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", @user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_routine = JobRoutine.create(
          user_id: @user.id, 
          evaluation_id: @current_evaluation.id, 
          job_template_id: @job_template.id, 
          expect_qty: params[:expect_qty],  
          unit: @job_template.unit,
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_routine = JobRoutine.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
      if @job_routine.save
        
      else
        @error_message = "มีข้อผิดพลาด"
      end
    else
      @job_routine = JobRoutine.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        workflow_state: :enabled
      )
      @job_routine.save
      @error_message = "กรอกข้อมูลไม่ครบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_routine
    
    if JobRoutine.exists?(params[:job_routine_id])
      @job_routine = JobRoutine.find(params[:job_routine_id])
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_routine
    
    if JobRoutine.exists?(params[:job_routine_id])
      
      @job_routine_log = JobRoutineLog.new
      
      @job_routine = JobRoutine.find(params[:job_routine_id])
      
      @job_routine_log.job_routine_id = @job_routine.id
      @job_routine_log.name = @job_routine.name
      @job_routine_log.expect = @job_routine.expect
      @job_routine_log.weight = @job_routine.weight
      
      @job_routine.name = params[:name]
      @job_routine.expect = params[:expect]
      @job_routine.weight = params[:weight]
      if @user.id == @job_routine.user_id && @job_routine.save
          @job_routine_log.save unless @job_routine_log.name == @job_routine.name
      else
        @error_message = "มีข้อผิดพลาด"
      end 
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_routine
    
    if JobRoutine.exists?(params[:job_routine_id])
      @job_routine = JobRoutine.find(params[:job_routine_id])
      @job_routine.terminate! if @user.id == @job_routine.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def chose_job_template_group_job_vice
    
    if JobTemplateGroup.exists?(params[:job_template_group_id])
      @job_template_group = JobTemplateGroup.find(params[:job_template_group_id])
    else
      @error_message = "ไม่พบหมวดงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def add_job_vice
    
    if JobTemplate.exists?(params[:job_template_id])
      @job_template = JobTemplate.find(params[:job_template_id])
      
      if JobVice.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", @user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_vice = JobVice.create(
          user_id: @user.id, 
          evaluation_id: @current_evaluation.id, 
          job_template_id: @job_template.id, 
          expect_qty: params[:expect_qty],  
          unit: @job_template.unit,
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_vice = JobVice.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
      if @job_vice.save
        
      else
        @error_message = "มีข้อผิดพลาด"
      end
    else
      @job_vice = JobVice.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        workflow_state: :enabled
      )
      @job_vice.save
      @error_message = "กรอกข้อมูลไม่ครบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_vice
    
    if JobVice.exists?(params[:job_vice_id])
      @job_vice = JobVice.find(params[:job_vice_id])
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_vice
    
    if JobVice.exists?(params[:job_vice_id])
      
      @job_vice_log = JobViceLog.new
      
      @job_vice = JobVice.find(params[:job_vice_id])
      
      @job_vice_log.job_vice_id = @job_vice.id
      @job_vice_log.name = @job_vice.name
      @job_vice_log.expect = @job_vice.expect
      @job_vice_log.weight = @job_vice.weight
      
      @job_vice.name = params[:name]
      @job_vice.expect = params[:expect]
      @job_vice.weight = params[:weight]
      if @user.id == @job_vice.user_id && @job_vice.save
          @job_vice_log.save unless @job_vice_log.name == @job_vice.name
      else
        @error_message = "มีข้อผิดพลาด"
      end 
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_vice
    
    if JobVice.exists?(params[:job_vice_id])
      @job_vice = JobVice.find(params[:job_vice_id])
      @job_vice.terminate! if @user.id == @job_vice.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def chose_job_template_group_job_development
    
    if JobTemplateGroup.exists?(params[:job_template_group_id])
      @job_template_group = JobTemplateGroup.find(params[:job_template_group_id])
    else
      @error_message = "ไม่พบหมวดงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def add_job_development
    
    if JobTemplate.exists?(params[:job_template_id])
      @job_template = JobTemplate.find(params[:job_template_id])
      
      if JobDevelopment.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", @user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_development = JobDevelopment.create(
          user_id: @user.id, 
          evaluation_id: @current_evaluation.id, 
          job_template_id: @job_template.id, 
          expect_qty: params[:expect_qty], 
          unit: @job_template.unit, 
          workflow_state: :enabled
        )
      else
        @error_message = "#{@job_template.to_s} มีในรายการแล้ว"
      end
    elsif !params[:name].blank?
      @job_development = JobDevelopment.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
      if @job_development.save
        
      else
        @error_message = "มีข้อผิดพลาด"
      end
    else
      @job_development = JobDevelopment.new(
        user_id: @user.id, 
        evaluation_id: @current_evaluation.id, 
        workflow_state: :enabled
      )
      @job_development.save
      @error_message = "กรอกข้อมูลไม่ครบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit_job_development
    
    if JobDevelopment.exists?(params[:job_development_id])
      @job_development = JobDevelopment.find(params[:job_development_id])
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def update_job_development
    
    if JobDevelopment.exists?(params[:job_development_id])
      
      @job_development_log = JobDevelopmentLog.new
      
      @job_development = JobDevelopment.find(params[:job_development_id])
      
      @job_development_log.job_development_id = @job_development.id
      @job_development_log.name = @job_development.name
      @job_development_log.expect = @job_development.expect
      @job_development_log.weight = @job_development.weight
      
      @job_development.name = params[:name]
      @job_development.expect = params[:expect]
      @job_development.weight = params[:weight]
      if @user.id == @job_development.user_id && @job_development.save
          @job_development_log.save unless @job_development_log.name == @job_development.name
      else
        @error_message = "มีข้อผิดพลาด"
      end 
    else
      @error_message = "ไม่พบงานที่ต้องการแก้ไข"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def remove_job_development
    
    if JobDevelopment.exists?(params[:job_development_id])
      @job_development = JobDevelopment.find(params[:job_development_id])
      @job_development.terminate! if @user.id == @job_development.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def confirm
    
    evaluation_user_final = @user.evaluation_user_final(@current_evaluation)
    evaluation_user_final = EvaluationUserFinal.new if evaluation_user_final.nil?
    
    evaluation_user_final.evaluation_id = @current_evaluation.id
    evaluation_user_final.user_id = @user.id
    evaluation_user_final.director_id = current_user.id
    evaluation_user_final.director_at = Time.current
    evaluation_user_final.workflow_state = :enabled
    evaluation_user_final.save  
    
    NotificationMailer.delay.director_confirm(evaluation_user_final) 
    
    respond_to do |format|
      format.html { redirect_to director_confirms_url(@current_evaluation) + "#user-#{@user.id}" }
    end
  end
  
  private
  def check_current_evaluation
    
    if !params[:evaluation_id].blank? && Evaluation.exists?(params[:evaluation_id])
      @current_evaluation = Evaluation.find(params[:evaluation_id])
      session[:current_evaluation_id] = @current_evaluation.id
    end
    
    if @current_evaluation.nil?
      redirect_to root_url
      return false
    end
  end
  
  def check_role
    
    unless current_user.is_director?(@current_evaluation)
      redirect_to root_url
      return false
    end
  end
  
  def get_user
    
    @user = User.find(params[:user_id]) if params[:user_id] && User.exists?(params[:user_id])
    
  end
  
end
