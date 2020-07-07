class Projects::BudgetsController < OrbController
  load_and_authorize_resource :class => "Budget"

  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  # GET /projects/budgets
  # GET /projects/budgets.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Budget.active_states.join(",")
    end if Budget.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Budget.respond_to?(:workflow_spec)
    @q = Budget.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @budgets = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/budgets/1
  # GET /projects/budgets/1.json
  def show
  end

  # GET /projects/budgets/new
  def new
    @budget = Budget.new
    render layout: !request.xhr?
  end

  # GET /projects/budgets/1/edit
  def edit
  end

  # POST /projects/budgets
  # POST /projects/budgets.json
  def create
    @budget = Budget.new(budget_params)
    authorize! params[:button].to_sym, @budget if @budget.respond_to?(:current_state)

    respond_to do |format|
      if @budget.save && (!@budget.respond_to?(:current_state) || @budget.process_event!(params[:button]))
        format.html { redirect_to projects_budgets_url(q: params[:q], page: params[:page]), notice: 'Budget was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_budget_url(@budget) }
      else
        format.html { render action: 'new' }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/budgets/1
  # PATCH/PUT /projects/budgets/1.json
  def update
    authorize! params[:button].to_sym, @budget if @budget.respond_to?(:current_state)

    respond_to do |format|
      if (params[:budget].nil? || @budget.update(budget_params)) && (!@budget.respond_to?(:current_state) || @budget.process_event!(params[:button]))
        format.html { redirect_to projects_budgets_url(q: params[:q], page: params[:page]), notice: 'Budget was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/budgets/1
  # DELETE /projects/budgets/1.json
  def destroy
    if params[:id]
      if (!@budget.respond_to?(:current_state) || !@budget.current_state.meta[:no_destroy]) &&
        (Budget.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @budget.send(r.name).count}.sum == 0)
        @budget.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Budget
      Budget.where(id: params[:ids]).each do |budget|
        if can?(:destroy, budget) &&
          (!budget.respond_to?(:current_state) || !budget.current_state.meta[:no_destroy]) &&
          (Budget.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| budget.send(r.name).count}.sum == 0)
          budget.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_budgets_url(q: params[:q], page: params[:page]), notice: 'Budget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :budget_type_id, :description, :amount)
    end

    def default_layout
      "orb"
    end
    
end
