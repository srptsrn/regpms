class Jobs::JobDevelopmentResultFilesController < JobsController
  load_and_authorize_resource :class => "JobDevelopmentResultFile"

  before_action :set_job_development_result_file, only: [:show, :edit, :update, :destroy]

  # GET /jobs/job_development_result_files
  # GET /jobs/job_development_result_files.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = JobDevelopmentResultFile.active_states.join(",")
    end if JobDevelopmentResultFile.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if JobDevelopmentResultFile.respond_to?(:workflow_spec)
    @q = JobDevelopmentResultFile.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @job_development_result_files = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /jobs/job_development_result_files/1
  # GET /jobs/job_development_result_files/1.json
  def show
  end

  # GET /jobs/job_development_result_files/new
  def new
    @job_development_result_file = JobDevelopmentResultFile.new
    render layout: !request.xhr?
  end

  # GET /jobs/job_development_result_files/1/edit
  def edit
  end

  # POST /jobs/job_development_result_files
  # POST /jobs/job_development_result_files.json
  def create
    @job_development_result_file = JobDevelopmentResultFile.new(job_development_result_file_params)
    authorize! params[:button].to_sym, @job_development_result_file if @job_development_result_file.respond_to?(:current_state)

    respond_to do |format|
      if @job_development_result_file.save && (!@job_development_result_file.respond_to?(:current_state) || @job_development_result_file.process_event!(params[:button]))
        format.html { redirect_to jobs_job_development_result_files_url(q: params[:q], page: params[:page]), notice: 'Job development result file was successfully created.' }
        format.json { render action: 'show', status: :created, location: jobs_job_development_result_file_url(@job_development_result_file) }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_development_result_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/job_development_result_files/1
  # PATCH/PUT /jobs/job_development_result_files/1.json
  def update
    authorize! params[:button].to_sym, @job_development_result_file if @job_development_result_file.respond_to?(:current_state)

    respond_to do |format|
      if (params[:job_development_result_file].nil? || @job_development_result_file.update(job_development_result_file_params)) && (!@job_development_result_file.respond_to?(:current_state) || @job_development_result_file.process_event!(params[:button]))
        format.html { redirect_to jobs_job_development_result_files_url(q: params[:q], page: params[:page]), notice: 'Job development result file was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @job_development_result_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/job_development_result_files/1
  # DELETE /jobs/job_development_result_files/1.json
  def destroy
    if params[:id]
      if (!@job_development_result_file.respond_to?(:current_state) || !@job_development_result_file.current_state.meta[:no_destroy]) &&
        (JobDevelopmentResultFile.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @job_development_result_file.send(r.name).count}.sum == 0)
        @job_development_result_file.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, JobDevelopmentResultFile
      JobDevelopmentResultFile.where(id: params[:ids]).each do |job_development_result_file|
        if can?(:destroy, job_development_result_file) &&
          (!job_development_result_file.respond_to?(:current_state) || !job_development_result_file.current_state.meta[:no_destroy]) &&
          (JobDevelopmentResultFile.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| job_development_result_file.send(r.name).count}.sum == 0)
          job_development_result_file.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to jobs_job_development_result_files_url(q: params[:q], page: params[:page]), notice: 'Job development result file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_development_result_file
      @job_development_result_file = JobDevelopmentResultFile.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_development_result_file_params
      params.require(:job_development_result_file).permit(:workflow_state, :workflow_state_updater_id, :job_development_result_id, :file, :description)
    end

    def default_layout
      "orb"
    end
    
end
