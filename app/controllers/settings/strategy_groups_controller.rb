class Settings::StrategyGroupsController < SettingsController
  load_and_authorize_resource :class => "StrategyGroup"

  before_action :set_strategy_group, only: [:show, :edit, :update, :destroy]

  # GET /settings/strategy_groups
  # GET /settings/strategy_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = StrategyGroup.active_states.join(",")
    end if StrategyGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if StrategyGroup.respond_to?(:workflow_spec)
    @q = StrategyGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @strategy_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/strategy_groups/1
  # GET /settings/strategy_groups/1.json
  def show
  end

  # GET /settings/strategy_groups/new
  def new
    @strategy_group = StrategyGroup.new
    render layout: !request.xhr?
  end

  # GET /settings/strategy_groups/1/edit
  def edit
  end

  # POST /settings/strategy_groups
  # POST /settings/strategy_groups.json
  def create
    @strategy_group = StrategyGroup.new(strategy_group_params)
    authorize! params[:button].to_sym, @strategy_group if @strategy_group.respond_to?(:current_state)

    respond_to do |format|
      if @strategy_group.save && (!@strategy_group.respond_to?(:current_state) || @strategy_group.process_event!(params[:button]))
        format.html { redirect_to settings_strategy_groups_url(q: params[:q], page: params[:page]), notice: 'Strategy group was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_strategy_group_url(@strategy_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @strategy_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/strategy_groups/1
  # PATCH/PUT /settings/strategy_groups/1.json
  def update
    authorize! params[:button].to_sym, @strategy_group if @strategy_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:strategy_group].nil? || @strategy_group.update(strategy_group_params)) && (!@strategy_group.respond_to?(:current_state) || @strategy_group.process_event!(params[:button]))
        format.html { redirect_to settings_strategy_groups_url(q: params[:q], page: params[:page]), notice: 'Strategy group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @strategy_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/strategy_groups/1
  # DELETE /settings/strategy_groups/1.json
  def destroy
    if params[:id]
      if (!@strategy_group.respond_to?(:current_state) || !@strategy_group.current_state.meta[:no_destroy]) &&
        (StrategyGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @strategy_group.send(r.name).count}.sum == 0)
        @strategy_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, StrategyGroup
      StrategyGroup.where(id: params[:ids]).each do |strategy_group|
        if can?(:destroy, strategy_group) &&
          (!strategy_group.respond_to?(:current_state) || !strategy_group.current_state.meta[:no_destroy]) &&
          (StrategyGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| strategy_group.send(r.name).count}.sum == 0)
          strategy_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_strategy_groups_url(q: params[:q], page: params[:page]), notice: 'Strategy group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategy_group
      @strategy_group = StrategyGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def strategy_group_params
      params.require(:strategy_group).permit(:workflow_state, :workflow_state_updater_id, :no, :name)
    end

    def default_layout
      "orb"
    end
    
end
