class Settings::SectionUsersController < SettingsController
  load_and_authorize_resource :class => "SectionUser"

  before_action :set_section_user, only: [:show, :edit, :update, :destroy]

  # GET /settings/section_users
  # GET /settings/section_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = SectionUser.active_states.join(",")
    end if SectionUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if SectionUser.respond_to?(:workflow_spec)
    @q = SectionUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @section_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/section_users/1
  # GET /settings/section_users/1.json
  def show
  end

  # GET /settings/section_users/new
  def new
    @section_user = SectionUser.new
    render layout: !request.xhr?
  end

  # GET /settings/section_users/1/edit
  def edit
  end

  # POST /settings/section_users
  # POST /settings/section_users.json
  def create
    @section_user = SectionUser.new(section_user_params)
    authorize! params[:button].to_sym, @section_user if @section_user.respond_to?(:current_state)

    respond_to do |format|
      if @section_user.save && (!@section_user.respond_to?(:current_state) || @section_user.process_event!(params[:button]))
        format.html { redirect_to settings_section_users_url(q: params[:q], page: params[:page]), notice: 'Section user was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_section_user_url(@section_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @section_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/section_users/1
  # PATCH/PUT /settings/section_users/1.json
  def update
    authorize! params[:button].to_sym, @section_user if @section_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:section_user].nil? || @section_user.update(section_user_params)) && (!@section_user.respond_to?(:current_state) || @section_user.process_event!(params[:button]))
        format.html { redirect_to settings_section_users_url(q: params[:q], page: params[:page]), notice: 'Section user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @section_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/section_users/1
  # DELETE /settings/section_users/1.json
  def destroy
    if params[:id]
      if (!@section_user.respond_to?(:current_state) || !@section_user.current_state.meta[:no_destroy]) &&
        (SectionUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @section_user.send(r.name).count}.sum == 0)
        @section_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, SectionUser
      SectionUser.where(id: params[:ids]).each do |section_user|
        if can?(:destroy, section_user) &&
          (!section_user.respond_to?(:current_state) || !section_user.current_state.meta[:no_destroy]) &&
          (SectionUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| section_user.send(r.name).count}.sum == 0)
          section_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_section_users_url(q: params[:q], page: params[:page]), notice: 'Section user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section_user
      @section_user = SectionUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_user_params
      params.require(:section_user).permit(:workflow_state, :workflow_state_updater_id, :section_id, :user_id)
    end

    def default_layout
      "orb"
    end
    
end
