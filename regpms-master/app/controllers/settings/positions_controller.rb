# encoding: utf-8

class Settings::PositionsController < SettingsController
  load_and_authorize_resource :class => "Position"

  before_action :set_position, only: [:show, :edit, :update, :destroy]

  # GET /settings/positions
  # GET /settings/positions.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Position.active_states.join(",")
    end if Position.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Position.respond_to?(:workflow_spec)
    @q = Position.limit(params[:limit]).search(params[:q])
    @q.sorts =  ['name asc', 'position_type_name asc', 'position_type_level asc'] if @q.sorts.empty?
    @positions = request.format.html? ? @q.result.includes(:position_level, :position_type).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:position_level, :position_type)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/positions/1
  # GET /settings/positions/1.json
  def show
  end

  # GET /settings/positions/new
  def new
    @position = Position.new
    @position.position_capacity_groups.build(sorting: 1, name: "สมรรถนะหลัก")
    @position.position_capacity_groups.build(sorting: 2, name: "สมรรถนะประจำกลุ่มงาน")
    render layout: !request.xhr?
  end

  # GET /settings/positions/1/edit
  def edit
    if @position.position_capacity_groups.size == 0
      @position.position_capacity_groups.build(sorting: 1, name: "สมรรถนะหลัก")
      @position.position_capacity_groups.build(sorting: 2, name: "สมรรถนะประจำกลุ่มงาน")
    end
  end

  # POST /settings/positions
  # POST /settings/positions.json
  def create
    @position = Position.new(position_params)
    authorize! params[:button].to_sym, @position if @position.respond_to?(:current_state)

    respond_to do |format|
      if @position.save && (!@position.respond_to?(:current_state) || @position.process_event!(params[:button]))
        format.html { redirect_to settings_positions_url(q: params[:q], page: params[:page]), notice: 'Position was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_position_url(@position) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/positions/1
  # PATCH/PUT /settings/positions/1.json
  def update
    authorize! params[:button].to_sym, @position if @position.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position].nil? || @position.update(position_params)) && (!@position.respond_to?(:current_state) || @position.process_event!(params[:button]))
        format.html { redirect_to settings_positions_url(q: params[:q], page: params[:page]), notice: 'Position was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/positions/1
  # DELETE /settings/positions/1.json
  def destroy
    if params[:id]
      if (!@position.respond_to?(:current_state) || !@position.current_state.meta[:no_destroy]) &&
        (Position.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position.send(r.name).count}.sum == 0)
        @position.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Position
      Position.where(id: params[:ids]).each do |position|
        if can?(:destroy, position) &&
          (!position.respond_to?(:current_state) || !position.current_state.meta[:no_destroy]) &&
          (Position.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position.send(r.name).count}.sum == 0)
          position.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_positions_url(q: params[:q], page: params[:page]), notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(
        :workflow_state, :workflow_state_updater_id, :name, :position_type_id, :position_level_id, 
        position_capacity_groups_attributes: [
          :id, :sorting, :name, :_destroy, 
          position_capacities_attributes: [:id, :sorting, :capacity_id, :weight, :expect, :_destroy]
        ]
      )
    end

    def default_layout
      "orb"
    end
    
end
