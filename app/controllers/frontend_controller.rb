class FrontendController < OrbFrontendController
  
  # layout "orb_frontend2"
  
  skip_before_filter :authenticate_user!
  skip_authorization_check
  skip_before_filter :verify_authenticity_token, only: [:chose_date_news_calendar]
  
  def news
    if params[:id] && NewsFront.exists?(params[:id])
      @news_front = NewsFront.find(params[:id])
    else
      @news_fronts = NewsFront.all_published.paginate(:page => params[:page], :per_page => 36)
    end
    
    render layout: "orb_frontend_full"
  end
  
  def chose_date_news_calendar
    date = params[:new_calendars_date]
    
    respond_to do |format|
      format.js
    end
  end
  
  def comment_news_front
    
    @news_front = NewsFront.find(params[:id])
    
    comment_params = params.require(:comment).permit(:comment, :by)
    @comment = Comment.new(comment_params)
    @comment.obj = "NewsFront"
    @comment.obj_id = @news_front.id
    @comment.ip = request.remote_ip
    @comment.by ||= current_user ? current_user.username : nil
    @comment.user_id = current_user ? current_user.id : nil
    @comment.workflow_state = :commented
    @comment.save
    
    respond_to do |format|
      format.html { redirect_to news_frontend_url(@comment.news_front, focus: :comment) }
    end
  end
  
end
