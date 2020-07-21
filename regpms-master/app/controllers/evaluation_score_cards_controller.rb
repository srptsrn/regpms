class EvaluationScoreCardsController < OrbController
  load_and_authorize_resource :class => "EvaluationScoreCard"

  before_action :ibattz
  before_action :set_evaluation_score_card, only: [:show, :edit, :update, :destroy]

  # GET /evaluation_score_cards
  # GET /evaluation_score_cards.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EvaluationScoreCard.active_states.join(",")
    end if EvaluationScoreCard.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EvaluationScoreCard.respond_to?(:workflow_spec)
    @q = EvaluationScoreCard.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @evaluation_score_cards = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /evaluation_score_cards/1
  # GET /evaluation_score_cards/1.json
  def show
  end

  # GET /evaluation_score_cards/new
  def new
    @evaluation_score_card = EvaluationScoreCard.new
    render layout: !request.xhr?
  end

  # GET /evaluation_score_cards/1/edit
  def edit
  end

  # POST /evaluation_score_cards
  # POST /evaluation_score_cards.json
  def create
    @evaluation_score_card = EvaluationScoreCard.new(evaluation_score_card_params)
    authorize! params[:button].to_sym, @evaluation_score_card if @evaluation_score_card.respond_to?(:current_state)

    respond_to do |format|
      if @evaluation_score_card.save && (!@evaluation_score_card.respond_to?(:current_state) || @evaluation_score_card.process_event!(params[:button]))
        format.html { redirect_to evaluation_score_cards_url(q: params[:q], page: params[:page]), notice: 'Evaluation score card was successfully created.' }
        format.json { render action: 'show', status: :created, location: evaluation_score_card_url(@evaluation_score_card) }
      else
        format.html { render action: 'new' }
        format.json { render json: @evaluation_score_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluation_score_cards/1
  # PATCH/PUT /evaluation_score_cards/1.json
  def update
    authorize! params[:button].to_sym, @evaluation_score_card if @evaluation_score_card.respond_to?(:current_state)

    respond_to do |format|
      if (params[:evaluation_score_card].nil? || @evaluation_score_card.update(evaluation_score_card_params)) && (!@evaluation_score_card.respond_to?(:current_state) || @evaluation_score_card.process_event!(params[:button]))
        format.html { redirect_to evaluation_score_cards_url(q: params[:q], page: params[:page]), notice: 'Evaluation score card was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @evaluation_score_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluation_score_cards/1
  # DELETE /evaluation_score_cards/1.json
  def destroy
    if params[:id]
      if (!@evaluation_score_card.respond_to?(:current_state) || !@evaluation_score_card.current_state.meta[:no_destroy]) &&
        (EvaluationScoreCard.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @evaluation_score_card.send(r.name).count}.sum == 0)
        @evaluation_score_card.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EvaluationScoreCard
      EvaluationScoreCard.where(id: params[:ids]).each do |evaluation_score_card|
        if can?(:destroy, evaluation_score_card) &&
          (!evaluation_score_card.respond_to?(:current_state) || !evaluation_score_card.current_state.meta[:no_destroy]) &&
          (EvaluationScoreCard.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| evaluation_score_card.send(r.name).count}.sum == 0)
          evaluation_score_card.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to evaluation_score_cards_url(q: params[:q], page: params[:page]), notice: 'Evaluation score card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation_score_card
      @evaluation_score_card = EvaluationScoreCard.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_score_card_params
      params.require(:evaluation_score_card).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :user_id, :committee_id, :role, :task_score, :ability_score)
    end

    def default_layout
      "orb"
    end
    
    def ibattz
      unless current_user.authorized_as?(:ibattz)
        redirect_to root_url
        return false
      end
    end
    
end
