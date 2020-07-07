class Settings::EvaluationEmployeeTypesController < SettingsController
  load_and_authorize_resource :class => "EvaluationEmployeeType"

  before_action :set_evaluation_employee_type, only: [:show, :edit, :update, :destroy]

  # GET /settings/evaluation_employee_types
  # GET /settings/evaluation_employee_types.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationEmployeeType.active_states.join(",")
    end if EvaluationEmployeeType.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationEmployeeType.respond_to?(:workflow_spec)
    @q = EvaluationEmployeeType.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_employee_types = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/evaluation_employee_types/1
  # GET /settings/evaluation_employee_types/1.json
  def show
  end

  # GET /settings/evaluation_employee_types/new
  def new
    @evaluation_employee_type = EvaluationEmployeeType.new
    render layout: !request.xhr?
  end

  # GET /settings/evaluation_employee_types/1/edit
  def edit
  end

  # POST /settings/evaluation_employee_types
  # POST /settings/evaluation_employee_types.json
  def create
    @evaluation_employee_type = EvaluationEmployeeType.new(evaluation_employee_type_params)
    authorize! params[:button].to_sym, @evaluation_employee_type if @evaluation_employee_type.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_employee_type.save && (!@evaluation_employee_type.respond_to?(:current_state) || @evaluation_employee_type.process_event!(params[:button]))
        format.html { redirect_to settings_evaluation_employee_types_url(q: params[:q], page: params[:page]), notice: 'Evaluation employee type was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_evaluation_employee_type_url(@evaluation_employee_type) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/evaluation_employee_types/1
  # PATCH/PUT /settings/evaluation_employee_types/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_employee_type if @evaluation_employee_type.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_employee_type].nil? || @evaluation_employee_type.update(evaluation_employee_type_params)) && (!@evaluation_employee_type.respond_to?(:current_state) || @evaluation_employee_type.process_event!(params[:button]))
        format.html { redirect_to settings_evaluation_employee_types_url(q: params[:q], page: params[:page]), notice: 'Evaluation employee type was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/evaluation_employee_types/1
  # DELETE /settings/evaluation_employee_types/1.json
  def destroy
    if params[:id]
      if (!@evaluation_employee_type.respond_to?(:current_state) || !@evaluation_employee_type.current_state.meta[:no_destroy]) &&
        (EvaluationEmployeeType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_employee_type.send(r.name).count}.sum == 0)
        @evaluation_employee_type.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationEmployeeType
      EvaluationEmployeeType.where(id: params[:ids]).each do |evaluation_employee_type|
        if can?(:destroy, evaluation_employee_type) &&
          (!evaluation_employee_type.respond_to?(:current_state) || !evaluation_employee_type.current_state.meta[:no_destroy]) &&
          (EvaluationEmployeeType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_employee_type.send(r.name).count}.sum == 0)
          evaluation_employee_type.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_evaluation_employee_types_url(q: params[:q], page: params[:page]), notice: 'Evaluation employee type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_employee_type
      @evaluation_employee_type = EvaluationEmployeeType.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_employee_type_params
      params.require(:evaluation_employee_type).permit(:workflow_state, :workflow_state_updater_id, :employee_type_id, :evaluation_id, :leader_ratio, :committee_ratio, :task_ratio, :ability_ratio)
    end

    def default_layout
      "orb"
    end
    
end
