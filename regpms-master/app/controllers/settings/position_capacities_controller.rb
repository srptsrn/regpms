class Settings::PositionCapacitiesController < SettingsController
  load_and_authorize_resource :class => "PositionCapacity"

  before_action :set_position_capacity, only: [:show, :edit, :update, :destroy]

  # GET /settings/position_capacities
  # GET /settings/position_capacities.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = PositionCapacity.active_states.join(",")
    end if PositionCapacity.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if PositionCapacity.respond_to?(:workflow_spec)
    @q = PositionCapacity.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @position_capacities = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/position_capacities/1
  # GET /settings/position_capacities/1.json
  def show
  end

  # GET /settings/position_capacities/new
  def new
    @position_capacity = PositionCapacity.new
    render layout: !request.xhr?
  end

  # GET /settings/position_capacities/1/edit
  def edit
  end

  # POST /settings/position_capacities
  # POST /settings/position_capacities.json
  def create
    @position_capacity = PositionCapacity.new(position_capacity_params)
    authorize! params[:button].to_sym, @position_capacity if @position_capacity.respond_to?(:current_state)

    respond_to do |format|
      if @position_capacity.save && (!@position_capacity.respond_to?(:current_state) || @position_capacity.process_event!(params[:button]))
        format.html { redirect_to settings_position_capacities_url(q: params[:q], page: params[:page]), notice: 'Position capacity was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_position_capacity_url(@position_capacity) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position_capacity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/position_capacities/1
  # PATCH/PUT /settings/position_capacities/1.json
  def update
    authorize! params[:button].to_sym, @position_capacity if @position_capacity.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position_capacity].nil? || @position_capacity.update(position_capacity_params)) && (!@position_capacity.respond_to?(:current_state) || @position_capacity.process_event!(params[:button]))
        format.html { redirect_to settings_position_capacities_url(q: params[:q], page: params[:page]), notice: 'Position capacity was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position_capacity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/position_capacities/1
  # DELETE /settings/position_capacities/1.json
  def destroy
    if params[:id]
      if (!@position_capacity.respond_to?(:current_state) || !@position_capacity.current_state.meta[:no_destroy]) &&
        (PositionCapacity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position_capacity.send(r.name).count}.sum == 0)
        @position_capacity.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, PositionCapacity
      PositionCapacity.where(id: params[:ids]).each do |position_capacity|
        if can?(:destroy, position_capacity) &&
          (!position_capacity.respond_to?(:current_state) || !position_capacity.current_state.meta[:no_destroy]) &&
          (PositionCapacity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position_capacity.send(r.name).count}.sum == 0)
          position_capacity.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_position_capacities_url(q: params[:q], page: params[:page]), notice: 'Position capacity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_capacity
      @position_capacity = PositionCapacity.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_capacity_params
      params.require(:position_capacity).permit(:workflow_state, :workflow_state_updater_id, :sorting, :position_capacity_group_id, :capacity_id, :weight, :expect)
    end

    def default_layout
      "orb"
    end
    
end
