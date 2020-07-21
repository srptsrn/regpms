class EdpexKkuGroupsController < OrbController
  load_and_authorize_resource :class => "EdpexKkuGroup"

  before_action :set_edpex_kku_group, only: [:show, :edit, :update, :destroy]

  # GET /edpex_kku_groups
  # GET /edpex_kku_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EdpexKkuGroup.active_states.join(",")
    end if EdpexKkuGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EdpexKkuGroup.respond_to?(:workflow_spec)
    @q = EdpexKkuGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @edpex_kku_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /edpex_kku_groups/1
  # GET /edpex_kku_groups/1.json
  def show
  end

  # GET /edpex_kku_groups/new
  def new
    @edpex_kku_group = EdpexKkuGroup.new
    render layout: !request.xhr?
  end

  # GET /edpex_kku_groups/1/edit
  def edit
  end

  # POST /edpex_kku_groups
  # POST /edpex_kku_groups.json
  def create
    @edpex_kku_group = EdpexKkuGroup.new(edpex_kku_group_params)
    authorize! params[:button].to_sym, @edpex_kku_group if @edpex_kku_group.respond_to?(:current_state)

    respond_to do |format|
      if @edpex_kku_group.save && (!@edpex_kku_group.respond_to?(:current_state) || @edpex_kku_group.process_event!(params[:button]))
        format.html { redirect_to edpex_kku_groups_url(q: params[:q], page: params[:page]), notice: 'Edpex kku group was successfully created.' }
        format.json { render action: 'show', status: :created, location: edpex_kku_group_url(@edpex_kku_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @edpex_kku_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edpex_kku_groups/1
  # PATCH/PUT /edpex_kku_groups/1.json
  def update
    authorize! params[:button].to_sym, @edpex_kku_group if @edpex_kku_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:edpex_kku_group].nil? || @edpex_kku_group.update(edpex_kku_group_params)) && (!@edpex_kku_group.respond_to?(:current_state) || @edpex_kku_group.process_event!(params[:button]))
        format.html { redirect_to edpex_kku_groups_url(q: params[:q], page: params[:page]), notice: 'Edpex kku group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @edpex_kku_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edpex_kku_groups/1
  # DELETE /edpex_kku_groups/1.json
  def destroy
    if params[:id]
      if (!@edpex_kku_group.respond_to?(:current_state) || !@edpex_kku_group.current_state.meta[:no_destroy]) &&
        (EdpexKkuGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @edpex_kku_group.send(r.name).count}.sum == 0)
        @edpex_kku_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EdpexKkuGroup
      EdpexKkuGroup.where(id: params[:ids]).each do |edpex_kku_group|
        if can?(:destroy, edpex_kku_group) &&
          (!edpex_kku_group.respond_to?(:current_state) || !edpex_kku_group.current_state.meta[:no_destroy]) &&
          (EdpexKkuGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| edpex_kku_group.send(r.name).count}.sum == 0)
          edpex_kku_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to edpex_kku_groups_url(q: params[:q], page: params[:page]), notice: 'Edpex kku group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edpex_kku_group
      @edpex_kku_group = EdpexKkuGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edpex_kku_group_params
      params.require(:edpex_kku_group).permit(:no, :name)
    end

    def default_layout
      "orb"
    end
    
end
