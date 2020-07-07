class Projects::ActivityFilesController < ProjectsController
  load_and_authorize_resource :class => "ActivityFile"

  before_action :set_activity_file, only: [:show, :edit, :update, :destroy]

  # GET /projects/activity_files
  # GET /projects/activity_files.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = ActivityFile.active_states.join(",")
    end if ActivityFile.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if ActivityFile.respond_to?(:workflow_spec)
    @q = ActivityFile.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @activity_files = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/activity_files/1
  # GET /projects/activity_files/1.json
  def show
  end

  # GET /projects/activity_files/new
  def new
    @activity_file = ActivityFile.new
    render layout: !request.xhr?
  end

  # GET /projects/activity_files/1/edit
  def edit
  end

  # POST /projects/activity_files
  # POST /projects/activity_files.json
  def create
    @activity_file = ActivityFile.new(activity_file_params)
    authorize! params[:button].to_sym, @activity_file if @activity_file.respond_to?(:current_state)

    respond_to do |format|
      if @activity_file.save && (!@activity_file.respond_to?(:current_state) || @activity_file.process_event!(params[:button]))
        format.html { redirect_to projects_activity_files_url(q: params[:q], page: params[:page]), notice: 'Activity file was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_activity_file_url(@activity_file) }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/activity_files/1
  # PATCH/PUT /projects/activity_files/1.json
  def update
    authorize! params[:button].to_sym, @activity_file if @activity_file.respond_to?(:current_state)

    respond_to do |format|
      if (params[:activity_file].nil? || @activity_file.update(activity_file_params)) && (!@activity_file.respond_to?(:current_state) || @activity_file.process_event!(params[:button]))
        format.html { redirect_to projects_activity_files_url(q: params[:q], page: params[:page]), notice: 'Activity file was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @activity_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/activity_files/1
  # DELETE /projects/activity_files/1.json
  def destroy
    if params[:id]
      if (!@activity_file.respond_to?(:current_state) || !@activity_file.current_state.meta[:no_destroy]) &&
        (ActivityFile.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @activity_file.send(r.name).count}.sum == 0)
        @activity_file.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, ActivityFile
      ActivityFile.where(id: params[:ids]).each do |activity_file|
        if can?(:destroy, activity_file) &&
          (!activity_file.respond_to?(:current_state) || !activity_file.current_state.meta[:no_destroy]) &&
          (ActivityFile.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| activity_file.send(r.name).count}.sum == 0)
          activity_file.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_activity_files_url(q: params[:q], page: params[:page]), notice: 'Activity file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_file
      @activity_file = ActivityFile.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_file_params
      params.require(:activity_file).permit(:workflow_state, :workflow_state_updater_id, :activity_id, :file)
    end

    def default_layout
      "orb"
    end
    
end
