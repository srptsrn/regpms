class EvaluationSalaryUpsController < OrbController
  load_and_authorize_resource :class => "EvaluationSalaryUp"

  before_action :set_evaluation_salary_up, only: [:show, :edit, :update, :destroy]

  # GET /evaluation_salary_ups
  # GET /evaluation_salary_ups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationSalaryUp.active_states.join(",")
    end if EvaluationSalaryUp.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationSalaryUp.respond_to?(:workflow_spec)
    @q = EvaluationSalaryUp.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_salary_ups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /evaluation_salary_ups/1
  # GET /evaluation_salary_ups/1.json
  def show
  end

  # GET /evaluation_salary_ups/new
  def new
    @evaluation_salary_up = EvaluationSalaryUp.new
    render layout: !request.xhr?
  end

  # GET /evaluation_salary_ups/1/edit
  def edit
  end

  # POST /evaluation_salary_ups
  # POST /evaluation_salary_ups.json
  def create
    @evaluation_salary_up = EvaluationSalaryUp.new(evaluation_salary_up_params)
    authorize! params[:button].to_sym, @evaluation_salary_up if @evaluation_salary_up.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_salary_up.save && (!@evaluation_salary_up.respond_to?(:current_state) || @evaluation_salary_up.process_event!(params[:button]))
        format.html { redirect_to evaluation_salary_ups_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up was successfully created.' }
        format.json { render action: 'show', status: :created, location: evaluation_salary_up_url(@evaluation_salary_up) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_salary_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluation_salary_ups/1
  # PATCH/PUT /evaluation_salary_ups/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_salary_up if @evaluation_salary_up.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_salary_up].nil? || @evaluation_salary_up.update(evaluation_salary_up_params)) && (!@evaluation_salary_up.respond_to?(:current_state) || @evaluation_salary_up.process_event!(params[:button]))
        format.html { redirect_to evaluation_salary_ups_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_salary_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluation_salary_ups/1
  # DELETE /evaluation_salary_ups/1.json
  def destroy
    if params[:id]
      if (!@evaluation_salary_up.respond_to?(:current_state) || !@evaluation_salary_up.current_state.meta[:no_destroy]) &&
        (EvaluationSalaryUp.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_salary_up.send(r.name).count}.sum == 0)
        @evaluation_salary_up.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationSalaryUp
      EvaluationSalaryUp.where(id: params[:ids]).each do |evaluation_salary_up|
        if can?(:destroy, evaluation_salary_up) &&
          (!evaluation_salary_up.respond_to?(:current_state) || !evaluation_salary_up.current_state.meta[:no_destroy]) &&
          (EvaluationSalaryUp.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_salary_up.send(r.name).count}.sum == 0)
          evaluation_salary_up.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to evaluation_salary_ups_url(q: params[:q], page: params[:page]), notice: 'Evaluation salary up was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_salary_up
      @evaluation_salary_up = EvaluationSalaryUp.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_salary_up_params
      params.require(:evaluation_salary_up).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :percent_of_change, :total_amount, :total_eligible_amount, :point_level1, :point_level2, :point_level3, :point_level4, :point_level5, :min_change1, :min_change2, :min_change3, :min_change4, :min_change5, :max_change1, :max_change2, :max_change3, :max_change4, :max_change5)
    end

    def default_layout
      "orb"
    end
    
end
