class Settings::FacultyUsersController < SettingsController
  load_and_authorize_resource :class => "FacultyUser"

  before_action :set_faculty_user, only: [:show, :edit, :update, :destroy]

  # GET /settings/faculty_users
  # GET /settings/faculty_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = FacultyUser.active_states.join(",")
    end if FacultyUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if FacultyUser.respond_to?(:workflow_spec)
    @q = FacultyUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @faculty_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/faculty_users/1
  # GET /settings/faculty_users/1.json
  def show
  end

  # GET /settings/faculty_users/new
  def new
    @faculty_user = FacultyUser.new
    render layout: !request.xhr?
  end

  # GET /settings/faculty_users/1/edit
  def edit
  end

  # POST /settings/faculty_users
  # POST /settings/faculty_users.json
  def create
    @faculty_user = FacultyUser.new(faculty_user_params)
    authorize! params[:button].to_sym, @faculty_user if @faculty_user.respond_to?(:current_state)

    respond_to do |format|
      if @faculty_user.save && (!@faculty_user.respond_to?(:current_state) || @faculty_user.process_event!(params[:button]))
        format.html { redirect_to settings_faculty_users_url(q: params[:q], page: params[:page]), notice: 'Faculty user was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_faculty_user_url(@faculty_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @faculty_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/faculty_users/1
  # PATCH/PUT /settings/faculty_users/1.json
  def update
    authorize! params[:button].to_sym, @faculty_user if @faculty_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:faculty_user].nil? || @faculty_user.update(faculty_user_params)) && (!@faculty_user.respond_to?(:current_state) || @faculty_user.process_event!(params[:button]))
        format.html { redirect_to settings_faculty_users_url(q: params[:q], page: params[:page]), notice: 'Faculty user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @faculty_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/faculty_users/1
  # DELETE /settings/faculty_users/1.json
  def destroy
    if params[:id]
      if (!@faculty_user.respond_to?(:current_state) || !@faculty_user.current_state.meta[:no_destroy]) &&
        (FacultyUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @faculty_user.send(r.name).count}.sum == 0)
        @faculty_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, FacultyUser
      FacultyUser.where(id: params[:ids]).each do |faculty_user|
        if can?(:destroy, faculty_user) &&
          (!faculty_user.respond_to?(:current_state) || !faculty_user.current_state.meta[:no_destroy]) &&
          (FacultyUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| faculty_user.send(r.name).count}.sum == 0)
          faculty_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_faculty_users_url(q: params[:q], page: params[:page]), notice: 'Faculty user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faculty_user
      @faculty_user = FacultyUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faculty_user_params
      params.require(:faculty_user).permit(:workflow_state, :workflow_state_updater_id, :faculty_id, :user_id)
    end

    def default_layout
      "orb"
    end
    
end
