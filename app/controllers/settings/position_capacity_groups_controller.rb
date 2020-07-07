class Settings::PositionCapacityGroupsController < SettingsController
  load_and_authorize_resource :class => "PositionCapacityGroup"

  before_action :set_position_capacity_group, only: [:show, :edit, :update, :destroy]

  # GET /settings/position_capacity_groups
  # GET /settings/position_capacity_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = PositionCapacityGroup.active_states.join(",")
    end if PositionCapacityGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if PositionCapacityGroup.respond_to?(:workflow_spec)
    @q = PositionCapacityGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @position_capacity_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/position_capacity_groups/1
  # GET /settings/position_capacity_groups/1.json
  def show
  end

  # GET /settings/position_capacity_groups/new
  def new
    @position_capacity_group = PositionCapacityGroup.new
    render layout: !request.xhr?
  end

  # GET /settings/position_capacity_groups/1/edit
  def edit
  end

  # POST /settings/position_capacity_groups
  # POST /settings/position_capacity_groups.json
  def create
    @position_capacity_group = PositionCapacityGroup.new(position_capacity_group_params)
    authorize! params[:button].to_sym, @position_capacity_group if @position_capacity_group.respond_to?(:current_state)

    respond_to do |format|
      if @position_capacity_group.save && (!@position_capacity_group.respond_to?(:current_state) || @position_capacity_group.process_event!(params[:button]))
        format.html { redirect_to settings_position_capacity_groups_url(q: params[:q], page: params[:page]), notice: 'Position capacity group was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_position_capacity_group_url(@position_capacity_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position_capacity_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/position_capacity_groups/1
  # PATCH/PUT /settings/position_capacity_groups/1.json
  def update
    authorize! params[:button].to_sym, @position_capacity_group if @position_capacity_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position_capacity_group].nil? || @position_capacity_group.update(position_capacity_group_params)) && (!@position_capacity_group.respond_to?(:current_state) || @position_capacity_group.process_event!(params[:button]))
        format.html { redirect_to settings_position_capacity_groups_url(q: params[:q], page: params[:page]), notice: 'Position capacity group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position_capacity_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/position_capacity_groups/1
  # DELETE /settings/position_capacity_groups/1.json
  def destroy
    if params[:id]
      if (!@position_capacity_group.respond_to?(:current_state) || !@position_capacity_group.current_state.meta[:no_destroy]) &&
        (PositionCapacityGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position_capacity_group.send(r.name).count}.sum == 0)
        @position_capacity_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, PositionCapacityGroup
      PositionCapacityGroup.where(id: params[:ids]).each do |position_capacity_group|
        if can?(:destroy, position_capacity_group) &&
          (!position_capacity_group.respond_to?(:current_state) || !position_capacity_group.current_state.meta[:no_destroy]) &&
          (PositionCapacityGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position_capacity_group.send(r.name).count}.sum == 0)
          position_capacity_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_position_capacity_groups_url(q: params[:q], page: params[:page]), notice: 'Position capacity group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_capacity_group
      @position_capacity_group = PositionCapacityGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_capacity_group_params
      params.require(:position_capacity_group).permit(:workflow_state, :workflow_state_updater_id, :sorting, :position_id, :name)
    end

    def default_layout
      "orb"
    end
    
end
