class Settings::TacticsController < SettingsController
  load_and_authorize_resource :class => "Tactic"

  before_action :set_tactic, only: [:show, :edit, :update, :destroy]

  # GET /settings/tactics
  # GET /settings/tactics.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year)
      params[:q] = {}
      params[:q][:strategy_year_eq] = year
      params[:q][:workflow_state_in] = Tactic.active_states.join(",")
    end if Tactic.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Tactic.respond_to?(:workflow_spec)
    @q = Tactic.limit(params[:limit]).search(params[:q])
    @q.sorts = "strategies.year, strategy_groups.no, strategies.no, tactics.sorting" if @q.sorts.empty?
    @tactics = request.format.html? ? @q.result.includes(:strategy, :strategy_group).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:strategy, :strategy_group)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/tactics/1
  # GET /settings/tactics/1.json
  def show
  end

  # GET /settings/tactics/new
  def new
    @tactic = Tactic.new
    render layout: !request.xhr?
  end

  # GET /settings/tactics/1/edit
  def edit
  end

  # POST /settings/tactics
  # POST /settings/tactics.json
  def create
    @tactic = Tactic.new(tactic_params)
    authorize! params[:button].to_sym, @tactic if @tactic.respond_to?(:current_state)

    respond_to do |format|
      if @tactic.save && (!@tactic.respond_to?(:current_state) || @tactic.process_event!(params[:button]))
        format.html { redirect_to settings_tactics_url(q: params[:q], page: params[:page]), notice: 'Tactic was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_tactic_url(@tactic) }
      else
        format.html { render action: 'new' }
        format.json { render json: @tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/tactics/1
  # PATCH/PUT /settings/tactics/1.json
  def update
    authorize! params[:button].to_sym, @tactic if @tactic.respond_to?(:current_state)

    respond_to do |format|
      if (params[:tactic].nil? || @tactic.update(tactic_params)) && (!@tactic.respond_to?(:current_state) || @tactic.process_event!(params[:button]))
        format.html { redirect_to settings_tactics_url(q: params[:q], page: params[:page]), notice: 'Tactic was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/tactics/1
  # DELETE /settings/tactics/1.json
  def destroy
    if params[:id]
      if (!@tactic.respond_to?(:current_state) || !@tactic.current_state.meta[:no_destroy]) &&
        (Tactic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @tactic.send(r.name).count}.sum == 0)
        @tactic.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Tactic
      Tactic.where(id: params[:ids]).each do |tactic|
        if can?(:destroy, tactic) &&
          (!tactic.respond_to?(:current_state) || !tactic.current_state.meta[:no_destroy]) &&
          (Tactic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| tactic.send(r.name).count}.sum == 0)
          tactic.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_tactics_url(q: params[:q], page: params[:page]), notice: 'Tactic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def chose_strategy_group
    @strategy_group = StrategyGroup.find(params[:strategy_group_id]) if !params[:strategy_group_id].blank?
    @year = !params[:year].blank? ? params[:year].to_i : nil

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tactic
      @tactic = Tactic.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tactic_params
      params.require(:tactic).permit(:workflow_state, :workflow_state_updater_id, :sorting, :strategy_id, :name)
    end

    def default_layout
      "orb"
    end
    
end
