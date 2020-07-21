class Settings::JobTemplateGroupsController < SettingsController
  load_and_authorize_resource :class => "JobTemplateGroup"

  before_action :set_job_template_group, only: [:show, :edit, :update, :destroy]

  # GET /settings/job_template_groups
  # GET /settings/job_template_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobTemplateGroup.active_states.join(",")
    end if JobTemplateGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobTemplateGroup.respond_to?(:workflow_spec)
    @q = JobTemplateGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'sorting' if @q.sorts.empty?
    @job_template_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/job_template_groups/1
  # GET /settings/job_template_groups/1.json
  def show
  end

  # GET /settings/job_template_groups/new
  def new
    @job_template_group = JobTemplateGroup.new
    render layout: !request.xhr?
  end

  # GET /settings/job_template_groups/1/edit
  def edit
  end

  # POST /settings/job_template_groups
  # POST /settings/job_template_groups.json
  def create
    @job_template_group = JobTemplateGroup.new(job_template_group_params)
    authorize! params[:button].to_sym, @job_template_group if @job_template_group.respond_to?(:current_state)

    respond_to do |format|
      if @job_template_group.save && (!@job_template_group.respond_to?(:current_state) || @job_template_group.process_event!(params[:button]))
        format.html { redirect_to settings_job_template_groups_url(q: params[:q], page: params[:page]), notice: 'Job template group was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_job_template_group_url(@job_template_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_template_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/job_template_groups/1
  # PATCH/PUT /settings/job_template_groups/1.json
  def update
    authorize! params[:button].to_sym, @job_template_group if @job_template_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_template_group].nil? || @job_template_group.update(job_template_group_params)) && (!@job_template_group.respond_to?(:current_state) || @job_template_group.process_event!(params[:button]))
        format.html { redirect_to settings_job_template_groups_url(q: params[:q], page: params[:page]), notice: 'Job template group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_template_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/job_template_groups/1
  # DELETE /settings/job_template_groups/1.json
  def destroy
    if params[:id]
      if (!@job_template_group.respond_to?(:current_state) || !@job_template_group.current_state.meta[:no_destroy]) &&
        (JobTemplateGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_template_group.send(r.name).count}.sum == 0)
        @job_template_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobTemplateGroup
      JobTemplateGroup.where(id: params[:ids]).each do |job_template_group|
        if can?(:destroy, job_template_group) &&
          (!job_template_group.respond_to?(:current_state) || !job_template_group.current_state.meta[:no_destroy]) &&
          (JobTemplateGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_template_group.send(r.name).count}.sum == 0)
          job_template_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_job_template_groups_url(q: params[:q], page: params[:page]), notice: 'Job template group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_template_group
      @job_template_group = JobTemplateGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_template_group_params
      params.require(:job_template_group).permit(:workflow_state, :workflow_state_updater_id, :name, :sorting)
    end

    def default_layout
      "orb"
    end
    
end
