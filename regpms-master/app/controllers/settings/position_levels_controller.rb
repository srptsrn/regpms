class Settings::PositionLevelsController < SettingsController
  load_and_authorize_resource :class => "PositionLevel"

  before_action :set_position_level, only: [:show, :edit, :update, :destroy]

  # GET /settings/position_levels
  # GET /settings/position_levels.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = PositionLevel.active_states.join(",")
    end if PositionLevel.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if PositionLevel.respond_to?(:workflow_spec)
    @q = PositionLevel.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @position_levels = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/position_levels/1
  # GET /settings/position_levels/1.json
  def show
  end

  # GET /settings/position_levels/new
  def new
    @position_level = PositionLevel.new
    render layout: !request.xhr?
  end

  # GET /settings/position_levels/1/edit
  def edit
  end

  # POST /settings/position_levels
  # POST /settings/position_levels.json
  def create
    @position_level = PositionLevel.new(position_level_params)
    authorize! params[:button].to_sym, @position_level if @position_level.respond_to?(:current_state)

    respond_to do |format|
      if @position_level.save && (!@position_level.respond_to?(:current_state) || @position_level.process_event!(params[:button]))
        format.html { redirect_to settings_position_levels_url(q: params[:q], page: params[:page]), notice: 'Position level was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_position_level_url(@position_level) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/position_levels/1
  # PATCH/PUT /settings/position_levels/1.json
  def update
    authorize! params[:button].to_sym, @position_level if @position_level.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position_level].nil? || @position_level.update(position_level_params)) && (!@position_level.respond_to?(:current_state) || @position_level.process_event!(params[:button]))
        format.html { redirect_to settings_position_levels_url(q: params[:q], page: params[:page]), notice: 'Position level was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/position_levels/1
  # DELETE /settings/position_levels/1.json
  def destroy
    if params[:id]
      if (!@position_level.respond_to?(:current_state) || !@position_level.current_state.meta[:no_destroy]) &&
        (PositionLevel.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position_level.send(r.name).count}.sum == 0)
        @position_level.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, PositionLevel
      PositionLevel.where(id: params[:ids]).each do |position_level|
        if can?(:destroy, position_level) &&
          (!position_level.respond_to?(:current_state) || !position_level.current_state.meta[:no_destroy]) &&
          (PositionLevel.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position_level.send(r.name).count}.sum == 0)
          position_level.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_position_levels_url(q: params[:q], page: params[:page]), notice: 'Position level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_level
      @position_level = PositionLevel.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_level_params
      params.require(:position_level).permit(:workflow_state, :workflow_state_updater_id, :name, :sorting)
    end

    def default_layout
      "orb"
    end
    
end
