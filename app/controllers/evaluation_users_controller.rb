class EvaluationUsersController < OrbController
  load_and_authorize_resource :class => "EvaluationUser"

  before_action :set_evaluation_user, only: [:show, :edit, :update, :destroy]

  # GET /evaluation_users
  # GET /evaluation_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationUser.active_states.join(",")
    end if EvaluationUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationUser.respond_to?(:workflow_spec)
    @q = EvaluationUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /evaluation_users/1
  # GET /evaluation_users/1.json
  def show
  end

  # GET /evaluation_users/new
  def new
    @evaluation_user = EvaluationUser.new
    render layout: !request.xhr?
  end

  # GET /evaluation_users/1/edit
  def edit
  end

  # POST /evaluation_users
  # POST /evaluation_users.json
  def create
    @evaluation_user = EvaluationUser.new(evaluation_user_params)
    authorize! params[:button].to_sym, @evaluation_user if @evaluation_user.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_user.save && (!@evaluation_user.respond_to?(:current_state) || @evaluation_user.process_event!(params[:button]))
        format.html { redirect_to evaluation_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation user was successfully created.' }
        format.json { render action: 'show', status: :created, location: evaluation_user_url(@evaluation_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluation_users/1
  # PATCH/PUT /evaluation_users/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_user if @evaluation_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_user].nil? || @evaluation_user.update(evaluation_user_params)) && (!@evaluation_user.respond_to?(:current_state) || @evaluation_user.process_event!(params[:button]))
        if params[:xform]
          format.html { redirect_to assess_url(@evaluation_user.role, section_id: params[:section_id], team_id: params[:team_id], faculty_id: params[:faculty_id]) }
        else
          format.html { redirect_to evaluation_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation user was successfully updated.' }
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluation_users/1
  # DELETE /evaluation_users/1.json
  def destroy
    if params[:id]
      if (!@evaluation_user.respond_to?(:current_state) || !@evaluation_user.current_state.meta[:no_destroy]) &&
        (EvaluationUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_user.send(r.name).count}.sum == 0)
        @evaluation_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationUser
      EvaluationUser.where(id: params[:ids]).each do |evaluation_user|
        if can?(:destroy, evaluation_user) &&
          (!evaluation_user.respond_to?(:current_state) || !evaluation_user.current_state.meta[:no_destroy]) &&
          (EvaluationUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_user.send(r.name).count}.sum == 0)
          evaluation_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to evaluation_users_url(q: params[:q], page: params[:page]), notice: 'Evaluation user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_user
      @evaluation_user = EvaluationUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_user_params
      params.require(:evaluation_user).permit(:workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :comment1, :comment2, :position_capacity_total, :employee_type_task_total)
    end

    def default_layout
      "orb"
    end
    
end
