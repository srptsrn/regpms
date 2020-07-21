class Settings::TeamsController < SettingsController
  load_and_authorize_resource :class => "Team"

  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /settings/teams
  # GET /settings/teams.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Team.active_states.join(",")
    end if Team.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Team.respond_to?(:workflow_spec)
    @q = Team.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @teams = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/teams/1
  # GET /settings/teams/1.json
  def show
  end

  # GET /settings/teams/new
  def new
    @team = Team.new
    render layout: !request.xhr?
  end

  # GET /settings/teams/1/edit
  def edit
  end

  # POST /settings/teams
  # POST /settings/teams.json
  def create
    @team = Team.new(team_params)
    authorize! params[:button].to_sym, @team if @team.respond_to?(:current_state)

    respond_to do |format|
      if @team.save && (!@team.respond_to?(:current_state) || @team.process_event!(params[:button]))
        format.html { redirect_to settings_teams_url(q: params[:q], page: params[:page]), notice: 'Team was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_team_url(@team) }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/teams/1
  # PATCH/PUT /settings/teams/1.json
  def update
    authorize! params[:button].to_sym, @team if @team.respond_to?(:current_state)

    respond_to do |format|
      if (params[:team].nil? || @team.update(team_params)) && (!@team.respond_to?(:current_state) || @team.process_event!(params[:button]))
        format.html { redirect_to settings_teams_url(q: params[:q], page: params[:page]), notice: 'Team was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/teams/1
  # DELETE /settings/teams/1.json
  def destroy
    if params[:id]
      if (!@team.respond_to?(:current_state) || !@team.current_state.meta[:no_destroy]) &&
        (Team.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @team.send(r.name).count}.sum == 0)
        @team.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Team
      Team.where(id: params[:ids]).each do |team|
        if can?(:destroy, team) &&
          (!team.respond_to?(:current_state) || !team.current_state.meta[:no_destroy]) &&
          (Team.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| team.send(r.name).count}.sum == 0)
          team.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_teams_url(q: params[:q], page: params[:page]), notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(
        :workflow_state, :workflow_state_updater_id, :name, :leader_id, 
        team_users_attributes: [:id, :team_id, :user_id, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
