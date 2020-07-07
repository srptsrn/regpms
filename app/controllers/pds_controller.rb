# encoding:utf-8
class PdsController < OrbController
  
  # authorize_resource :class => false
  # skip_authorization_check
  authorize_resource :class => false
  
  before_filter :has_current_evaluation?
  
  def index
    
    if !params[:evaluation_id].blank? && Evaluation.exists?(params[:evaluation_id])
      @current_evaluation = Evaluation.find(params[:evaluation_id])
      session[:current_evaluation_id] = @current_evaluation.id
    end
    
    if @current_evaluation.nil?
      redirect_to root_url
      return false
    end
    
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
  
  def confirm
    
    evaluation_user_final = current_user.evaluation_user_final(@current_evaluation)
    if evaluation_user_final
      evaluation_user_final.user_at = Time.current
      evaluation_user_final.save
    
      NotificationMailer.delay.user_confirm(evaluation_user_final) 
    end

    redirect_to action: "index"
    return false
  end
  
  def chose_job_template_group_job_plan
    
    if JobTemplateGroup.exists?(params[:job_template_group_id])
      @job_template_group = JobTemplateGroup.find(params[:job_template_group_id])
    else
      @error_message = "ไม่พบหมวดงานที่เลือก"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def add_job_plan
    
    if JobTemplate.exists?(params[:job_template_id])
      @job_template = JobTemplate.find(params[:job_template_id])
      
      if JobPlan.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_plan = JobPlan.create(
          user_id: current_user.id, 
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
      @job_plan = JobPlan.create(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
    else
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
      @job_plan = JobPlan.find(params[:job_plan_id])
      @job_plan.name = params[:name]
      @job_plan.expect = params[:expect]
      @job_plan.weight = params[:weight]
      if current_user.id == @job_plan.user_id && @job_plan.save
        
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
      @job_plan.terminate! if current_user.id == @job_plan.user_id
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
      
      if JobRoutine.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_routine = JobRoutine.create(
          user_id: current_user.id, 
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
        user_id: current_user.id, 
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
      @job_routine = JobRoutine.find(params[:job_routine_id])
      @job_routine.name = params[:name]
      @job_routine.expect = params[:expect]
      @job_routine.weight = params[:weight]
      if current_user.id == @job_routine.user_id && @job_routine.save
        
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
      @job_routine.terminate! if current_user.id == @job_routine.user_id
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
      
      if JobVice.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_vice = JobVice.create(
          user_id: current_user.id, 
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
      @job_vice = JobVice.create(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
    else
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
      @job_vice = JobVice.find(params[:job_vice_id])
      @job_vice.name = params[:name]
      @job_vice.expect = params[:expect]
      @job_vice.weight = params[:weight]
      if current_user.id == @job_vice.user_id && @job_vice.save
        
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
      @job_vice.terminate! if current_user.id == @job_vice.user_id
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
      
      if JobDevelopment.where(["user_id = ? AND evaluation_id = ? AND job_template_id = ? AND workflow_state = ?", current_user.id, @current_evaluation.id, @job_template.id, :enabled]).size == 0
        @job_development = JobDevelopment.create(
          user_id: current_user.id, 
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
      @job_development = JobDevelopment.create(
        user_id: current_user.id, 
        evaluation_id: @current_evaluation.id, 
        name: params[:name], 
        weight: params[:weight], 
        expect: params[:expect], 
        job_template_id: nil, 
        expect_qty: params[:expect_qty],  
        unit: nil,
        workflow_state: :enabled
      )
    else
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
      @job_development = JobDevelopment.find(params[:job_development_id])
      @job_development.name = params[:name]
      @job_development.expect = params[:expect]
      @job_development.weight = params[:weight]
      if current_user.id == @job_development.user_id && @job_development.save
        
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
      @job_development.terminate! if current_user.id == @job_development.user_id
    else
      @error_message = "ไม่พบงานที่ต้องการลบ"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  
  def clone
    
    if params[:evaluation] && params[:evaluation][:id] && Evaluation.exists?(params[:evaluation][:id])
      
      evaluation = Evaluation.find(params[:evaluation][:id])
      [JobPlan, JobRoutine, JobVice, JobDevelopment].each do |job_class|
        tmp_jobs = job_class.order(:created_at).where(["user_id = ? AND evaluation_id = ? AND workflow_state IN (?)", current_user.id, evaluation.id, [:enabled, :confirmed]])
        tmp_jobs.each do |tmp_job|
          if job_class.order(:created_at).where(["job_template_id = ? AND user_id = ? AND evaluation_id = ? AND workflow_state IN (?)", tmp_job.job_template_id, current_user.id, @current_evaluation.id, [:enabled, :confirmed]]).size == 0
            job = job_class.new
            job.workflow_state             = :enabled
            job.workflow_state_updater_id  = current_user.id
            job.user_id                    = current_user.id
            job.evaluation_id              = @current_evaluation.id
            job.job_template_id            = tmp_job.job_template_id
            job.name                       = tmp_job.name
            job.duration                   = tmp_job.duration 
            job.expect_qty                 = tmp_job.expect_qty
            job.expect                     = tmp_job.expect
            job.weight                     = tmp_job.weight
            job.qty                        = tmp_job.qty
            job.unit                       = tmp_job.unit
            job.description                = tmp_job.description
            if job.save
            else
              render text: job.errors.messages
              return false
            end
          end
        end
      end
      
    else
      flash[:error] = "โปรดระบุรอบประเมินที่ต้องการคัดลอก ก่อนคลิกปุ่มคัดลอก"
    end
    
    redirect_to pds_url
    return false
  end
  
end
