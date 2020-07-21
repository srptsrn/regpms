class Jobs::JobRoutinesController < JobsController
  load_and_authorize_resource :class => "JobRoutine"

  before_action :set_job_routine, only: [:show, :edit, :update, :destroy]

  # GET /jobs/job_routines
  # GET /jobs/job_routines.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobRoutine.active_states.join(",")
    end if JobRoutine.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobRoutine.respond_to?(:workflow_spec)
    @q = JobRoutine.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @job_routines = request.format.html? ? @q.result.includes(:user).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:user)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /jobs/job_routines/1
  # GET /jobs/job_routines/1.json
  def show
  end

  # GET /jobs/job_routines/new
  def new
    
    user_id = current_user.id
    
    if User.exists?(params[:user_id])
      user = User.find(params[:user_id])
      if current_user.authorized_as?(:systemadmin) || current_user.is_section_leader?(user.sections.collect {|s| s.id})
        user_id = params[:user_id]
      else
        redirect_to x_pds_url
        return false
      end
    end
    
    @job_routine = JobRoutine.new(user_id: user_id, evaluation_id: @current_evaluation.id)
    render layout: !request.xhr?
  end

  # GET /jobs/job_routines/1/edit
  def edit
    if params[:pf] && @job_routine.is_pf_range
      
    elsif @job_routine.is_pd_range
      
    else
      redirect_to action: 'show', pf: params[:pf]
      return false
    end
  end

  # POST /jobs/job_routines
  # POST /jobs/job_routines.json
  def create
    @job_routine = JobRoutine.new(job_routine_params)
    authorize! params[:button].to_sym, @job_routine if @job_routine.respond_to?(:current_state)

    respond_to do |format|
      if @job_routine.save && (!@job_routine.respond_to?(:current_state) || @job_routine.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_routines_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully created.' }
        if @job_routine.user_id == current_user.id
          format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully created.' }
        else
          format.html { redirect_to x_user_pds_url(@job_routine.user_id, q: params[:q], page: params[:page]), notice: 'Job routine was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: jobs_job_routine_url(@job_routine) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/job_routines/1
  # PATCH/PUT /jobs/job_routines/1.json
  def update
    authorize! params[:button].to_sym, @job_routine if @job_routine.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_routine].nil? || @job_routine.update(job_routine_params)) && (!@job_routine.respond_to?(:current_state) || @job_routine.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_routines_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully updated.' }
        if params[:pf]
          if @job_routine.user_id == current_user.id
            format.html { redirect_to pfs_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully updated.' }
          else
            format.html { redirect_to x_user_pfs_url(@job_routine.user_id, q: params[:q], page: params[:page]), notice: 'Job routine was successfully updated.' }
          end
        else
          if @job_routine.user_id == current_user.id
            format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully updated.' }
          else
            format.html { redirect_to x_user_pds_url(@job_routine.user_id, q: params[:q], page: params[:page]), notice: 'Job routine was successfully updated.' }
          end
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/job_routines/1
  # DELETE /jobs/job_routines/1.json
  def destroy
    if params[:id]
      if (!@job_routine.respond_to?(:current_state) || !@job_routine.current_state.meta[:no_destroy]) &&
        (JobRoutine.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_routine.send(r.name).count}.sum == 0)
        @job_routine.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobRoutine
      JobRoutine.where(id: params[:ids]).each do |job_routine|
        if can?(:destroy, job_routine) &&
          (!job_routine.respond_to?(:current_state) || !job_routine.current_state.meta[:no_destroy]) &&
          (JobRoutine.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_routine.send(r.name).count}.sum == 0)
          job_routine.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to jobs_job_routines_url(q: params[:q], page: params[:page]), notice: 'Job routine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def chose_job_template
    @job_template = JobTemplate.find(params[:job_template_id]) if !params[:job_template_id].blank?

    respond_to do |format|
      format.js
    end
  end
  
  def chose_job_template_group
    @job_template_group = JobTemplateGroup.find(params[:job_template_group_id]) if !params[:job_template_group_id].blank?

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_routine
      @job_routine = JobRoutine.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_routine_params
      params.require(:job_routine).permit(
        :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id, 
        job_routine_files_attributes: [:id, :job_routine_id, :file, :description, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
