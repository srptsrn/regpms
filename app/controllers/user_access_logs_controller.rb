class UserAccessLogsController < OrbController
  load_and_authorize_resource :class => "UserAccessLog"

  # GET /user_access_logs
  # GET /user_access_logs.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = UserAccessLog.active_states.join(",")
    end if UserAccessLog.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if UserAccessLog.respond_to?(:workflow_spec)
    @q = UserAccessLog.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @user_access_logs = request.format.html? ? @q.result.paginate(:page => params[:page], :per_page => 20) : @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_access_log
      @user_access_log = UserAccessLog.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_access_log_params
      params.require(:user_access_log).permit(:user_id, :username, :ip, :controller_name, :action_name, :params, :params_id, :log_time)
    end

    def default_layout
      "orb"
    end
    
end
