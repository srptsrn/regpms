class Settings::PoliciesController < SettingsController
  load_and_authorize_resource :class => "Policy"

  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  # GET /settings/policies
  # GET /settings/policies.json
  def index
    if params[:q].blank?
      code_year = (Date.current.mon >= 10 ? Date.current.year + 1 : Date.current.year) + 543 - 2500
      params[:q] = {}
      params[:q][:code_start] = code_year
      params[:q][:workflow_state_in] = Policy.active_states.join(",")
    end if Policy.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Policy.respond_to?(:workflow_spec)
    @q = Policy.limit(params[:limit]).search(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @policies = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/policies/1
  # GET /settings/policies/1.json
  def show
  end

  # GET /settings/policies/new
  def new
    @policy = Policy.new
    render layout: !request.xhr?
  end

  # GET /settings/policies/1/edit
  def edit
  end

  # POST /settings/policies
  # POST /settings/policies.json
  def create
    @policy = Policy.new(policy_params)
    authorize! params[:button].to_sym, @policy if @policy.respond_to?(:current_state)

    respond_to do |format|
      if @policy.save && (!@policy.respond_to?(:current_state) || @policy.process_event!(params[:button]))
        format.html { redirect_to settings_policies_url(q: params[:q], page: params[:page]), notice: 'Policy was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_policy_url(@policy) }
      else
        format.html { render action: 'new' }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/policies/1
  # PATCH/PUT /settings/policies/1.json
  def update
    authorize! params[:button].to_sym, @policy if @policy.respond_to?(:current_state)

    respond_to do |format|
      if (params[:policy].nil? || @policy.update(policy_params)) && (!@policy.respond_to?(:current_state) || @policy.process_event!(params[:button]))
        format.html { redirect_to settings_policies_url(q: params[:q], page: params[:page]), notice: 'Policy was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/policies/1
  # DELETE /settings/policies/1.json
  def destroy
    if params[:id]
      if (!@policy.respond_to?(:current_state) || !@policy.current_state.meta[:no_destroy]) &&
        (Policy.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @policy.send(r.name).count}.sum == 0)
        @policy.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Policy
      Policy.where(id: params[:ids]).each do |policy|
        if can?(:destroy, policy) &&
          (!policy.respond_to?(:current_state) || !policy.current_state.meta[:no_destroy]) &&
          (Policy.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| policy.send(r.name).count}.sum == 0)
          policy.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_policies_url(q: params[:q], page: params[:page]), notice: 'Policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:workflow_state, :workflow_state_updater_id, :policy_id, :code, :name)
    end

    def default_layout
      "orb"
    end
    
end
