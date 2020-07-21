class Projects::IndicatorsController < OrbController
  load_and_authorize_resource :class => "Indicator"

  before_action :set_indicator, only: [:show, :edit, :update, :destroy]

  # GET /projects/indicators
  # GET /projects/indicators.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Indicator.active_states.join(",")
    end if Indicator.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Indicator.respond_to?(:workflow_spec)
    @q = Indicator.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @indicators = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/indicators/1
  # GET /projects/indicators/1.json
  def show
  end

  # GET /projects/indicators/new
  def new
    @indicator = Indicator.new
    render layout: !request.xhr?
  end

  # GET /projects/indicators/1/edit
  def edit
  end

  # POST /projects/indicators
  # POST /projects/indicators.json
  def create
    @indicator = Indicator.new(indicator_params)
    authorize! params[:button].to_sym, @indicator if @indicator.respond_to?(:current_state)

    respond_to do |format|
      if @indicator.save && (!@indicator.respond_to?(:current_state) || @indicator.process_event!(params[:button]))
        format.html { redirect_to projects_indicators_url(q: params[:q], page: params[:page]), notice: 'Indicator was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_indicator_url(@indicator) }
      else
        format.html { render action: 'new' }
        format.json { render json: @indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/indicators/1
  # PATCH/PUT /projects/indicators/1.json
  def update
    authorize! params[:button].to_sym, @indicator if @indicator.respond_to?(:current_state)

    respond_to do |format|
      if (params[:indicator].nil? || @indicator.update(indicator_params)) && (!@indicator.respond_to?(:current_state) || @indicator.process_event!(params[:button]))
        format.html { redirect_to projects_indicators_url(q: params[:q], page: params[:page]), notice: 'Indicator was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/indicators/1
  # DELETE /projects/indicators/1.json
  def destroy
    if params[:id]
      if (!@indicator.respond_to?(:current_state) || !@indicator.current_state.meta[:no_destroy]) &&
        (Indicator.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @indicator.send(r.name).count}.sum == 0)
        @indicator.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Indicator
      Indicator.where(id: params[:ids]).each do |indicator|
        if can?(:destroy, indicator) &&
          (!indicator.respond_to?(:current_state) || !indicator.current_state.meta[:no_destroy]) &&
          (Indicator.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| indicator.send(r.name).count}.sum == 0)
          indicator.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_indicators_url(q: params[:q], page: params[:page]), notice: 'Indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indicator
      @indicator = Indicator.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indicator_params
      params.require(:indicator).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description, :target, :result1, :result2, :result3, :unit)
    end

    def default_layout
      "orb"
    end
    
end
