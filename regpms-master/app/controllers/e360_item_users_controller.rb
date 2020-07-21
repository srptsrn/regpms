class E360ItemUsersController < OrbController
  load_and_authorize_resource :class => "E360ItemUser"

  before_action :set_e360_item_user, only: [:show, :edit, :update, :destroy]

  # GET /e360_item_users
  # GET /e360_item_users.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = E360ItemUser.active_states.join(",")
    end if E360ItemUser.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if E360ItemUser.respond_to?(:workflow_spec)
    @q = E360ItemUser.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @e360_item_users = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /e360_item_users/1
  # GET /e360_item_users/1.json
  def show
  end

  # GET /e360_item_users/new
  def new
    @e360_item_user = E360ItemUser.new
    render layout: !request.xhr?
  end

  # GET /e360_item_users/1/edit
  def edit
  end

  # POST /e360_item_users
  # POST /e360_item_users.json
  def create
    @e360_item_user = E360ItemUser.new(e360_item_user_params)
    authorize! params[:button].to_sym, @e360_item_user if @e360_item_user.respond_to?(:current_state)

    respond_to do |format|
      if @e360_item_user.save && (!@e360_item_user.respond_to?(:current_state) || @e360_item_user.process_event!(params[:button]))
        format.html { redirect_to e360_item_users_url(q: params[:q], page: params[:page]), notice: 'E360 item user was successfully created.' }
        format.json { render action: 'show', status: :created, location: e360_item_user_url(@e360_item_user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @e360_item_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /e360_item_users/1
  # PATCH/PUT /e360_item_users/1.json
  def update
    authorize! params[:button].to_sym, @e360_item_user if @e360_item_user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:e360_item_user].nil? || @e360_item_user.update(e360_item_user_params)) && (!@e360_item_user.respond_to?(:current_state) || @e360_item_user.process_event!(params[:button]))
        format.html { redirect_to e360_item_users_url(q: params[:q], page: params[:page]), notice: 'E360 item user was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @e360_item_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /e360_item_users/1
  # DELETE /e360_item_users/1.json
  def destroy
    if params[:id]
      if (!@e360_item_user.respond_to?(:current_state) || !@e360_item_user.current_state.meta[:no_destroy]) &&
        (E360ItemUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @e360_item_user.send(r.name).count}.sum == 0)
        @e360_item_user.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, E360ItemUser
      E360ItemUser.where(id: params[:ids]).each do |e360_item_user|
        if can?(:destroy, e360_item_user) &&
          (!e360_item_user.respond_to?(:current_state) || !e360_item_user.current_state.meta[:no_destroy]) &&
          (E360ItemUser.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| e360_item_user.send(r.name).count}.sum == 0)
          e360_item_user.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to e360_item_users_url(q: params[:q], page: params[:page]), notice: 'E360 item user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_e360_item_user
      @e360_item_user = E360ItemUser.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def e360_item_user_params
      params.require(:e360_item_user).permit(:e360_user_id, :e360_item_id, :score)
    end

    def default_layout
      "orb"
    end
    
end
