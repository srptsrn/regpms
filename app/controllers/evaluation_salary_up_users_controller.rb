class EvaluationSalaryUpUsersController < OrbController
  load_and_authorize_resource :class => "EvaluationSalaryUpUser"

  before_action :set_evaluation_salary_up_user, only: [:show, :edit, :update, :destroy]

  # GET /evaluation_salary_up_users
  # GET /evaluation_salary_up_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationSalaryUpUser.active_states.join(",")
    end if EvaluationSalaryUpUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationSalaryUpUser.respond_to?(:workflow_spec)
    @q = EvaluationSalaryUpUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_salary_up_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /evaluation_salary_up_users/1
  # GET /evaluation_salary_up_users/1.json
  def show
  end

  # GET /evaluation_salary_up_users/new
  def new
    @evaluation_salary_up_user = EvaluationSalaryUpUser.new
    render layout: !request.xhr?
  end

  # GET /evaluation_salary_up_users/1/edit
  def edit
  end

  # POST /evaluation_salary_up_users
  # POST /evaluation_salary_up_users.json
  def create
    @evaluation_salary_up_user = EvaluationSalaryUpUser.new(evaluation_salary_up_user_params)
    authorize! params[:button].to_sym, @evaluation_salary_up_user if @evaluation_salary_up_user.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_salary_up_user.save && (!@evaluation_salary_up_user.respond_to?(:current_state) || @evaluation_salary_up_user.process_event!(params[:button]))
        format.html { redirect_to evaluation_salary_up_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up user was successfully created.' }
        format.json { render action: 'show', status: :created, location: evaluation_salary_up_user_url(@evaluation_salary_up_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_salary_up_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluation_salary_up_users/1
  # PATCH/PUT /evaluation_salary_up_users/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_salary_up_user if @evaluation_salary_up_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_salary_up_user].nil? || @evaluation_salary_up_user.update(evaluation_salary_up_user_params)) && (!@evaluation_salary_up_user.respond_to?(:current_state) || @evaluation_salary_up_user.process_event!(params[:button]))
        format.html { redirect_to evaluation_salary_up_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_salary_up_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluation_salary_up_users/1
  # DELETE /evaluation_salary_up_users/1.json
  def destroy
    if params[:id]
      if (!@evaluation_salary_up_user.respond_to?(:current_state) || !@evaluation_salary_up_user.current_state.meta[:no_destroy]) &&
        (EvaluationSalaryUpUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_salary_up_user.send(r.name).count}.sum == 0)
        @evaluation_salary_up_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationSalaryUpUser
      EvaluationSalaryUpUser.where(id: params[:ids]).each do |evaluation_salary_up_user|
        if can?(:destroy, evaluation_salary_up_user) &&
          (!evaluation_salary_up_user.respond_to?(:current_state) || !evaluation_salary_up_user.current_state.meta[:no_destroy]) &&
          (EvaluationSalaryUpUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_salary_up_user.send(r.name).count}.sum == 0)
          evaluation_salary_up_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to evaluation_salary_up_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_salary_up_user
      @evaluation_salary_up_user = EvaluationSalaryUpUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_salary_up_user_params
      params.require(:evaluation_salary_up_user).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :evaluation_salary_up_id, :user_id, :position_level_id, :salary, :base_salary, :base_salary_min, :base_salary_max, :is_eligible, :is_work_hour_passed, :lost_count, :late_count, :leave_count, :point, :percent_of_min_up, :salary_min_up, :percent_of_up, :salary_up)
    end

    def default_layout
      "orb"
    end
    
end
