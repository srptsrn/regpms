class Projects::ResponsiblesController < OrbController
  load_and_authorize_resource :class => "Responsible"

  before_action :set_responsible, only: [:show, :edit, :update, :destroy]

  # GET /projects/responsibles
  # GET /projects/responsibles.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = Responsible.active_states.join(",")
    end if Responsible.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if Responsible.respond_to?(:workflow_spec)
    @q = Responsible.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @responsibles = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /projects/responsibles/1
  # GET /projects/responsibles/1.json
  def show
  end

  # GET /projects/responsibles/new
  def new
    @responsible = Responsible.new
    render layout: !request.xhr?
  end

  # GET /projects/responsibles/1/edit
  def edit
  end

  # POST /projects/responsibles
  # POST /projects/responsibles.json
  def create
    @responsible = Responsible.new(responsible_params)
    authorize! params[:button].to_sym, @responsible if @responsible.respond_to?(:current_state)

    respond_to do |format|
      if @responsible.save && (!@responsible.respond_to?(:current_state) || @responsible.process_event!(params[:button]))
        format.html { redirect_to projects_responsibles_url(q: params[:q], page: params[:page]), notice: 'Responsible was successfully created.' }
        format.json { render action: 'show', status: :created, location: projects_responsible_url(@responsible) }
      else
        format.html { render action: 'new' }
        format.json { render json: @responsible.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/responsibles/1
  # PATCH/PUT /projects/responsibles/1.json
  def update
    authorize! params[:button].to_sym, @responsible if @responsible.respond_to?(:current_state)

    respond_to do |format|
      if (params[:responsible].nil? || @responsible.update(responsible_params)) && (!@responsible.respond_to?(:current_state) || @responsible.process_event!(params[:button]))
        format.html { redirect_to projects_responsibles_url(q: params[:q], page: params[:page]), notice: 'Responsible was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @responsible.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/responsibles/1
  # DELETE /projects/responsibles/1.json
  def destroy
    if params[:id]
      if (!@responsible.respond_to?(:current_state) || !@responsible.current_state.meta[:no_destroy]) &&
        (Responsible.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @responsible.send(r.name).count}.sum == 0)
        @responsible.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, Responsible
      Responsible.where(id: params[:ids]).each do |responsible|
        if can?(:destroy, responsible) &&
          (!responsible.respond_to?(:current_state) || !responsible.current_state.meta[:no_destroy]) &&
          (Responsible.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| responsible.send(r.name).count}.sum == 0)
          responsible.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_responsibles_url(q: params[:q], page: params[:page]), notice: 'Responsible was successfully destroyed.' }
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
    def set_responsible
      @responsible = Responsible.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def responsible_params
      params.require(:responsible).permit(:workflow_state, :workflow_state_updater_id, :project_id, :sorting, :user_id, :prefix, :firstname, :lastname, :position)
    end

    def default_layout
      "orb"
    end
    
end
