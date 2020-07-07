class PositionCapacityUsersController < OrbController
  load_and_authorize_resource :class => "PositionCapacityUser"

  before_action :set_position_capacity_user, only: [:show, :edit, :update, :destroy]

  # GET /position_capacity_users
  # GET /position_capacity_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = PositionCapacityUser.active_states.join(",")
    end if PositionCapacityUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if PositionCapacityUser.respond_to?(:workflow_spec)
    @q = PositionCapacityUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @position_capacity_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /position_capacity_users/1
  # GET /position_capacity_users/1.json
  def show
  end

  # GET /position_capacity_users/new
  def new
    @position_capacity_user = PositionCapacityUser.new
    render layout: !request.xhr?
  end

  # GET /position_capacity_users/1/edit
  def edit
  end

  # POST /position_capacity_users
  # POST /position_capacity_users.json
  def create
    @position_capacity_user = PositionCapacityUser.new(position_capacity_user_params)
    authorize! params[:button].to_sym, @position_capacity_user if @position_capacity_user.respond_to?(:current_state)

    respond_to do |format|
      if @position_capacity_user.save && (!@position_capacity_user.respond_to?(:current_state) || @position_capacity_user.process_event!(params[:button]))
        format.html { redirect_to position_capacity_users_url(q: params[:q], page: params[:page]), notice: 'Position capacity user was successfully created.' }
        format.json { render action: 'show', status: :created, location: position_capacity_user_url(@position_capacity_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @position_capacity_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /position_capacity_users/1
  # PATCH/PUT /position_capacity_users/1.json
  def update
    authorize! params[:button].to_sym, @position_capacity_user if @position_capacity_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:position_capacity_user].nil? || @position_capacity_user.update(position_capacity_user_params)) && (!@position_capacity_user.respond_to?(:current_state) || @position_capacity_user.process_event!(params[:button]))
        format.html { redirect_to position_capacity_users_url(q: params[:q], page: params[:page]), notice: 'Position capacity user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @position_capacity_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /position_capacity_users/1
  # DELETE /position_capacity_users/1.json
  def destroy
    if params[:id]
      if (!@position_capacity_user.respond_to?(:current_state) || !@position_capacity_user.current_state.meta[:no_destroy]) &&
        (PositionCapacityUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @position_capacity_user.send(r.name).count}.sum == 0)
        @position_capacity_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, PositionCapacityUser
      PositionCapacityUser.where(id: params[:ids]).each do |position_capacity_user|
        if can?(:destroy, position_capacity_user) &&
          (!position_capacity_user.respond_to?(:current_state) || !position_capacity_user.current_state.meta[:no_destroy]) &&
          (PositionCapacityUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| position_capacity_user.send(r.name).count}.sum == 0)
          position_capacity_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to position_capacity_users_url(q: params[:q], page: params[:page]), notice: 'Position capacity user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_capacity_user
      @position_capacity_user = PositionCapacityUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_capacity_user_params
      params.require(:position_capacity_user).permit(:workflow_state, :workflow_state_updater_id, :position_capacity_id, :user_id, :evaluation_id, :committee_id, :role, :expect, :weight, :score, :score_real_expect, :score_real_100, :score_weight, :score_real)
    end

    def default_layout
      "orb"
    end
    
end
