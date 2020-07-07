class Settings::JobTemplatesController < SettingsController
  load_and_authorize_resource :class => "JobTemplate"

  before_action :set_job_template, only: [:show, :edit, :update, :destroy]

  # GET /settings/job_templates
  # GET /settings/job_templates.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobTemplate.active_states.join(",")
    end if JobTemplate.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobTemplate.respond_to?(:workflow_spec)
    @q = JobTemplate.limit(params[:limit]).search(params[:q])
    @q.sorts = 'name' if @q.sorts.empty?
    @job_templates = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/job_templates/1
  # GET /settings/job_templates/1.json
  def show
  end

  # GET /settings/job_templates/new
  def new
    @job_template = JobTemplate.new
    render layout: !request.xhr?
  end

  # GET /settings/job_templates/1/edit
  def edit
  end

  # POST /settings/job_templates
  # POST /settings/job_templates.json
  def create
    @job_template = JobTemplate.new(job_template_params)
    authorize! params[:button].to_sym, @job_template if @job_template.respond_to?(:current_state)

    respond_to do |format|
      if @job_template.save && (!@job_template.respond_to?(:current_state) || @job_template.process_event!(params[:button]))
        format.html { redirect_to settings_job_templates_url(q: params[:q], page: params[:page]), notice: 'Job template was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_job_template_url(@job_template) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/job_templates/1
  # PATCH/PUT /settings/job_templates/1.json
  def update
    authorize! params[:button].to_sym, @job_template if @job_template.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_template].nil? || @job_template.update(job_template_params)) && (!@job_template.respond_to?(:current_state) || @job_template.process_event!(params[:button]))
        format.html { redirect_to settings_job_templates_url(q: params[:q], page: params[:page]), notice: 'Job template was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/job_templates/1
  # DELETE /settings/job_templates/1.json
  def destroy
    if params[:id]
      if (!@job_template.respond_to?(:current_state) || !@job_template.current_state.meta[:no_destroy]) &&
        (JobTemplate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_template.send(r.name).count}.sum == 0)
        @job_template.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobTemplate
      JobTemplate.where(id: params[:ids]).each do |job_template|
        if can?(:destroy, job_template) &&
          (!job_template.respond_to?(:current_state) || !job_template.current_state.meta[:no_destroy]) &&
          (JobTemplate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_template.send(r.name).count}.sum == 0)
          job_template.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_job_templates_url(q: params[:q], page: params[:page]), notice: 'Job template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_template
      @job_template = JobTemplate.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_template_params
      params.require(:job_template).permit(
        :workflow_state, :workflow_state_updater_id, :job_template_group_id, :name, :unit, :duration, :is_job_plan, :is_job_routine, :is_job_vice, :is_job_development, 
        job_result_templates_attributes: [:id, :workflow_state, :workflow_state_updater_id, :job_template_id, :name, :unit, :duration, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
