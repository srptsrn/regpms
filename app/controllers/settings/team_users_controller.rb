class Settings::TeamUsersController < SettingsController
  load_and_authorize_resource :class => "TeamUser"

  before_action :set_team_user, only: [:show, :edit, :update, :destroy]

  # GET /settings/team_users
  # GET /settings/team_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = TeamUser.active_states.join(",")
    end if TeamUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if TeamUser.respond_to?(:workflow_spec)
    @q = TeamUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @team_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/team_users/1
  # GET /settings/team_users/1.json
  def show
  end

  # GET /settings/team_users/new
  def new
    @team_user = TeamUser.new
    render layout: !request.xhr?
  end

  # GET /settings/team_users/1/edit
  def edit
  end

  # POST /settings/team_users
  # POST /settings/team_users.json
  def create
    @team_user = TeamUser.new(team_user_params)
    authorize! params[:button].to_sym, @team_user if @team_user.respond_to?(:current_state)

    respond_to do |format|
      if @team_user.save && (!@team_user.respond_to?(:current_state) || @team_user.process_event!(params[:button]))
        format.html { redirect_to settings_team_users_url(q: params[:q], page: params[:page]), notice: 'Team user was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_team_user_url(@team_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/team_users/1
  # PATCH/PUT /settings/team_users/1.json
  def update
    authorize! params[:button].to_sym, @team_user if @team_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:team_user].nil? || @team_user.update(team_user_params)) && (!@team_user.respond_to?(:current_state) || @team_user.process_event!(params[:button]))
        format.html { redirect_to settings_team_users_url(q: params[:q], page: params[:page]), notice: 'Team user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/team_users/1
  # DELETE /settings/team_users/1.json
  def destroy
    if params[:id]
      if (!@team_user.respond_to?(:current_state) || !@team_user.current_state.meta[:no_destroy]) &&
        (TeamUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @team_user.send(r.name).count}.sum == 0)
        @team_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, TeamUser
      TeamUser.where(id: params[:ids]).each do |team_user|
        if can?(:destroy, team_user) &&
          (!team_user.respond_to?(:current_state) || !team_user.current_state.meta[:no_destroy]) &&
          (TeamUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| team_user.send(r.name).count}.sum == 0)
          team_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_team_users_url(q: params[:q], page: params[:page]), notice: 'Team user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_user
      @team_user = TeamUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_user_params
      params.require(:team_user).permit(:workflow_state, :workflow_state_updater_id, :team_id, :user_id)
    end

    def default_layout
      "orb"
    end
    
end
