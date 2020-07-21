class DashboardsController < OrbController
  
  # load_and_authorize_resource
  # skip_authorization_check
  authorize_resource :class => false
  
  def batt
    render text: "batt"
  end
  
  def evaluation
    
  end
  
  def pd
    redirect_to pds_url
    return false
  end
  
  def pf
    redirect_to pfs_url
    return false
  end
  
  def change_current_evaluation
    
    if params[:evaluation] && params[:evaluation][:id] && Evaluation.exists?(params[:evaluation][:id])
      @current_evaluation = Evaluation.find(params[:evaluation][:id])
      session[:current_evaluation_id] = @current_evaluation.id
    end
    
    redirect_to session[:previous_location_url] || root_url
    return false
  end
  
end
