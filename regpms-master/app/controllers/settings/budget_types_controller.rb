class Settings::BudgetTypesController < SettingsController
  load_and_authorize_resource :class => "BudgetType"

  before_action :set_budget_type, only: [:show, :edit, :update, :destroy]

  # GET /settings/budget_types
  # GET /settings/budget_types.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = BudgetType.active_states.join(",")
    end if BudgetType.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if BudgetType.respond_to?(:workflow_spec)
    @q = BudgetType.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @budget_types = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/budget_types/1
  # GET /settings/budget_types/1.json
  def show
  end

  # GET /settings/budget_types/new
  def new
    @budget_type = BudgetType.new
    render layout: !request.xhr?
  end

  # GET /settings/budget_types/1/edit
  def edit
  end

  # POST /settings/budget_types
  # POST /settings/budget_types.json
  def create
    @budget_type = BudgetType.new(budget_type_params)
    authorize! params[:button].to_sym, @budget_type if @budget_type.respond_to?(:current_state)

    respond_to do |format|
      if @budget_type.save && (!@budget_type.respond_to?(:current_state) || @budget_type.process_event!(params[:button]))
        format.html { redirect_to settings_budget_types_url(q: params[:q], page: params[:page]), notice: 'Budget type was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_budget_type_url(@budget_type) }
      else
        format.html { render action: 'new' }
        format.json { render json: @budget_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/budget_types/1
  # PATCH/PUT /settings/budget_types/1.json
  def update
    authorize! params[:button].to_sym, @budget_type if @budget_type.respond_to?(:current_state)

    respond_to do |format|
      if (params[:budget_type].nil? || @budget_type.update(budget_type_params)) && (!@budget_type.respond_to?(:current_state) || @budget_type.process_event!(params[:button]))
        format.html { redirect_to settings_budget_types_url(q: params[:q], page: params[:page]), notice: 'Budget type was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @budget_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/budget_types/1
  # DELETE /settings/budget_types/1.json
  def destroy
    if params[:id]
      if (!@budget_type.respond_to?(:current_state) || !@budget_type.current_state.meta[:no_destroy]) &&
        (BudgetType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @budget_type.send(r.name).count}.sum == 0)
        @budget_type.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, BudgetType
      BudgetType.where(id: params[:ids]).each do |budget_type|
        if can?(:destroy, budget_type) &&
          (!budget_type.respond_to?(:current_state) || !budget_type.current_state.meta[:no_destroy]) &&
          (BudgetType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| budget_type.send(r.name).count}.sum == 0)
          budget_type.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_budget_types_url(q: params[:q], page: params[:page]), notice: 'Budget type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_type
      @budget_type = BudgetType.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_type_params
      params.require(:budget_type).permit(:workflow_state, :workflow_state_updater_id, :name)
    end

    def default_layout
      "orb"
    end
    
end
