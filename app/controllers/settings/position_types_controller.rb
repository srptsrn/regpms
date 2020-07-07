class Settings::PositionTypesController < SettingsController
  load_and_authorize_resource :class => "PositionType"

  before_action :set_position_type, only: [:show, :edit, :update, :destroy]

  # GET /settings/position_types
  # GET /settings/position_types.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = PositionType.active_states.join(",")
    end if PositionType.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if PositionType.respond_to?(:workflow_spec)
    @q = PositionType.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @position_types = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/position_types/1
  # GET /settings/position_types/1.json
  def show
  end

  # GET /settings/position_types/new
  def new
    @position_type = PositionType.new
    render layout: !request.xhr?
  end

  # GET /settings/position_types/1/edit
  def edit
  end

  # POST /settings/position_types
  # POST /settings/position_types.json
  def create
    @position_type = PositionType.new(position_type_params)
    authorize! params[:button].to_sym, @position_type if @position_type.respond_to?(:current_state)

    respond_to do |format|
      if @position_type.save && (!@position_type.respond_to?(:current_state) || @position_type.process_event!(params[:button]))
        format.html { redirect_to settings_position_types_url(q: params[:q], page: params[:page]), notice: 'Position type was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_position_type_url(@position_type) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/position_types/1
  # PATCH/PUT /settings/position_types/1.json
  def update
    authorize! params[:button].to_sym, @position_type if @position_type.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position_type].nil? || @position_type.update(position_type_params)) && (!@position_type.respond_to?(:current_state) || @position_type.process_event!(params[:button]))
        format.html { redirect_to settings_position_types_url(q: params[:q], page: params[:page]), notice: 'Position type was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/position_types/1
  # DELETE /settings/position_types/1.json
  def destroy
    if params[:id]
      if (!@position_type.respond_to?(:current_state) || !@position_type.current_state.meta[:no_destroy]) &&
        (PositionType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position_type.send(r.name).count}.sum == 0)
        @position_type.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, PositionType
      PositionType.where(id: params[:ids]).each do |position_type|
        if can?(:destroy, position_type) &&
          (!position_type.respond_to?(:current_state) || !position_type.current_state.meta[:no_destroy]) &&
          (PositionType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position_type.send(r.name).count}.sum == 0)
          position_type.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_position_types_url(q: params[:q], page: params[:page]), notice: 'Position type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_type
      @position_type = PositionType.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_type_params
      params.require(:position_type).permit(:workflow_state, :workflow_state_updater_id, :name, :sorting)
    end

    def default_layout
      "orb"
    end
    
end
