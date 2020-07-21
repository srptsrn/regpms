class Jobs::JobDevelopmentsController < JobsController
  load_and_authorize_resource :class => "JobDevelopment"

  before_action :set_job_development, only: [:show, :edit, :update, :destroy]

  # GET /jobs/job_developments
  # GET /jobs/job_developments.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobDevelopment.active_states.join(",")
    end if JobDevelopment.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobDevelopment.respond_to?(:workflow_spec)
    @q = JobDevelopment.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @job_developments = request.format.html? ? @q.result.includes(:user).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:user)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /jobs/job_developments/1
  # GET /jobs/job_developments/1.json
  def show
  end

  # GET /jobs/job_developments/new
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
    
    @job_development = JobDevelopment.new(user_id: user_id, evaluation_id: @current_evaluation.id)
    render layout: !request.xhr?
  end

  # GET /jobs/job_developments/1/edit
  def edit
    if params[:pf] && @job_development.is_pf_range
      
    elsif @job_development.is_pd_range
      
    else
      redirect_to action: 'show', pf: params[:pf]
      return false
    end
  end

  # POST /jobs/job_developments
  # POST /jobs/job_developments.json
  def create
    @job_development = JobDevelopment.new(job_development_params)
    authorize! params[:button].to_sym, @job_development if @job_development.respond_to?(:current_state)

    respond_to do |format|
      if @job_development.save && (!@job_development.respond_to?(:current_state) || @job_development.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_developments_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully created.' }
        if @job_development.user_id == current_user.id
          format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully created.' }
        else
          format.html { redirect_to x_user_pds_url(@job_development.user_id, q: params[:q], page: params[:page]), notice: 'Job development was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: jobs_job_development_url(@job_development) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_development.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/job_developments/1
  # PATCH/PUT /jobs/job_developments/1.json
  def update
    authorize! params[:button].to_sym, @job_development if @job_development.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_development].nil? || @job_development.update(job_development_params)) && (!@job_development.respond_to?(:current_state) || @job_development.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_developments_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully updated.' }
        if params[:pf]
          if @job_development.user_id == current_user.id
            format.html { redirect_to pfs_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully updated.' }
          else
            format.html { redirect_to x_user_pfs_url(@job_development.user_id, q: params[:q], page: params[:page]), notice: 'Job development was successfully updated.' }
          end
        else
          if @job_development.user_id == current_user.id
            format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully updated.' }
          else
            format.html { redirect_to x_user_pds_url(@job_development.user_id, q: params[:q], page: params[:page]), notice: 'Job development was successfully updated.' }
          end
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_development.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/job_developments/1
  # DELETE /jobs/job_developments/1.json
  def destroy
    if params[:id]
      if (!@job_development.respond_to?(:current_state) || !@job_development.current_state.meta[:no_destroy]) &&
        (JobDevelopment.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_development.send(r.name).count}.sum == 0)
        @job_development.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobDevelopment
      JobDevelopment.where(id: params[:ids]).each do |job_development|
        if can?(:destroy, job_development) &&
          (!job_development.respond_to?(:current_state) || !job_development.current_state.meta[:no_destroy]) &&
          (JobDevelopment.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_development.send(r.name).count}.sum == 0)
          job_development.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to jobs_job_developments_url(q: params[:q], page: params[:page]), notice: 'Job development was successfully destroyed.' }
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
    def set_job_development
      @job_development = JobDevelopment.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_development_params
      params.require(:job_development).permit(
        :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id, 
        job_development_files_attributes: [:id, :job_development_id, :file, :description, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
