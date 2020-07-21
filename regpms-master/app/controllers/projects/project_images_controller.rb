class Projects::ProjectImagesController < OrbController
  load_and_authorize_resource :class => "ProjectImage"

  before_action :set_project_image, only: [:show, :edit, :update, :destroy]

  # GET /projects/project_images
  # GET /projects/project_images.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = ProjectImage.active_states.join(",")
    end if ProjectImage.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if ProjectImage.respond_to?(:workflow_spec)
    @q = ProjectImage.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @project_images = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/project_images/1
  # GET /projects/project_images/1.json
  def show
  end

  # GET /projects/project_images/new
  def new
    @project_image = ProjectImage.new
    render layout: !request.xhr?
  end

  # GET /projects/project_images/1/edit
  def edit
  end

  # POST /projects/project_images
  # POST /projects/project_images.json
  def create
    @project_image = ProjectImage.new(project_image_params)
    authorize! params[:button].to_sym, @project_image if @project_image.respond_to?(:current_state)

    respond_to do |format|
      if @project_image.save && (!@project_image.respond_to?(:current_state) || @project_image.process_event!(params[:button]))
        format.html { redirect_to projects_project_images_url(q: params[:q], page: params[:page]), notice: 'Project image was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_project_image_url(@project_image) }
      else
        format.html { render action: 'new' }
        format.json { render json: @project_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/project_images/1
  # PATCH/PUT /projects/project_images/1.json
  def update
    authorize! params[:button].to_sym, @project_image if @project_image.respond_to?(:current_state)

    respond_to do |format|
      if (params[:project_image].nil? || @project_image.update(project_image_params)) && (!@project_image.respond_to?(:current_state) || @project_image.process_event!(params[:button]))
        format.html { redirect_to projects_project_images_url(q: params[:q], page: params[:page]), notice: 'Project image was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @project_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/project_images/1
  # DELETE /projects/project_images/1.json
  def destroy
    if params[:id]
      if (!@project_image.respond_to?(:current_state) || !@project_image.current_state.meta[:no_destroy]) &&
        (ProjectImage.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @project_image.send(r.name).count}.sum == 0)
        @project_image.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, ProjectImage
      ProjectImage.where(id: params[:ids]).each do |project_image|
        if can?(:destroy, project_image) &&
          (!project_image.respond_to?(:current_state) || !project_image.current_state.meta[:no_destroy]) &&
          (ProjectImage.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| project_image.send(r.name).count}.sum == 0)
          project_image.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_project_images_url(q: params[:q], page: params[:page]), notice: 'Project image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_image
      @project_image = ProjectImage.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_image_params
      params.require(:project_image).permit(:workflow_state, :workflow_state_updater_id, :project_id, :image)
    end

    def default_layout
      "orb"
    end
    
end
