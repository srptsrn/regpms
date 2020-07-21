class Settings::CommitteesController < SettingsController
  load_and_authorize_resource :class => "Committee"

  before_action :set_committee, only: [:show, :edit, :update, :destroy]

  # GET /settings/committees
  # GET /settings/committees.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Committee.active_states.join(",")
    end if Committee.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Committee.respond_to?(:workflow_spec)
    @q = Committee.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @committees = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/committees/1
  # GET /settings/committees/1.json
  def show
  end

  # GET /settings/committees/new
  def new
    @committee = Committee.new
    render layout: !request.xhr?
  end

  # GET /settings/committees/1/edit
  def edit
  end

  # POST /settings/committees
  # POST /settings/committees.json
  def create
    @committee = Committee.new(committee_params)
    authorize! params[:button].to_sym, @committee if @committee.respond_to?(:current_state)

    respond_to do |format|
      if @committee.save && (!@committee.respond_to?(:current_state) || @committee.process_event!(params[:button]))
        format.html { redirect_to settings_committees_url(q: params[:q], page: params[:page]), notice: 'Committee was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_committee_url(@committee) }
      else
        format.html { render action: 'new' }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/committees/1
  # PATCH/PUT /settings/committees/1.json
  def update
    authorize! params[:button].to_sym, @committee if @committee.respond_to?(:current_state)

    respond_to do |format|
      if (params[:committee].nil? || @committee.update(committee_params)) && (!@committee.respond_to?(:current_state) || @committee.process_event!(params[:button]))
        format.html { redirect_to settings_committees_url(q: params[:q], page: params[:page]), notice: 'Committee was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @committee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/committees/1
  # DELETE /settings/committees/1.json
  def destroy
    if params[:id]
      if (!@committee.respond_to?(:current_state) || !@committee.current_state.meta[:no_destroy]) &&
        (Committee.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @committee.send(r.name).count}.sum == 0)
        @committee.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Committee
      Committee.where(id: params[:ids]).each do |committee|
        if can?(:destroy, committee) &&
          (!committee.respond_to?(:current_state) || !committee.current_state.meta[:no_destroy]) &&
          (Committee.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| committee.send(r.name).count}.sum == 0)
          committee.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_committees_url(q: params[:q], page: params[:page]), notice: 'Committee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_committee
      @committee = Committee.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def committee_params
      params.require(:committee).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :user_id)
    end

    def default_layout
      "orb"
    end
    
end
