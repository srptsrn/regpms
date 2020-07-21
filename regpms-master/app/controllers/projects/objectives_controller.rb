class Projects::ObjectivesController < ProjectsController
  load_and_authorize_resource :class => "Objective"

  before_action :set_objective, only: [:show, :edit, :update, :destroy]

  # GET /projects/objectives
  # GET /projects/objectives.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Objective.active_states.join(",")
    end if Objective.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Objective.respond_to?(:workflow_spec)
    @q = Objective.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @objectives = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/objectives/1
  # GET /projects/objectives/1.json
  def show
  end

  # GET /projects/objectives/new
  def new
    @objective = Objective.new
    render layout: !request.xhr?
  end

  # GET /projects/objectives/1/edit
  def edit
  end

  # POST /projects/objectives
  # POST /projects/objectives.json
  def create
    @objective = Objective.new(objective_params)
    authorize! params[:button].to_sym, @objective if @objective.respond_to?(:current_state)

    respond_to do |format|
      if @objective.save && (!@objective.respond_to?(:current_state) || @objective.process_event!(params[:button]))
        format.html { redirect_to projects_objectives_url(q: params[:q], page: params[:page]), notice: 'Objective was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_objective_url(@objective) }
      else
        format.html { render action: 'new' }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/objectives/1
  # PATCH/PUT /projects/objectives/1.json
  def update
    authorize! params[:button].to_sym, @objective if @objective.respond_to?(:current_state)

    respond_to do |format|
      if (params[:objective].nil? || @objective.update(objective_params)) && (!@objective.respond_to?(:current_state) || @objective.process_event!(params[:button]))
        format.html { redirect_to projects_objectives_url(q: params[:q], page: params[:page]), notice: 'Objective was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/objectives/1
  # DELETE /projects/objectives/1.json
  def destroy
    if params[:id]
      if (!@objective.respond_to?(:current_state) || !@objective.current_state.meta[:no_destroy]) &&
        (Objective.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @objective.send(r.name).count}.sum == 0)
        @objective.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Objective
      Objective.where(id: params[:ids]).each do |objective|
        if can?(:destroy, objective) &&
          (!objective.respond_to?(:current_state) || !objective.current_state.meta[:no_destroy]) &&
          (Objective.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| objective.send(r.name).count}.sum == 0)
          objective.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_objectives_url(q: params[:q], page: params[:page]), notice: 'Objective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objective
      @objective = Objective.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def objective_params
      params.require(:objective).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description)
    end

    def default_layout
      "orb"
    end
    
end
