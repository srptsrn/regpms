class E360sController < OrbController
  
  skip_authorization_check
  
  before_filter :check_current_evaluation
  before_filter :check_role
  
  def index
    
  end
  
  def user
    if params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      
      @e360_user = E360User.where(["user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", @user, @current_evaluation, current_user, @role]).first
      @e360_user = E360User.create(
        user_id: @user.id,
        evaluation_id: @current_evaluation.id,
        committee_id: current_user.id,
        role: @role, 
        workflow_state: :enabled
      ) if @e360_user.nil?
      
    else
      redirect_to action: "index", role: @role
      return false
    end
  end
  
  def e360_item_user_save
    e360_item_user = E360ItemUser.where(
      [
        "e360_user_id = ? AND e360_item_id = ?", 
        params[:e360_user_id],  
        params[:e360_item_id]
      ]
    ).first
    e360_item_user = E360ItemUser.new(
      e360_user_id: params[:e360_user_id], 
      e360_item_id: params[:e360_item_id]
    ) if e360_item_user.nil?
    
    e360_item_user.score = params[:score]
    
    e360_item_user.save
    
    respond_to do |format|
      format.js
    end
  end
  
  private
  def check_current_evaluation
      
    if !params[:evid].blank? && Evaluation.exists?(params[:evid])
      @current_evaluation = Evaluation.find(params[:evid])
      session[:current_evaluation_id] = @current_evaluation.id
    end
    
    if @current_evaluation.nil?
      redirect_to root_url
      return false
    end
  end
  
  def check_role
    if params[:role].blank?
      redirect_to root_url
      return false
    else
      @role = params[:role]
    end
  end
  
end
