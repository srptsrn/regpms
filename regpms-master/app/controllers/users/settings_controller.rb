class Users::SettingsController < ApplicationController
  
  skip_authorization_check

  before_action :set_user, only: [:update]
  
  def update
    
    @user.update_without_password(user_params)
    
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(current_user.id) if current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:theme, :locale, :timezone)
    end
  
end
