class EdpexKkuItemsController < OrbController
  load_and_authorize_resource :class => "EdpexKkuItem"

  before_action :set_edpex_kku_item, only: [:show, :edit, :update, :destroy]

  # GET /edpex_kku_items
  # GET /edpex_kku_items.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = EdpexKkuItem.active_states.join(",")
    end if EdpexKkuItem.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if EdpexKkuItem.respond_to?(:workflow_spec)
    @q = EdpexKkuItem.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @edpex_kku_items = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /edpex_kku_items/1
  # GET /edpex_kku_items/1.json
  def show
  end

  # GET /edpex_kku_items/new
  def new
    @edpex_kku_item = EdpexKkuItem.new
    render layout: !request.xhr?
  end

  # GET /edpex_kku_items/1/edit
  def edit
  end

  # POST /edpex_kku_items
  # POST /edpex_kku_items.json
  def create
    @edpex_kku_item = EdpexKkuItem.new(edpex_kku_item_params)
    authorize! params[:button].to_sym, @edpex_kku_item if @edpex_kku_item.respond_to?(:current_state)

    respond_to do |format|
      if @edpex_kku_item.save && (!@edpex_kku_item.respond_to?(:current_state) || @edpex_kku_item.process_event!(params[:button]))
        format.html { redirect_to edpex_kku_items_url(q: params[:q], page: params[:page]), notice: 'Edpex kku item was successfully created.' }
        format.json { render action: 'show', status: :created, location: edpex_kku_item_url(@edpex_kku_item) }
      else
        format.html { render action: 'new' }
        format.json { render json: @edpex_kku_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edpex_kku_items/1
  # PATCH/PUT /edpex_kku_items/1.json
  def update
    authorize! params[:button].to_sym, @edpex_kku_item if @edpex_kku_item.respond_to?(:current_state)

    respond_to do |format|
      if (params[:edpex_kku_item].nil? || @edpex_kku_item.update(edpex_kku_item_params)) && (!@edpex_kku_item.respond_to?(:current_state) || @edpex_kku_item.process_event!(params[:button]))
        format.html { redirect_to edpex_kku_items_url(q: params[:q], page: params[:page]), notice: 'Edpex kku item was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @edpex_kku_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edpex_kku_items/1
  # DELETE /edpex_kku_items/1.json
  def destroy
    if params[:id]
      if (!@edpex_kku_item.respond_to?(:current_state) || !@edpex_kku_item.current_state.meta[:no_destroy]) &&
        (EdpexKkuItem.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @edpex_kku_item.send(r.name).count}.sum == 0)
        @edpex_kku_item.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, EdpexKkuItem
      EdpexKkuItem.where(id: params[:ids]).each do |edpex_kku_item|
        if can?(:destroy, edpex_kku_item) &&
          (!edpex_kku_item.respond_to?(:current_state) || !edpex_kku_item.current_state.meta[:no_destroy]) &&
          (EdpexKkuItem.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| edpex_kku_item.send(r.name).count}.sum == 0)
          edpex_kku_item.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to edpex_kku_items_url(q: params[:q], page: params[:page]), notice: 'Edpex kku item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edpex_kku_item
      @edpex_kku_item = EdpexKkuItem.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edpex_kku_item_params
      params.require(:edpex_kku_item).permit(:edpex_kku_id, :no, :name, :target, :year1, :year2, :year3, :year4, :year5, :year, :institute)
    end

    def default_layout
      "orb"
    end
    
end
