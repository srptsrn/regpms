class NotificationsController < OrbController
  
  load_and_authorize_resource :class => "Notification"
  
  def index
    @q = current_user.notifications.limit(params[:limit]).search(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @notifications = @q.result
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def seen
    
    @notification = Notification.find(params[:id])
    @notification.read! unless @notification.current_state.to_sym == :seen
    
    respond_to do |format|
      unless @notification.url.blank?
        format.html { redirect_to @notification.url }
      else
        format.html { redirect_to notifications_url }
      end
      format.js
    end
  end
  
end
