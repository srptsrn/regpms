class Admin::UsersController < AdminController
  
  load_and_authorize_resource :class => "User"

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @q = User.limit(params[:limit]).search(params[:q])
    @q.sorts = 'username' if @q.sorts.empty?
    @users = request.format.html? ? @q.result.includes(:position, :employee_type).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:position, :employee_type)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
    render layout: !request.xhr?
  end

  # GET /admin/users/1/edit
  def edit
    unless !@user.respond_to?(:current_state) || (@user.respond_to?(:current_state) && !@user.current_state.meta[:disabled])
      respond_to do |format|
        format.html { redirect_to admin_user_url(@user, q: params[:q], page: params[:page]) }
      end
    end
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    
    @user = User.new(user_params)
    authorize! params[:button].to_sym, @user if @user.respond_to?(:current_state)

    respond_to do |format|
      if @user.save && (!@user.respond_to?(:current_state) || @user.process_event!(params[:button]))
        format.html { redirect_to admin_users_url(q: params[:q], page: params[:page]), notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: admin_user_url(@user) }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    authorize! params[:button].to_sym, @user if @user.respond_to?(:current_state)

    respond_to do |format|
      if (params[:user].nil? || (user_params[:password].blank? && @user.update_without_password(user_params)) || @user.update(user_params)) && (!@user.respond_to?(:current_state) || @user.process_event!(params[:button]))
        format.html { redirect_to admin_users_url(q: params[:q], page: params[:page]), notice: 'User was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    if params[:id]
      if (!@user.respond_to?(:current_state) || !@user.current_state.meta[:no_destroy]) &&
        (User.reflect_on_all_associations([:has_many, :has_and_belongs_to_many]).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @user.send(r.name).count}.sum == 0)
        @user.destroy if @user.id != current_user.id
      end
    elsif params[:ids]
      authorize! :destroy_selected, User
      User.where(id: params[:ids]).each do |user|
        if can?(:destroy, user) &&
          (!user.respond_to?(:current_state) || !user.current_state.meta[:no_destroy]) &&
          (User.reflect_on_all_associations([:has_many, :has_and_belongs_to_many]).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| user.send(r.name).count}.sum == 0)
          user.destroy unless current_user.id == user.id
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to admin_users_url(q: params[:q], page: params[:page]), notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :locale, :theme, :timezone, :avatar, :pid, :prefix, :firstname, :lastname, :location_id, :position_id, :employee_type_id, roles: [])
    end
end
