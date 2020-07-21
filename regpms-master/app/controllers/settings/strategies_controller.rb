class Settings::StrategiesController < SettingsController
  load_and_authorize_resource :class => "Strategy"

  before_action :set_strategy, only: [:show, :edit, :update, :destroy]

  # GET /settings/strategies
  # GET /settings/strategies.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year)
      params[:q] = {}
      params[:q][:year_eq] = year
      params[:q][:workflow_state_in] = Strategy.active_states.join(",")
    end if Strategy.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Strategy.respond_to?(:workflow_spec)
    @q = Strategy.limit(params[:limit]).search(params[:q])
    @q.sorts = 'sorting' if @q.sorts.empty?
    @strategies = request.format.html? ? @q.result.includes(:strategy_group).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:strategy_group)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/strategies/1
  # GET /settings/strategies/1.json
  def show
  end

  # GET /settings/strategies/new
  def new
    @strategy = Strategy.new(year: params[:year])
    render layout: !request.xhr?
  end

  # GET /settings/strategies/1/edit
  def edit
  end

  # POST /settings/strategies
  # POST /settings/strategies.json
  def create
    @strategy = Strategy.new(strategy_params)
    authorize! params[:button].to_sym, @strategy if @strategy.respond_to?(:current_state)

    respond_to do |format|
      if @strategy.save && (!@strategy.respond_to?(:current_state) || @strategy.process_event!(params[:button]))
        format.html { redirect_to settings_strategies_url(q: params[:q], page: params[:page]), notice: 'Strategy was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_strategy_url(@strategy) }
      else
        format.html { render action: 'new' }
        format.json { render json: @strategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/strategies/1
  # PATCH/PUT /settings/strategies/1.json
  def update
    authorize! params[:button].to_sym, @strategy if @strategy.respond_to?(:current_state)

    respond_to do |format|
      if (params[:strategy].nil? || @strategy.update(strategy_params)) && (!@strategy.respond_to?(:current_state) || @strategy.process_event!(params[:button]))
        format.html { redirect_to settings_strategies_url(q: params[:q], page: params[:page]), notice: 'Strategy was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @strategy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/strategies/1
  # DELETE /settings/strategies/1.json
  def destroy
    if params[:id]
      if (!@strategy.respond_to?(:current_state) || !@strategy.current_state.meta[:no_destroy]) &&
        (Strategy.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @strategy.send(r.name).count}.sum == 0)
        @strategy.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Strategy
      Strategy.where(id: params[:ids]).each do |strategy|
        if can?(:destroy, strategy) &&
          (!strategy.respond_to?(:current_state) || !strategy.current_state.meta[:no_destroy]) &&
          (Strategy.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| strategy.send(r.name).count}.sum == 0)
          strategy.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_strategies_url(q: params[:q], page: params[:page]), notice: 'Strategy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategy
      @strategy = Strategy.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def strategy_params
      params.require(:strategy).permit(
        :workflow_state, :workflow_state_updater_id, :sorting, :name, :year, :strategy_group_id, 
        tactics_attributes: [:id, :strategy_id, :sorting, :name, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
