class Settings::EvaluationPrinciplesController < SettingsController
  load_and_authorize_resource :class => "EvaluationPrinciple"

  before_action :set_evaluation_principle, only: [:show, :edit, :update, :destroy]

  # GET /settings/evaluation_principles
  # GET /settings/evaluation_principles.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationPrinciple.active_states.join(",")
    end if EvaluationPrinciple.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationPrinciple.respond_to?(:workflow_spec)
    @q = EvaluationPrinciple.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_principles = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/evaluation_principles/1
  # GET /settings/evaluation_principles/1.json
  def show
  end

  # GET /settings/evaluation_principles/new
  def new
    @evaluation_principle = EvaluationPrinciple.new
    render layout: !request.xhr?
  end

  # GET /settings/evaluation_principles/1/edit
  def edit
  end

  # POST /settings/evaluation_principles
  # POST /settings/evaluation_principles.json
  def create
    @evaluation_principle = EvaluationPrinciple.new(evaluation_principle_params)
    authorize! params[:button].to_sym, @evaluation_principle if @evaluation_principle.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_principle.save && (!@evaluation_principle.respond_to?(:current_state) || @evaluation_principle.process_event!(params[:button]))
        format.html { redirect_to settings_evaluation_principles_url(q: params[:q], page: params[:page]), notice: 'Evaluation principle was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_evaluation_principle_url(@evaluation_principle) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_principle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/evaluation_principles/1
  # PATCH/PUT /settings/evaluation_principles/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_principle if @evaluation_principle.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_principle].nil? || @evaluation_principle.update(evaluation_principle_params)) && (!@evaluation_principle.respond_to?(:current_state) || @evaluation_principle.process_event!(params[:button]))
        format.html { redirect_to settings_evaluation_principles_url(q: params[:q], page: params[:page]), notice: 'Evaluation principle was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_principle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/evaluation_principles/1
  # DELETE /settings/evaluation_principles/1.json
  def destroy
    if params[:id]
      if (!@evaluation_principle.respond_to?(:current_state) || !@evaluation_principle.current_state.meta[:no_destroy]) &&
        (EvaluationPrinciple.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_principle.send(r.name).count}.sum == 0)
        @evaluation_principle.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationPrinciple
      EvaluationPrinciple.where(id: params[:ids]).each do |evaluation_principle|
        if can?(:destroy, evaluation_principle) &&
          (!evaluation_principle.respond_to?(:current_state) || !evaluation_principle.current_state.meta[:no_destroy]) &&
          (EvaluationPrinciple.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_principle.send(r.name).count}.sum == 0)
          evaluation_principle.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_evaluation_principles_url(q: params[:q], page: params[:page]), notice: 'Evaluation principle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_principle
      @evaluation_principle = EvaluationPrinciple.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_principle_params
      params.require(:evaluation_principle).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :task_id, :principle1, :principle2, :principle3, :principle4, :principle5)
    end

    def default_layout
      "orb"
    end
    
end
