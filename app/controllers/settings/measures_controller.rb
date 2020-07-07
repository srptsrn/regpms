class Settings::MeasuresController < SettingsController
  load_and_authorize_resource :class => "Measure"

  before_action :set_measure, only: [:show, :edit, :update, :destroy]

  # GET /settings/measures
  # GET /settings/measures.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year)
      params[:q] = {}
      params[:q][:strategy_year_eq] = year
      params[:q][:workflow_state_in] = Measure.active_states.join(",")
    end if Measure.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Measure.respond_to?(:workflow_spec)
    @q = Measure.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @measures = request.format.html? ? @q.result.includes(:tactic, :strategy, :strategy_group).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:tactic, :strategy, :strategy_group)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/measures/1
  # GET /settings/measures/1.json
  def show
  end

  # GET /settings/measures/new
  def new
    @measure = Measure.new
    render layout: !request.xhr?
  end

  # GET /settings/measures/1/edit
  def edit
  end

  # POST /settings/measures
  # POST /settings/measures.json
  def create
    @measure = Measure.new(measure_params)
    authorize! params[:button].to_sym, @measure if @measure.respond_to?(:current_state)

    respond_to do |format|
      if @measure.save && (!@measure.respond_to?(:current_state) || @measure.process_event!(params[:button]))
        format.html { redirect_to settings_measures_url(q: params[:q], page: params[:page]), notice: 'Measure was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_measure_url(@measure) }
      else
        format.html { render action: 'new' }
        format.json { render json: @measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/measures/1
  # PATCH/PUT /settings/measures/1.json
  def update
    authorize! params[:button].to_sym, @measure if @measure.respond_to?(:current_state)

    respond_to do |format|
      if (params[:measure].nil? || @measure.update(measure_params)) && (!@measure.respond_to?(:current_state) || @measure.process_event!(params[:button]))
        format.html { redirect_to settings_measures_url(q: params[:q], page: params[:page]), notice: 'Measure was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/measures/1
  # DELETE /settings/measures/1.json
  def destroy
    if params[:id]
      if (!@measure.respond_to?(:current_state) || !@measure.current_state.meta[:no_destroy]) &&
        (Measure.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @measure.send(r.name).count}.sum == 0)
        @measure.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Measure
      Measure.where(id: params[:ids]).each do |measure|
        if can?(:destroy, measure) &&
          (!measure.respond_to?(:current_state) || !measure.current_state.meta[:no_destroy]) &&
          (Measure.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| measure.send(r.name).count}.sum == 0)
          measure.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_measures_url(q: params[:q], page: params[:page]), notice: 'Measure was successfully destroyed.' }
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
  
  def chose_strategy
    @strategy = Strategy.find(params[:strategy_id]) if !params[:strategy_id].blank?
    @year = !params[:year].blank? ? params[:year].to_i : nil

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measure
      @measure = Measure.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measure_params
      params.require(:measure).permit(:workflow_state, :workflow_state_updater_id, :tactic_id, :no, :name)
    end

    def default_layout
      "orb"
    end
    
end
