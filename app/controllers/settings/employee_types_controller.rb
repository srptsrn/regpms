class Settings::EmployeeTypesController < SettingsController
  load_and_authorize_resource :class => "EmployeeType"

  before_action :set_employee_type, only: [:show, :edit, :update, :destroy]

  # GET /settings/employee_types
  # GET /settings/employee_types.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EmployeeType.active_states.join(",")
    end if EmployeeType.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EmployeeType.respond_to?(:workflow_spec)
    @q = EmployeeType.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @employee_types = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/employee_types/1
  # GET /settings/employee_types/1.json
  def show
  end

  # GET /settings/employee_types/new
  def new
    @employee_type = EmployeeType.new
    render layout: !request.xhr?
  end

  # GET /settings/employee_types/1/edit
  def edit
  end

  # POST /settings/employee_types
  # POST /settings/employee_types.json
  def create
    @employee_type = EmployeeType.new(employee_type_params)
    authorize! params[:button].to_sym, @employee_type if @employee_type.respond_to?(:current_state)

    respond_to do |format|
      if @employee_type.save && (!@employee_type.respond_to?(:current_state) || @employee_type.process_event!(params[:button]))
        format.html { redirect_to settings_employee_types_url(q: params[:q], page: params[:page]), notice: 'Employee type was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_employee_type_url(@employee_type) }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/employee_types/1
  # PATCH/PUT /settings/employee_types/1.json
  def update
    authorize! params[:button].to_sym, @employee_type if @employee_type.respond_to?(:current_state)

    respond_to do |format|
      if (params[:employee_type].nil? || @employee_type.update(employee_type_params)) && (!@employee_type.respond_to?(:current_state) || @employee_type.process_event!(params[:button]))
        format.html { redirect_to settings_employee_types_url(q: params[:q], page: params[:page]), notice: 'Employee type was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/employee_types/1
  # DELETE /settings/employee_types/1.json
  def destroy
    if params[:id]
      if (!@employee_type.respond_to?(:current_state) || !@employee_type.current_state.meta[:no_destroy]) &&
        (EmployeeType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @employee_type.send(r.name).count}.sum == 0)
        @employee_type.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EmployeeType
      EmployeeType.where(id: params[:ids]).each do |employee_type|
        if can?(:destroy, employee_type) &&
          (!employee_type.respond_to?(:current_state) || !employee_type.current_state.meta[:no_destroy]) &&
          (EmployeeType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| employee_type.send(r.name).count}.sum == 0)
          employee_type.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_employee_types_url(q: params[:q], page: params[:page]), notice: 'Employee type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_type
      @employee_type = EmployeeType.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_type_params
      params.require(:employee_type).permit(
        :workflow_state, :workflow_state_updater_id, :name, :sorting, 
        employee_type_task_groups_attributes: [
          :id, :sorting, :name, :_destroy, 
          employee_type_tasks_attributes: [:id, :sorting, :task_id, :weight, :_destroy, :criteria1, :criteria2, :criteria3, :criteria4, :criteria5, :min_value]
        ]
      )
    end

    def default_layout
      "orb"
    end
    
end
