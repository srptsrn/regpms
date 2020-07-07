class Admin::UserGroupsController < AdminController
  load_and_authorize_resource :class => "UserGroup"

  before_action :set_user_group, only: [:show, :edit, :update, :destroy]

  # GET /admin/user_groups
  # GET /admin/user_groups.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = UserGroup.active_states.join(",")
    end if UserGroup.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if UserGroup.respond_to?(:workflow_spec)
    @q = UserGroup.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @user_groups = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /admin/user_groups/1
  # GET /admin/user_groups/1.json
  def show
  end

  # GET /admin/user_groups/new
  def new
    @user_group = UserGroup.new
    render layout: !request.xhr?
  end

  # GET /admin/user_groups/1/edit
  def edit
  end

  # POST /admin/user_groups
  # POST /admin/user_groups.json
  def create
    @user_group = UserGroup.new(user_group_params)
    authorize! params[:button].to_sym, @user_group if @user_group.respond_to?(:current_state)

    respond_to do |format|
      if @user_group.save && (!@user_group.respond_to?(:current_state) || @user_group.process_event!(params[:button]))
        format.html { redirect_to admin_user_groups_url(q: params[:q], page: params[:page]), notice: 'User group was successfully created.' }
        format.json { render action: 'show', status: :created, location: admin_user_group_url(@user_group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/user_groups/1
  # PATCH/PUT /admin/user_groups/1.json
  def update
    authorize! params[:button].to_sym, @user_group if @user_group.respond_to?(:current_state)

    respond_to do |format|
      if (params[:user_group].nil? || @user_group.update(user_group_params)) && (!@user_group.respond_to?(:current_state) || @user_group.process_event!(params[:button]))
        format.html { redirect_to admin_user_groups_url(q: params[:q], page: params[:page]), notice: 'User group was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/user_groups/1
  # DELETE /admin/user_groups/1.json
  def destroy
    if params[:id]
      if (!@user_group.respond_to?(:current_state) || !@user_group.current_state.meta[:no_destroy]) &&
        (UserGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @user_group.send(r.name).count}.sum == 0)
        @user_group.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, UserGroup
      UserGroup.where(id: params[:ids]).each do |user_group|
        if can?(:destroy, user_group) &&
          (!user_group.respond_to?(:current_state) || !user_group.current_state.meta[:no_destroy]) &&
          (UserGroup.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| user_group.send(r.name).count}.sum == 0)
          user_group.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to admin_user_groups_url(q: params[:q], page: params[:page]), notice: 'User group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_group
      @user_group = UserGroup.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_group_params
      params.require(:user_group).permit(:name, :roles_mask)
    end

    def default_layout
      "orb"
    end
    
end
