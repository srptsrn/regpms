class Projects::ProblemSuggesstionsController < OrbController
  load_and_authorize_resource :class => "ProblemSuggesstion"

  before_action :set_problem_suggesstion, only: [:show, :edit, :update, :destroy]

  # GET /projects/problem_suggesstions
  # GET /projects/problem_suggesstions.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = ProblemSuggesstion.active_states.join(",")
    end if ProblemSuggesstion.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if ProblemSuggesstion.respond_to?(:workflow_spec)
    @q = ProblemSuggesstion.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @problem_suggesstions = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/problem_suggesstions/1
  # GET /projects/problem_suggesstions/1.json
  def show
  end

  # GET /projects/problem_suggesstions/new
  def new
    @problem_suggesstion = ProblemSuggesstion.new
    render layout: !request.xhr?
  end

  # GET /projects/problem_suggesstions/1/edit
  def edit
  end

  # POST /projects/problem_suggesstions
  # POST /projects/problem_suggesstions.json
  def create
    @problem_suggesstion = ProblemSuggesstion.new(problem_suggesstion_params)
    authorize! params[:button].to_sym, @problem_suggesstion if @problem_suggesstion.respond_to?(:current_state)

    respond_to do |format|
      if @problem_suggesstion.save && (!@problem_suggesstion.respond_to?(:current_state) || @problem_suggesstion.process_event!(params[:button]))
        format.html { redirect_to projects_problem_suggesstions_url(q: params[:q], page: params[:page]), notice: 'Problem suggesstion was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_problem_suggesstion_url(@problem_suggesstion) }
      else
        format.html { render action: 'new' }
        format.json { render json: @problem_suggesstion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/problem_suggesstions/1
  # PATCH/PUT /projects/problem_suggesstions/1.json
  def update
    authorize! params[:button].to_sym, @problem_suggesstion if @problem_suggesstion.respond_to?(:current_state)

    respond_to do |format|
      if (params[:problem_suggesstion].nil? || @problem_suggesstion.update(problem_suggesstion_params)) && (!@problem_suggesstion.respond_to?(:current_state) || @problem_suggesstion.process_event!(params[:button]))
        format.html { redirect_to projects_problem_suggesstions_url(q: params[:q], page: params[:page]), notice: 'Problem suggesstion was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @problem_suggesstion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/problem_suggesstions/1
  # DELETE /projects/problem_suggesstions/1.json
  def destroy
    if params[:id]
      if (!@problem_suggesstion.respond_to?(:current_state) || !@problem_suggesstion.current_state.meta[:no_destroy]) &&
        (ProblemSuggesstion.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @problem_suggesstion.send(r.name).count}.sum == 0)
        @problem_suggesstion.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, ProblemSuggesstion
      ProblemSuggesstion.where(id: params[:ids]).each do |problem_suggesstion|
        if can?(:destroy, problem_suggesstion) &&
          (!problem_suggesstion.respond_to?(:current_state) || !problem_suggesstion.current_state.meta[:no_destroy]) &&
          (ProblemSuggesstion.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| problem_suggesstion.send(r.name).count}.sum == 0)
          problem_suggesstion.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_problem_suggesstions_url(q: params[:q], page: params[:page]), notice: 'Problem suggesstion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_suggesstion
      @problem_suggesstion = ProblemSuggesstion.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_suggesstion_params
      params.require(:problem_suggesstion).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description)
    end

    def default_layout
      "orb"
    end
    
end
