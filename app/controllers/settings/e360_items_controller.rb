class Settings::E360ItemsController < SettingsController
  load_and_authorize_resource :class => "E360Item"

  before_action :set_e360_item, only: [:show, :edit, :update, :destroy]

  # GET /settings/e360_items
  # GET /settings/e360_items.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = E360Item.active_states.join(",")
    end if E360Item.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if E360Item.respond_to?(:workflow_spec)
    @q = E360Item.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @e360_items = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /settings/e360_items/1
  # GET /settings/e360_items/1.json
  def show
  end

  # GET /settings/e360_items/new
  def new
    @e360_item = E360Item.new
    render layout: !request.xhr?
  end

  # GET /settings/e360_items/1/edit
  def edit
  end

  # POST /settings/e360_items
  # POST /settings/e360_items.json
  def create
    @e360_item = E360Item.new(e360_item_params)
    authorize! params[:button].to_sym, @e360_item if @e360_item.respond_to?(:current_state)

    respond_to do |format|
      if @e360_item.save && (!@e360_item.respond_to?(:current_state) || @e360_item.process_event!(params[:button]))
        format.html { redirect_to settings_e360_items_url(q: params[:q], page: params[:page]), notice: 'E360 item was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_e360_item_url(@e360_item) }
      else
        format.html { render action: 'new' }
        format.json { render json: @e360_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/e360_items/1
  # PATCH/PUT /settings/e360_items/1.json
  def update
    authorize! params[:button].to_sym, @e360_item if @e360_item.respond_to?(:current_state)

    respond_to do |format|
      if (params[:e360_item].nil? || @e360_item.update(e360_item_params)) && (!@e360_item.respond_to?(:current_state) || @e360_item.process_event!(params[:button]))
        format.html { redirect_to settings_e360_items_url(q: params[:q], page: params[:page]), notice: 'E360 item was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @e360_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/e360_items/1
  # DELETE /settings/e360_items/1.json
  def destroy
    if params[:id]
      if (!@e360_item.respond_to?(:current_state) || !@e360_item.current_state.meta[:no_destroy]) &&
        (E360Item.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @e360_item.send(r.name).count}.sum == 0)
        @e360_item.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, E360Item
      E360Item.where(id: params[:ids]).each do |e360_item|
        if can?(:destroy, e360_item) &&
          (!e360_item.respond_to?(:current_state) || !e360_item.current_state.meta[:no_destroy]) &&
          (E360Item.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| e360_item.send(r.name).count}.sum == 0)
          e360_item.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_e360_items_url(q: params[:q], page: params[:page]), notice: 'E360 item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_e360_item
      @e360_item = E360Item.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def e360_item_params
      params.require(:e360_item).permit(:workflow_state, :workflow_state_updater_id, :evaluation_id, :sorting, :name)
    end

    def default_layout
      "orb"
    end
    
end
