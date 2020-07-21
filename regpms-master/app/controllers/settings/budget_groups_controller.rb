class Settings::BudgetGroupsController < SettingsController
  load_and_authorize_resource :class => "BudgetGroup"

  before_action :set_budget_group, only: [:show, :edit, :update, :destroy]

  # GET /settings/budget_groups
  # GET /settings/budget_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = BudgetGroup.active_states.join(",")
    end if BudgetGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if BudgetGroup.respond_to?(:workflow_spec)
    @q = BudgetGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @budget_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/budget_groups/1
  # GET /settings/budget_groups/1.json
  def show
  end

  # GET /settings/budget_groups/new
  def new
    @budget_group = BudgetGroup.new
    render layout: !request.xhr?
  end

  # GET /settings/budget_groups/1/edit
  def edit
  end

  # POST /settings/budget_groups
  # POST /settings/budget_groups.json
  def create
    @budget_group = BudgetGroup.new(budget_group_params)
    authorize! params[:button].to_sym, @budget_group if @budget_group.respond_to?(:current_state)

    respond_to do |format|
      if @budget_group.save && (!@budget_group.respond_to?(:current_state) || @budget_group.process_event!(params[:button]))
        format.html { redirect_to settings_budget_groups_url(q: params[:q], page: params[:page]), notice: 'Budget group was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_budget_group_url(@budget_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @budget_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/budget_groups/1
  # PATCH/PUT /settings/budget_groups/1.json
  def update
    authorize! params[:button].to_sym, @budget_group if @budget_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:budget_group].nil? || @budget_group.update(budget_group_params)) && (!@budget_group.respond_to?(:current_state) || @budget_group.process_event!(params[:button]))
        format.html { redirect_to settings_budget_groups_url(q: params[:q], page: params[:page]), notice: 'Budget group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @budget_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/budget_groups/1
  # DELETE /settings/budget_groups/1.json
  def destroy
    if params[:id]
      if (!@budget_group.respond_to?(:current_state) || !@budget_group.current_state.meta[:no_destroy]) &&
        (BudgetGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @budget_group.send(r.name).count}.sum == 0)
        @budget_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, BudgetGroup
      BudgetGroup.where(id: params[:ids]).each do |budget_group|
        if can?(:destroy, budget_group) &&
          (!budget_group.respond_to?(:current_state) || !budget_group.current_state.meta[:no_destroy]) &&
          (BudgetGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| budget_group.send(r.name).count}.sum == 0)
          budget_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_budget_groups_url(q: params[:q], page: params[:page]), notice: 'Budget group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_group
      @budget_group = BudgetGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_group_params
      params.require(:budget_group).permit(:workflow_state, :workflow_state_updater_id, :name, :short_name)
    end

    def default_layout
      "orb"
    end
    
end
