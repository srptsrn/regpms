class EmployeeTypeTaskUsersController < OrbController
  load_and_authorize_resource :class => "EmployeeTypeTaskUser"

  before_action :set_employee_type_task_user, only: [:show, :edit, :update, :destroy]

  # GET /employee_type_task_users
  # GET /employee_type_task_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EmployeeTypeTaskUser.active_states.join(",")
    end if EmployeeTypeTaskUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EmployeeTypeTaskUser.respond_to?(:workflow_spec)
    @q = EmployeeTypeTaskUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @employee_type_task_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /employee_type_task_users/1
  # GET /employee_type_task_users/1.json
  def show
  end

  # GET /employee_type_task_users/new
  def new
    @employee_type_task_user = EmployeeTypeTaskUser.new
    render layout: !request.xhr?
  end

  # GET /employee_type_task_users/1/edit
  def edit
  end

  # POST /employee_type_task_users
  # POST /employee_type_task_users.json
  def create
    @employee_type_task_user = EmployeeTypeTaskUser.new(employee_type_task_user_params)
    authorize! params[:button].to_sym, @employee_type_task_user if @employee_type_task_user.respond_to?(:current_state)

    respond_to do |format|
      if @employee_type_task_user.save && (!@employee_type_task_user.respond_to?(:current_state) || @employee_type_task_user.process_event!(params[:button]))
        format.html { redirect_to employee_type_task_users_url(q: params[:q], page: params[:page]), notice: 'Employee type task user was successfully created.' }
        format.json { render action: 'show', status: :created, location: employee_type_task_user_url(@employee_type_task_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee_type_task_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_type_task_users/1
  # PATCH/PUT /employee_type_task_users/1.json
  def update
    authorize! params[:button].to_sym, @employee_type_task_user if @employee_type_task_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:employee_type_task_user].nil? || @employee_type_task_user.update(employee_type_task_user_params)) && (!@employee_type_task_user.respond_to?(:current_state) || @employee_type_task_user.process_event!(params[:button]))
        format.html { redirect_to employee_type_task_users_url(q: params[:q], page: params[:page]), notice: 'Employee type task user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @employee_type_task_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_type_task_users/1
  # DELETE /employee_type_task_users/1.json
  def destroy
    if params[:id]
      if (!@employee_type_task_user.respond_to?(:current_state) || !@employee_type_task_user.current_state.meta[:no_destroy]) &&
        (EmployeeTypeTaskUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @employee_type_task_user.send(r.name).count}.sum == 0)
        @employee_type_task_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EmployeeTypeTaskUser
      EmployeeTypeTaskUser.where(id: params[:ids]).each do |employee_type_task_user|
        if can?(:destroy, employee_type_task_user) &&
          (!employee_type_task_user.respond_to?(:current_state) || !employee_type_task_user.current_state.meta[:no_destroy]) &&
          (EmployeeTypeTaskUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| employee_type_task_user.send(r.name).count}.sum == 0)
          employee_type_task_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to employee_type_task_users_url(q: params[:q], page: params[:page]), notice: 'Employee type task user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_type_task_user
      @employee_type_task_user = EmployeeTypeTaskUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_type_task_user_params
      params.require(:employee_type_task_user).permit(:workflow_state, :workflow_state_updater_id, :employee_type_task_id, :user_id, :evaluation_id, :committee_id, :role, :weight, :score, :score_real)
    end

    def default_layout
      "orb"
    end
    
end
