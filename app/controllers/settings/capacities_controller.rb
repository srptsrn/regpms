class Settings::CapacitiesController < SettingsController
  load_and_authorize_resource :class => "Capacity"

  before_action :set_capacity, only: [:show, :edit, :update, :destroy]

  # GET /settings/capacities
  # GET /settings/capacities.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Capacity.active_states.join(",")
    end if Capacity.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Capacity.respond_to?(:workflow_spec)
    @q = Capacity.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @capacities = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/capacities/1
  # GET /settings/capacities/1.json
  def show
  end

  # GET /settings/capacities/new
  def new
    @capacity = Capacity.new
    render layout: !request.xhr?
  end

  # GET /settings/capacities/1/edit
  def edit
  end

  # POST /settings/capacities
  # POST /settings/capacities.json
  def create
    @capacity = Capacity.new(capacity_params)
    authorize! params[:button].to_sym, @capacity if @capacity.respond_to?(:current_state)

    respond_to do |format|
      if @capacity.save && (!@capacity.respond_to?(:current_state) || @capacity.process_event!(params[:button]))
        format.html { redirect_to settings_capacities_url(q: params[:q], page: params[:page]), notice: 'Capacity was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_capacity_url(@capacity) }
      else
        format.html { render action: 'new' }
        format.json { render json: @capacity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/capacities/1
  # PATCH/PUT /settings/capacities/1.json
  def update
    authorize! params[:button].to_sym, @capacity if @capacity.respond_to?(:current_state)

    respond_to do |format|
      if (params[:capacity].nil? || @capacity.update(capacity_params)) && (!@capacity.respond_to?(:current_state) || @capacity.process_event!(params[:button]))
        format.html { redirect_to settings_capacities_url(q: params[:q], page: params[:page]), notice: 'Capacity was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @capacity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/capacities/1
  # DELETE /settings/capacities/1.json
  def destroy
    if params[:id]
      if (!@capacity.respond_to?(:current_state) || !@capacity.current_state.meta[:no_destroy]) &&
        (Capacity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @capacity.send(r.name).count}.sum == 0)
        @capacity.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Capacity
      Capacity.where(id: params[:ids]).each do |capacity|
        if can?(:destroy, capacity) &&
          (!capacity.respond_to?(:current_state) || !capacity.current_state.meta[:no_destroy]) &&
          (Capacity.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| capacity.send(r.name).count}.sum == 0)
          capacity.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_capacities_url(q: params[:q], page: params[:page]), notice: 'Capacity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capacity
      @capacity = Capacity.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def capacity_params
      params.require(:capacity).permit(:workflow_state, :workflow_state_updater_id, :name, :file)
    end

    def default_layout
      "orb"
    end
    
end
