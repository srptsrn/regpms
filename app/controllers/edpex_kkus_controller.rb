class EdpexKkusController < OrbController
  load_and_authorize_resource :class => "EdpexKku"

  before_action :set_edpex_kku, only: [:show, :edit, :update, :destroy]

  # GET /edpex_kkus
  # GET /edpex_kkus.json
  def index
    if params[:q].blank?
      year = (Date.current.mon >= 8 ? Date.current.year : Date.current.year - 1) 
      params[:q] = {}
      params[:q][:year_eq] = year
      # params[:q][:workflow_state_in] = EdpexKku.active_states.join(",")
    end # if EdpexKku.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EdpexKku.respond_to?(:workflow_spec)
    @q = EdpexKku.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @edpex_kkus = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /edpex_kkus/1
  # GET /edpex_kkus/1.json
  def show
  end

  # GET /edpex_kkus/new
  def new
    @edpex_kku = EdpexKku.new
    render layout: !request.xhr?
  end

  # GET /edpex_kkus/1/edit
  def edit
  end

  # POST /edpex_kkus
  # POST /edpex_kkus.json
  def create
    @edpex_kku = EdpexKku.new(edpex_kku_params)
    authorize! params[:button].to_sym, @edpex_kku if @edpex_kku.respond_to?(:current_state)

    respond_to do |format|
      if @edpex_kku.save && (!@edpex_kku.respond_to?(:current_state) || @edpex_kku.process_event!(params[:button]))
        format.html { redirect_to edpex_kkus_url(q: params[:q], page: params[:page]), notice: 'Edpex kku was successfully created.' }
        format.json { render action: 'show', status: :created, location: edpex_kku_url(@edpex_kku) }
      else
        format.html { render action: 'new' }
        format.json { render json: @edpex_kku.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edpex_kkus/1
  # PATCH/PUT /edpex_kkus/1.json
  def update
    authorize! params[:button].to_sym, @edpex_kku if @edpex_kku.respond_to?(:current_state)

    respond_to do |format|
      if (params[:edpex_kku].nil? || @edpex_kku.update(edpex_kku_params)) && (!@edpex_kku.respond_to?(:current_state) || @edpex_kku.process_event!(params[:button]))
        format.html { redirect_to edpex_kkus_url(q: params[:q], page: params[:page]), notice: 'Edpex kku was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @edpex_kku.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edpex_kkus/1
  # DELETE /edpex_kkus/1.json
  def destroy
    if params[:id]
      if (!@edpex_kku.respond_to?(:current_state) || !@edpex_kku.current_state.meta[:no_destroy]) &&
        (EdpexKku.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @edpex_kku.send(r.name).count}.sum == 0)
        @edpex_kku.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EdpexKku
      EdpexKku.where(id: params[:ids]).each do |edpex_kku|
        if can?(:destroy, edpex_kku) &&
          (!edpex_kku.respond_to?(:current_state) || !edpex_kku.current_state.meta[:no_destroy]) &&
          (EdpexKku.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| edpex_kku.send(r.name).count}.sum == 0)
          edpex_kku.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to edpex_kkus_url(q: params[:q], page: params[:page]), notice: 'Edpex kku was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edpex_kku
      @edpex_kku = EdpexKku.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edpex_kku_params
      params.require(:edpex_kku).permit(
        :year, :edpex_kku_group_id, :no, :name, :description, 
        edpex_kku_items_attributes: [:id, :edpex_kku_id, :no, :name, :target, :year1, :year2, :year3, :year4, :year5, :year, :institute, :_destroy]
      )
    end

    def default_layout
      "orb"
    end
    
end
