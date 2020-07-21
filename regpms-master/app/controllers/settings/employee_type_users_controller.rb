class Settings::EmployeeTypeUsersController < SettingsController
  load_and_authorize_resource :class => "EmployeeTypeUser"

  before_action :set_employee_type_user, only: [:show, :edit, :update, :destroy]

  # GET /settings/employee_type_users
  # GET /settings/employee_type_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EmployeeTypeUser.active_states.join(",")
    end if EmployeeTypeUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EmployeeTypeUser.respond_to?(:workflow_spec)
    @q = EmployeeTypeUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @employee_type_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/employee_type_users/1
  # GET /settings/employee_type_users/1.json
  def show
  end

  # GET /settings/employee_type_users/new
  def new
    @employee_type_user = EmployeeTypeUser.new
    render layout: !request.xhr?
  end

  # GET /settings/employee_type_users/1/edit
  def edit
  end

  # POST /settings/employee_type_users
  # POST /settings/employee_type_users.json
  def create
    @employee_type_user = EmployeeTypeUser.new(employee_type_user_params)
    authorize! params[:button].to_sym, @employee_type_user if @employee_type_user.respond_to?(:current_state)

    respond_to do |format|
      if @employee_type_user.save && (!@employee_type_user.respond_to?(:current_state) || @employee_type_user.process_event!(params[:button]))
        format.html { redirect_to settings_employee_type_users_url(q: params[:q], page: params[:page]), notice: 'Employee type user was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_employee_type_user_url(@employee_type_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee_type_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/employee_type_users/1
  # PATCH/PUT /settings/employee_type_users/1.json
  def update
    authorize! params[:button].to_sym, @employee_type_user if @employee_type_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:employee_type_user].nil? || @employee_type_user.update(employee_type_user_params)) && (!@employee_type_user.respond_to?(:current_state) || @employee_type_user.process_event!(params[:button]))
        format.html { redirect_to settings_employee_type_users_url(q: params[:q], page: params[:page]), notice: 'Employee type user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @employee_type_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/employee_type_users/1
  # DELETE /settings/employee_type_users/1.json
  def destroy
    if params[:id]
      if (!@employee_type_user.respond_to?(:current_state) || !@employee_type_user.current_state.meta[:no_destroy]) &&
        (EmployeeTypeUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @employee_type_user.send(r.name).count}.sum == 0)
        @employee_type_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EmployeeTypeUser
      EmployeeTypeUser.where(id: params[:ids]).each do |employee_type_user|
        if can?(:destroy, employee_type_user) &&
          (!employee_type_user.respond_to?(:current_state) || !employee_type_user.current_state.meta[:no_destroy]) &&
          (EmployeeTypeUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| employee_type_user.send(r.name).count}.sum == 0)
          employee_type_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_employee_type_users_url(q: params[:q], page: params[:page]), notice: 'Employee type user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_type_user
      @employee_type_user = EmployeeTypeUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_type_user_params
      params.require(:employee_type_user).permit(
        :workflow_state, :workflow_state_updater_id, :employee_type_id, :user_id, :evaluation_id, 
        employee_type_task_groups_attributes: [
          :id, :sorting, :name, :_destroy, 
          employee_type_tasks_attributes: [:id, :sorting, :task_id, :weight, :_destroy]
        ]
      )
    end

    def default_layout
      "orb"
    end
    
end
