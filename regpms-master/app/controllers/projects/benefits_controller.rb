class Projects::BenefitsController < OrbController
  load_and_authorize_resource :class => "Benefit"

  before_action :set_benefit, only: [:show, :edit, :update, :destroy]

  # GET /projects/benefits
  # GET /projects/benefits.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Benefit.active_states.join(",")
    end if Benefit.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Benefit.respond_to?(:workflow_spec)
    @q = Benefit.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @benefits = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/benefits/1
  # GET /projects/benefits/1.json
  def show
  end

  # GET /projects/benefits/new
  def new
    @benefit = Benefit.new
    render layout: !request.xhr?
  end

  # GET /projects/benefits/1/edit
  def edit
  end

  # POST /projects/benefits
  # POST /projects/benefits.json
  def create
    @benefit = Benefit.new(benefit_params)
    authorize! params[:button].to_sym, @benefit if @benefit.respond_to?(:current_state)

    respond_to do |format|
      if @benefit.save && (!@benefit.respond_to?(:current_state) || @benefit.process_event!(params[:button]))
        format.html { redirect_to projects_benefits_url(q: params[:q], page: params[:page]), notice: 'Benefit was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_benefit_url(@benefit) }
      else
        format.html { render action: 'new' }
        format.json { render json: @benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/benefits/1
  # PATCH/PUT /projects/benefits/1.json
  def update
    authorize! params[:button].to_sym, @benefit if @benefit.respond_to?(:current_state)

    respond_to do |format|
      if (params[:benefit].nil? || @benefit.update(benefit_params)) && (!@benefit.respond_to?(:current_state) || @benefit.process_event!(params[:button]))
        format.html { redirect_to projects_benefits_url(q: params[:q], page: params[:page]), notice: 'Benefit was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/benefits/1
  # DELETE /projects/benefits/1.json
  def destroy
    if params[:id]
      if (!@benefit.respond_to?(:current_state) || !@benefit.current_state.meta[:no_destroy]) &&
        (Benefit.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @benefit.send(r.name).count}.sum == 0)
        @benefit.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Benefit
      Benefit.where(id: params[:ids]).each do |benefit|
        if can?(:destroy, benefit) &&
          (!benefit.respond_to?(:current_state) || !benefit.current_state.meta[:no_destroy]) &&
          (Benefit.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| benefit.send(r.name).count}.sum == 0)
          benefit.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_benefits_url(q: params[:q], page: params[:page]), notice: 'Benefit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @benefit = Benefit.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def benefit_params
      params.require(:benefit).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :description)
    end

    def default_layout
      "orb"
    end
    
end
