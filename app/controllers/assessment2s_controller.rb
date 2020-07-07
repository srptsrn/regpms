class Assessment2sController < OrbController
  load_and_authorize_resource :class => "Assessment2"

  before_action :set_assessment2, only: [:show, :edit, :update, :destroy]

  # GET /assessment2s
  # GET /assessment2s.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Assessment2.active_states.join(",")
    end if Assessment2.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Assessment2.respond_to?(:workflow_spec)
    @q = Assessment2.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @assessment2s = request.format.html? ? @q.result.includes(:user, :evaluation, :committee).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:user, :evaluation, :committee)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /assessment2s/1
  # GET /assessment2s/1.json
  def show
  end

  # GET /assessment2s/new
  def new
    @assessment2 = Assessment2.new(user_id: params[:user_id], evaluation_id: (@current_evaluation ? @current_evaluation.id : nil), committee_id: current_user.id)
    render layout: !request.xhr?
  end

  # GET /assessment2s/1/edit
  def edit
  end

  # POST /assessment2s
  # POST /assessment2s.json
  def create
    @assessment2 = Assessment2.new(assessment2_params)
    authorize! params[:button].to_sym, @assessment2 if @assessment2.respond_to?(:current_state)

    respond_to do |format|
      if @assessment2.save && (!@assessment2.respond_to?(:current_state) || @assessment2.process_event!(params[:button]))
        if false 
          format.html { redirect_to assessment2s_url(q: params[:q], page: params[:page]), notice: 'Assessment2 was successfully created.' }
        else
          format.html { redirect_to dashboards_url(q: params[:q], page: params[:page]), notice: 'Assessment2 was successfully created.' }
        end
        format.json { render action: 'show', status: :created, location: assessment2_url(@assessment2) }
      else
        format.html { render action: 'new' }
        format.json { render json: @assessment2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assessment2s/1
  # PATCH/PUT /assessment2s/1.json
  def update
    authorize! params[:button].to_sym, @assessment2 if @assessment2.respond_to?(:current_state)

    respond_to do |format|
      if (params[:assessment2].nil? || @assessment2.update(assessment2_params)) && (!@assessment2.respond_to?(:current_state) || @assessment2.process_event!(params[:button]))
        if false
          format.html { redirect_to assessment2s_url(q: params[:q], page: params[:page]), notice: 'Assessment2 was successfully updated.' }
        else
          format.html { redirect_to dashboards_url(q: params[:q], page: params[:page]), notice: 'Assessment2 was successfully updated.' }
        end
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @assessment2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessment2s/1
  # DELETE /assessment2s/1.json
  def destroy
    if params[:id]
      if (!@assessment2.respond_to?(:current_state) || !@assessment2.current_state.meta[:no_destroy]) &&
        (Assessment2.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @assessment2.send(r.name).count}.sum == 0)
        @assessment2.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Assessment2
      Assessment2.where(id: params[:ids]).each do |assessment2|
        if can?(:destroy, assessment2) &&
          (!assessment2.respond_to?(:current_state) || !assessment2.current_state.meta[:no_destroy]) &&
          (Assessment2.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| assessment2.send(r.name).count}.sum == 0)
          assessment2.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to assessment2s_url(q: params[:q], page: params[:page]), notice: 'Assessment2 was successfully destroyed.' }
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
    def set_assessment2
      @assessment2 = Assessment2.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment2_params
      params.require(:assessment2).permit(:workflow_state, :workflow_state_updater_id, :user_id, :evaluation_id, :committee_id, :role, :score111, :score112, :score113, :score114, :score121, :score122, :score123, :score124, :score211, :score212, :score213, :score214, :score215, :score221, :score222, :score223, :score224, :comment1, :comment2)
    end

    def default_layout
      "orb"
    end
    
end
