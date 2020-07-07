class AssessmentsController < OrbController
  load_and_authorize_resource :class => "Assessment"

  before_action :set_assessment, only: [:show, :edit, :update, :destroy]

  # GET /assessments
  # GET /assessments.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Assessment.active_states.join(",")
    end if Assessment.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Assessment.respond_to?(:workflow_spec)
    @q = Assessment.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @assessments = request.format.html? ? @q.result.includes(:user, :evaluaion, :committee).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:user, :evaluaion, :committee)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /assessments/1
  # GET /assessments/1.json
  def show
  end

  # GET /assessments/new
  def new
    @assessment = Assessment.new(user_id: params[:user_id], evaluation_id: (@current_evaluation ? @current_evaluation.id : nil), committee_id: current_user.id)
    render layout: !request.xhr?
  end

  # GET /assessments/1/edit
  def edit
  end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = Assessment.new(assessment_params)
    authorize! params[:button].to_sym, @assessment if @assessment.respond_to?(:current_state)

    respond_to do |format|
      if @assessment.save && (!@assessment.respond_to?(:current_state) || @assessment.process_event!(params[:button]))
        if false
          format.html { redirect_to assessments_url(q: params[:q], page: params[:page]), notice: 'Assessment was successfully created.' }
        else
          format.html { redirect_to dashboards_url(q: params[:q], page: params[:page]), notice: 'Assessment was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: assessment_url(@assessment) }
      else
        format.html { render action: 'new' }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assessments/1
  # PATCH/PUT /assessments/1.json
  def update
    authorize! params[:button].to_sym, @assessment if @assessment.respond_to?(:current_state)

    respond_to do |format|
      if (params[:assessment].nil? || @assessment.update(assessment_params)) && (!@assessment.respond_to?(:current_state) || @assessment.process_event!(params[:button]))
        if false
          format.html { redirect_to assessments_url(q: params[:q], page: params[:page]), notice: 'Assessment was successfully updated.' }
        else
          format.html { redirect_to dashboards_url(q: params[:q], page: params[:page]), notice: 'Assessment was successfully updated.' }
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    if params[:id]
      if (!@assessment.respond_to?(:current_state) || !@assessment.current_state.meta[:no_destroy]) &&
        (Assessment.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @assessment.send(r.name).count}.sum == 0)
        @assessment.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Assessment
      Assessment.where(id: params[:ids]).each do |assessment|
        if can?(:destroy, assessment) &&
          (!assessment.respond_to?(:current_state) || !assessment.current_state.meta[:no_destroy]) &&
          (Assessment.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| assessment.send(r.name).count}.sum == 0)
          assessment.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to assessments_url(q: params[:q], page: params[:page]), notice: 'Assessment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def chose_user
    @user = User.find(params[:user_id]) if !params[:user_id].blank?

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment
      @assessment = Assessment.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_params
      params.require(:assessment).permit(:workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :score111, :score112, :score113, :score114, :score211, :score212, :score213, :score214, :score215, :score221, :score222, :score223, :score224, :score225, :score226, :comment1, :comment2)
    end

    def default_layout
      "orb"
    end
    
end
