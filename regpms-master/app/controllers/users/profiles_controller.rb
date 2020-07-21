class Users::ProfilesController < OrbController
  
  skip_authorization_check

  before_action :set_user, only: [:index, :show, :edit, :update, :edit_password, :update_password]
  
  def index
    redirect_to action: :show
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if (user_params[:password].blank? && @user.update_without_password(user_params)) || @user.update(user_params)
        format.html { redirect_to users_profile_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit_password
  end
  
  def update_password
    respond_to do |format|
      if params[:user] && !params[:user][:password].blank? && !params[:user][:password_confirmation].blank? && @user.update(user_params)
        format.html { redirect_to users_profile_url, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_password' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id) if current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:avatar, :email, :password, :password_confirmation)
    end
  
end
