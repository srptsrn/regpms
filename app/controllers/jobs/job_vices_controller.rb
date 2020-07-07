class Jobs::JobVicesController < JobsController
  load_and_authorize_resource :class => "JobVice"

  before_action :set_job_vice, only: [:show, :edit, :update, :destroy]

  # GET /jobs/job_vices
  # GET /jobs/job_vices.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobVice.active_states.join(",")
    end if JobVice.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobVice.respond_to?(:workflow_spec)
    @q = JobVice.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @job_vices = request.format.html? ? @q.result.includes(:user).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:user)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /jobs/job_vices/1
  # GET /jobs/job_vices/1.json
  def show
  end

  # GET /jobs/job_vices/new
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
    
    @job_vice = JobVice.new(user_id: user_id, evaluation_id: @current_evaluation.id)
    render layout: !request.xhr?
  end

  # GET /jobs/job_vices/1/edit
  def edit
    if params[:pf] && @job_vice.is_pf_range
      
    elsif @job_vice.is_pd_range
      
    else
      redirect_to action: 'show', pf: params[:pf]
      return false
    end
  end

  # POST /jobs/job_vices
  # POST /jobs/job_vices.json
  def create
    @job_vice = JobVice.new(job_vice_params)
    authorize! params[:button].to_sym, @job_vice if @job_vice.respond_to?(:current_state)

    respond_to do |format|
      if @job_vice.save && (!@job_vice.respond_to?(:current_state) || @job_vice.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_vices_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully created.' }
        if @job_vice.user_id == current_user.id
          format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully created.' }
        else
          format.html { redirect_to x_user_pds_url(@job_vice.user_id, q: params[:q], page: params[:page]), notice: 'Job vice was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: jobs_job_vice_url(@job_vice) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_vice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/job_vices/1
  # PATCH/PUT /jobs/job_vices/1.json
  def update
    authorize! params[:button].to_sym, @job_vice if @job_vice.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_vice].nil? || @job_vice.update(job_vice_params)) && (!@job_vice.respond_to?(:current_state) || @job_vice.process_event!(params[:button]))
        # format.html { redirect_to jobs_job_vices_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully updated.' }
        if params[:pf]
          if @job_vice.user_id == current_user.id
            format.html { redirect_to pfs_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully updated.' }
          else
            format.html { redirect_to x_user_pfs_url(@job_vice.user_id, q: params[:q], page: params[:page]), notice: 'Job vice was successfully updated.' }
          end
        else
          if @job_vice.user_id == current_user.id
            format.html { redirect_to pds_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully updated.' }
          else
            format.html { redirect_to x_user_pds_url(@job_vice.user_id, q: params[:q], page: params[:page]), notice: 'Job vice was successfully updated.' }
          end
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_vice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/job_vices/1
  # DELETE /jobs/job_vices/1.json
  def destroy
    if params[:id]
      if (!@job_vice.respond_to?(:current_state) || !@job_vice.current_state.meta[:no_destroy]) &&
        (JobVice.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_vice.send(r.name).count}.sum == 0)
        @job_vice.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobVice
      JobVice.where(id: params[:ids]).each do |job_vice|
        if can?(:destroy, job_vice) &&
          (!job_vice.respond_to?(:current_state) || !job_vice.current_state.meta[:no_destroy]) &&
          (JobVice.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_vice.send(r.name).count}.sum == 0)
          job_vice.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to jobs_job_vices_url(q: params[:q], page: params[:page]), notice: 'Job vice was successfully destroyed.' }
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
    def set_job_vice
      @job_vice = JobVice.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_vice_params
      params.require(:job_vice).permit(
        :workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :job_template_id, :name, :duration, :expect_qty, :qty, :unit, :description, :approver_id, 
        job_vice_files_attributes: [:id, :job_vice_id, :file, :description, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
