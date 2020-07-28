class Settings::EvaluationsController < SettingsController
  load_and_authorize_resource :class => "Evaluation"

  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

  # GET /settings/evaluations
  # GET /settings/evaluations.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Evaluation.active_states.join(",")
    end if Evaluation.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Evaluation.respond_to?(:workflow_spec)
    @q = Evaluation.limit(params[:limit]).search(params[:q])
    @q.sorts = 'year DESC' if @q.sorts.empty?
    @evaluations = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 10) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/evaluations/1
  # GET /settings/evaluations/1.json
  def show
  end

  # GET /settings/evaluations/new
  def new
    @evaluation = Evaluation.new
    
    last_evaluation = Evaluation.limit(1).order("year DESC, episode DESC").first
    if last_evaluation
      
      year = last_evaluation.episode == 1 ? last_evaluation.year : last_evaluation.year + 1
      episode = last_evaluation.episode == 1 ? 2 : 1
      
      if episode == 1
        start_date            = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        end_date              = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
        query_start_date      = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        query_end_date        = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
        pd_start_date         = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        pd_end_date           = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
        pf_start_date         = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        pf_end_date           = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
        confirm_start_date    = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        confirm_end_date      = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
        evaluation_start_date = Date.strptime("01/05/#{year - 543}", "%d/%m/%Y")
        evaluation_end_date   = Date.strptime("31/10/#{year - 543}", "%d/%m/%Y")
      elsif episode == 2
        start_date            = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        end_date              = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
        query_start_date      = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        query_end_date        = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
        pd_start_date         = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        pd_end_date           = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
        pf_start_date         = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        pf_end_date           = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
        confirm_start_date    = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        confirm_end_date      = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
        evaluation_start_date = Date.strptime("01/11/#{year - 543}", "%d/%m/%Y")
        evaluation_end_date   = Date.strptime("30/04/#{year - 543 + 1}", "%d/%m/%Y")
      end
      
      @evaluation.year                  = year
      @evaluation.episode               = episode
      @evaluation.director_id           = last_evaluation.director_id
      @evaluation.vice_director_id      = last_evaluation.vice_director_id
      @evaluation.vice_director2_id     = last_evaluation.vice_director2_id
      @evaluation.vice_director3_id     = last_evaluation.vice_director3_id
      @evaluation.secretary_id          = last_evaluation.secretary_id
      @evaluation.start_date            = start_date
      @evaluation.end_date              = end_date
      @evaluation.query_start_date      = query_start_date
      @evaluation.query_end_date        = query_end_date
      @evaluation.pd_start_date         = pd_start_date
      @evaluation.pd_end_date           = pd_end_date
      @evaluation.pf_start_date         = pf_start_date
      @evaluation.pf_end_date           = pf_end_date
      @evaluation.confirm_start_date    = confirm_start_date
      @evaluation.confirm_end_date      = confirm_end_date
      @evaluation.evaluation_start_date = evaluation_start_date
      @evaluation.evaluation_end_date   = evaluation_end_date
      @evaluation.is_360                = last_evaluation.is_360
      
      last_evaluation.committees.each do |last_committee|
        @evaluation.committees.build(user_id: last_committee.user_id)
      end
      
      last_evaluation.evaluation_employee_types.each do |evaluation_employee_type|
        @evaluation.evaluation_employee_types.build(
          employee_type_id: evaluation_employee_type.employee_type_id, 
          director_ratio: evaluation_employee_type.director_ratio, 
          vice_director_ratio: evaluation_employee_type.vice_director_ratio,
          vice_director2_ratio: evaluation_employee_type.vice_director2_ratio,
          vice_director3_ratio: evaluation_employee_type.vice_director3_ratio,
          secretary_ratio: evaluation_employee_type.secretary_ratio, 
          section_leader_ratio: evaluation_employee_type.section_leader_ratio, 
          section_vice_leader_ratio: evaluation_employee_type.section_vice_leader_ratio, 
          leader_ratio: evaluation_employee_type.leader_ratio, 
          committee_ratio: evaluation_employee_type.committee_ratio, 
          task_ratio: evaluation_employee_type.task_ratio, 
          ability_ratio: evaluation_employee_type.ability_ratio
        )
      end
      
      last_evaluation.evaluation_principles.each do |last_evaluation_principle|
        @evaluation.evaluation_principles.build(task_id: last_evaluation_principle.task_id, principle1: last_evaluation_principle.principle1, principle2: last_evaluation_principle.principle2, principle3: last_evaluation_principle.principle3, principle4: last_evaluation_principle.principle4, principle5: last_evaluation_principle.principle5)
      end
      
    end
    
    render layout: !request.xhr?
  end

  # GET /settings/evaluations/1/edit
  def edit
  end

  # POST /settings/evaluations
  # POST /settings/evaluations.json
  def create
    @evaluation = Evaluation.new(evaluation_params)
    authorize! params[:button].to_sym, @evaluation if @evaluation.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation.save && (!@evaluation.respond_to?(:current_state) || @evaluation.process_event!(params[:button]))
        format.html { redirect_to settings_evaluations_url(q: params[:q], page: params[:page]), notice: 'Evaluation was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_evaluation_url(@evaluation) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/evaluations/1
  # PATCH/PUT /settings/evaluations/1.json
  def update
    authorize! params[:button].to_sym, @evaluation if @evaluation.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation].nil? || @evaluation.update(evaluation_params)) && (!@evaluation.respond_to?(:current_state) || @evaluation.process_event!(params[:button]))
        format.html { redirect_to settings_evaluations_url(q: params[:q], page: params[:page]), notice: 'Evaluation was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/evaluations/1
  # DELETE /settings/evaluations/1.json
  def destroy
    if params[:id]
      if (!@evaluation.respond_to?(:current_state) || !@evaluation.current_state.meta[:no_destroy]) &&
        (Evaluation.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation.send(r.name).count}.sum == 0)
        @evaluation.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Evaluation
      Evaluation.where(id: params[:ids]).each do |evaluation|
        if can?(:destroy, evaluation) &&
          (!evaluation.respond_to?(:current_state) || !evaluation.current_state.meta[:no_destroy]) &&
          (Evaluation.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation.send(r.name).count}.sum == 0)
          evaluation.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_evaluations_url(q: params[:q], page: params[:page]), notice: 'Evaluation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation
      @evaluation = Evaluation.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_params
      params.require(:evaluation).permit(
        :is_360, 
        :workflow_state, :workflow_state_updater_id, :year, :episode, 
        :director_confirm_start_date, :director_confirm_end_date,  
        :start_date, :end_date, 
        :query_start_date, :query_end_date, 
        :pd_start_date, :pd_end_date, 
        :pf_start_date, :pf_end_date, 
        :confirm_start_date, :confirm_end_date, 
        :evaluation_start_date, :evaluation_end_date, 
        :director_id, :vice_director_id, :vice_director2_id, :vice_director3_id, :secretary_id, 
        :is_salary_up, :evaluation1_id, :evaluation2_id, :evaluation3_id, :evaluation4_id, :evaluation5_id, 
        committees_attributes: [:id, :evaluation_id, :user_id, :_destroy], 
        evaluation_employee_types_attributes: [:id, :evaluation_id, :employee_type_id, :leader_ratio, :committee_ratio, :task_ratio, :ability_ratio, :_destroy, :director_ratio, :vice_director_ratio, :vice_director2_ratio, :vice_director3_ratio, :secretary_ratio, :section_leader_ratio, :section_vice_leader_ratio], 
        evaluation_principles_attributes: [:id, :evaluation_id, :task_id, :principle1, :principle2, :principle3, :principle4, :principle5, :_destroy], 
        e360_items_attributes: [:id, :evaluation_id, :sorting, :name, :_destroy], 
        base_salaries_attributes: [:id, :workflow_state, :workflow_state_updater_id, :evaluation_id, :position_level_id, :min_low, :max_low, :base_low, :min_high, :max_high, :base_high, :remark, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
