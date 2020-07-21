class AssessController < OrbController
  
  skip_authorization_check
  
  before_filter :check_current_evaluation
  before_filter :check_role, except: [:salary_setting, :save_salary_setting]
  
  def salary_setting
    unless current_user.authorized_as?(:hr)
      redirect_to root_url
      return false
    end
    
    unless @current_evaluation.is_360?
      redirect_to root_url
      return false
    end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
  end
  
  def save_salary_setting
    unless current_user.authorized_as?(:hr)
      redirect_to root_url
      return false
    end
    
    unless @current_evaluation.is_360?
      redirect_to root_url
      return false
    end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
    @evaluation_salary_up.point_level1 = params[:evaluation_salary_up][:point_level1]
    @evaluation_salary_up.point_level2 = params[:evaluation_salary_up][:point_level2]
    @evaluation_salary_up.point_level3 = params[:evaluation_salary_up][:point_level3]
    @evaluation_salary_up.point_level4 = params[:evaluation_salary_up][:point_level4]
    @evaluation_salary_up.point_level5 = params[:evaluation_salary_up][:point_level5]
    @evaluation_salary_up.min_change1 = params[:evaluation_salary_up][:min_change1]
    @evaluation_salary_up.min_change2 = params[:evaluation_salary_up][:min_change2]
    @evaluation_salary_up.min_change3 = params[:evaluation_salary_up][:min_change3]
    @evaluation_salary_up.min_change4 = params[:evaluation_salary_up][:min_change4]
    @evaluation_salary_up.min_change5 = params[:evaluation_salary_up][:min_change5]
    @evaluation_salary_up.max_change1 = params[:evaluation_salary_up][:max_change1]
    @evaluation_salary_up.max_change2 = params[:evaluation_salary_up][:max_change2]
    @evaluation_salary_up.max_change3 = params[:evaluation_salary_up][:max_change3]
    @evaluation_salary_up.max_change4 = params[:evaluation_salary_up][:max_change4]
    @evaluation_salary_up.max_change5 = params[:evaluation_salary_up][:max_change5]
    @evaluation_salary_up.save
    
    evaluation_salary_up_users = EvaluationSalaryUpUser.where(["evaluation_salary_up_id = ?", @evaluation_salary_up.id])
    
    params[:user_ids] ||= []
    params[:user_ids].each do |user_id|
      if User.exists?(user_id)
        user = User.find(user_id)
        
        evaluation_salary_up_user = evaluation_salary_up_users.select {|esc| esc.user_id.to_i == user_id.to_i}.first
        evaluation_salary_up_user = EvaluationSalaryUpUser.new if evaluation_salary_up_user.nil?
        
        evaluation_salary_up_user.evaluation_salary_up_id = @evaluation_salary_up.id
        evaluation_salary_up_user.evaluation_id = @current_evaluation.id
        evaluation_salary_up_user.user_id = user_id
        evaluation_salary_up_user.salary = params["evaluation_salary_up_user_#{user_id}"][:salary]
        evaluation_salary_up_user.workflow_state = :enabled
        evaluation_salary_up_user.save
      end
    end
    
    redirect_to settings_evaluations_url
    return false
  end
  
  def index
    
  end
  
  def position
    if params[:position_id] && Position.exists?(params[:position_id])
      @position = Position.find(params[:position_id])
    else
      redirect_to action: "index", role: @role
      return false
    end
  end
  
  def employee_type
    if params[:employee_type_id] && EmployeeType.exists?(params[:employee_type_id])
      @employee_type = EmployeeType.find(params[:employee_type_id])
    else
      redirect_to action: "index", role: @role
      return false
    end
  end
  
  def user
    if params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
      
      @evaluation_user = EvaluationUser.where(["user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", @user, @current_evaluation, current_user, @role]).first
      @evaluation_user = EvaluationUser.create(
        user_id: @user.id,
        evaluation_id: @current_evaluation.id,
        committee_id: current_user.id,
        role: @role, 
        workflow_state: :enabled
      ) if @evaluation_user.nil?
      
    else
      redirect_to action: "index", role: @role
      return false
    end
  end
  
  def position_capacity_user_save
    position_capacity_user = PositionCapacityUser.where(
      [
        "position_capacity_id = ? AND user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", 
        params[:position_capacity_id],  
        params[:user_id],  
        params[:evaluation_id],  
        current_user.id,  
        params[:role], 
      ]
    ).first
    position_capacity_user = PositionCapacityUser.new(
      position_capacity_id: params[:position_capacity_id],  
      user_id: params[:user_id],  
      evaluation_id: params[:evaluation_id],  
      committee_id: current_user.id,  
      role: params[:role], 
      workflow_state: :enabled
    ) if position_capacity_user.nil?
    
    position_capacity_user.score = params[:score]
    position_capacity_user.expect = params[:expect]
    position_capacity_user.weight = params[:weight]
    position_capacity_user.score_real_expect = params[:score_real_expect]
    position_capacity_user.score_real_100 = params[:score_real_100]
    position_capacity_user.score_weight = params[:score_weight]
    position_capacity_user.score_real = params[:score_real]
    
    position_capacity_user.save
    
    respond_to do |format|
      format.js
    end
  end
  
  def employee_type_task_user_save
    employee_type_task_user = EmployeeTypeTaskUser.where(
      [
        "employee_type_task_id = ? AND user_id = ? AND evaluation_id = ? AND committee_id = ? AND role = ?", 
        params[:employee_type_task_id],  
        params[:user_id],  
        params[:evaluation_id],  
        current_user.id,  
        params[:role], 
      ]
    ).first
    employee_type_task_user = EmployeeTypeTaskUser.new(
      employee_type_task_id: params[:employee_type_task_id],  
      user_id: params[:user_id],  
      evaluation_id: params[:evaluation_id],  
      committee_id: current_user.id,  
      role: params[:role], 
      workflow_state: :enabled
    ) if employee_type_task_user.nil?
    
    employee_type_task_user.score = params[:score]
    employee_type_task_user.weight = params[:weight]
    employee_type_task_user.score_real = params[:score_real]
    
    employee_type_task_user.save
    
    respond_to do |format|
      format.js
    end
  end
  
  def save_cards
    
    unless @current_evaluation.is_360?
      redirect_to root_url
      return false
    end
    
    evaluation_score_cards = EvaluationScoreCard.where(["role = ? AND evaluation_id = ? AND committee_id = ?", @role, @current_evaluation.id, current_user.id])
    
    params[:user_ids] ||= []
    params[:user_ids].each do |user_id|
      evaluation_score_card = evaluation_score_cards.select {|esc| esc.user_id.to_i == user_id.to_i}.first
      evaluation_score_card = EvaluationScoreCard.new if evaluation_score_card.nil?
      
      evaluation_score_card.role = @role
      evaluation_score_card.evaluation_id = @current_evaluation.id
      evaluation_score_card.committee_id = current_user.id
      evaluation_score_card.user_id = user_id
      evaluation_score_card.task_score = params["evaluation_score_card_#{user_id}"][:task_score]
      evaluation_score_card.ability_score = params["evaluation_score_card_#{user_id}"][:ability_score]
      evaluation_score_card.comment1 = params["evaluation_score_card_#{user_id}"][:comment1]
      evaluation_score_card.comment2 = params["evaluation_score_card_#{user_id}"][:comment2]
      evaluation_score_card.workflow_state = :enabled
      evaluation_score_card.save
      
    end

    if @role == "staff"
      self_evaluation_score_cards = EvaluationScoreCard.where(["role = ? AND evaluation_id = ? AND committee_id = ?", "self", @current_evaluation.id, current_user.id])

      params[:self_user_ids] ||= []
      params[:self_user_ids].each do |user_id|
        evaluation_score_card = self_evaluation_score_cards.select {|esc| esc.user_id.to_i == user_id.to_i}.first
        evaluation_score_card = EvaluationScoreCard.new if evaluation_score_card.nil?
        
        evaluation_score_card.role = "self"
        evaluation_score_card.evaluation_id = @current_evaluation.id
        evaluation_score_card.committee_id = current_user.id
        evaluation_score_card.user_id = user_id
        evaluation_score_card.task_score = params["self_evaluation_score_card_#{user_id}"][:task_score]
        evaluation_score_card.ability_score = params["self_evaluation_score_card_#{user_id}"][:ability_score]
        evaluation_score_card.comment1 = params["self_evaluation_score_card_#{user_id}"][:comment1]
        evaluation_score_card.comment2 = params["self_evaluation_score_card_#{user_id}"][:comment2]
        evaluation_score_card.workflow_state = :enabled
        evaluation_score_card.save
        
      end
    end
    
    redirect_to cards_assess_url(@role, evid: @current_evaluation.id)
    return false
  end
  
  def cards_summary
    if @role == "director" && current_user.is_director?(@current_evaluation)
      
    elsif @role == "vice_director" && current_user.is_vice_director?(@current_evaluation)
    #.................................................
    elsif @role == "vice_director2" && current_user.is_vice_director2?(@current_evaluation)
    elsif @role == "vice_director3" && current_user.is_vice_director3?(@current_evaluation)
    elsif @role == "secretary" && current_user.is_secretary?(@current_evaluation)
    #.................................................
      
    else
      redirect_to root_url
      return false
    end
    
    # unless @current_evaluation.is_360?
      # redirect_to root_url
      # return false
    # end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
    @evaluation_salary_up.save
    
  end
  
  def save_cards_summary
    if @role == "director" && current_user.is_director?(@current_evaluation)
      
    elsif @role == "vice_director" && current_user.is_vice_director?(@current_evaluation)
     
    #.................................................
    elsif @role == "vice_director2" && current_user.is_vice_director2?(@current_evaluation)
    elsif @role == "vice_director3" && current_user.is_vice_director3?(@current_evaluation)
    elsif @role == "secretary" && current_user.is_secretary?(@current_evaluation)
    #.................................................
         
    else
      redirect_to root_url
      return false
    end
    
    # unless @current_evaluation.is_360?
      # redirect_to root_url
      # return false
    # end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
    @evaluation_salary_up.save
    
    evaluation_salary_up_users = EvaluationSalaryUpUser.where(["evaluation_salary_up_id = ?", @evaluation_salary_up.id])
    
    params[:user_ids] ||= []
    params[:user_ids].each do |user_id|
      if User.exists?(user_id)
        user = User.find(user_id)
        
        evaluation_salary_up_user = evaluation_salary_up_users.select {|esc| esc.user_id.to_i == user_id.to_i}.first
        evaluation_salary_up_user = EvaluationSalaryUpUser.new if evaluation_salary_up_user.nil?
        
        evaluation_salary_up_user.evaluation_salary_up_id = @evaluation_salary_up.id
        evaluation_salary_up_user.evaluation_id = @current_evaluation.id
        evaluation_salary_up_user.user_id = user_id
        evaluation_salary_up_user.point = params["evaluation_salary_up_user_#{user_id}"][:point]
        evaluation_salary_up_user.workflow_state = :enabled
        evaluation_salary_up_user.save
      end
    end
    
    # redirect_to cards_summary_assess_url(@role, evid: @current_evaluation.id)
    redirect_to dashboards_url
    return false
  end
  
  def salary_calculator
    unless @role == "director" && current_user.is_director?(@current_evaluation)
      redirect_to root_url
      return false
    end
    
    unless @current_evaluation.is_360?
      redirect_to root_url
      return false
    end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
  end
  
  def save_salary_calculator
    unless @role == "director" && current_user.is_director?(@current_evaluation)
      redirect_to root_url
      return false
    end
    
    unless @current_evaluation.is_360?
      redirect_to root_url
      return false
    end
    
    @evaluation_salary_up = EvaluationSalaryUp.where(["evaluation_id = ?", @current_evaluation.id]).first
    @evaluation_salary_up = EvaluationSalaryUp.create(evaluation_id: @current_evaluation.id, workflow_state: :enabled) if @evaluation_salary_up.nil?
    @evaluation_salary_up.percent_of_change = params[:evaluation_salary_up][:percent_of_change]
    @evaluation_salary_up.total_amount = params[:evaluation_salary_up][:total_amount]
    @evaluation_salary_up.total_eligible_amount = params[:evaluation_salary_up][:total_eligible_amount]
    @evaluation_salary_up.point_level1 = params[:evaluation_salary_up][:point_level1]
    @evaluation_salary_up.point_level2 = params[:evaluation_salary_up][:point_level2]
    @evaluation_salary_up.point_level3 = params[:evaluation_salary_up][:point_level3]
    @evaluation_salary_up.point_level4 = params[:evaluation_salary_up][:point_level4]
    @evaluation_salary_up.point_level5 = params[:evaluation_salary_up][:point_level5]
    @evaluation_salary_up.min_change1 = params[:evaluation_salary_up][:min_change1]
    @evaluation_salary_up.min_change2 = params[:evaluation_salary_up][:min_change2]
    @evaluation_salary_up.min_change3 = params[:evaluation_salary_up][:min_change3]
    @evaluation_salary_up.min_change4 = params[:evaluation_salary_up][:min_change4]
    @evaluation_salary_up.min_change5 = params[:evaluation_salary_up][:min_change5]
    @evaluation_salary_up.max_change1 = params[:evaluation_salary_up][:max_change1]
    @evaluation_salary_up.max_change2 = params[:evaluation_salary_up][:max_change2]
    @evaluation_salary_up.max_change3 = params[:evaluation_salary_up][:max_change3]
    @evaluation_salary_up.max_change4 = params[:evaluation_salary_up][:max_change4]
    @evaluation_salary_up.max_change5 = params[:evaluation_salary_up][:max_change5]
    @evaluation_salary_up.save
    
    evaluation_salary_up_users = EvaluationSalaryUpUser.where(["evaluation_salary_up_id = ?", @evaluation_salary_up.id])
    
    params[:user_ids] ||= []
    params[:user_ids].each do |user_id|
      if User.exists?(user_id)
        user = User.find(user_id)
        
        evaluation_salary_up_user = evaluation_salary_up_users.select {|esc| esc.user_id.to_i == user_id.to_i}.first
        evaluation_salary_up_user = EvaluationSalaryUpUser.new if evaluation_salary_up_user.nil?
        
        evaluation_salary_up_user.evaluation_salary_up_id = @evaluation_salary_up.id
        evaluation_salary_up_user.evaluation_id = @current_evaluation.id
        evaluation_salary_up_user.user_id = user_id
        evaluation_salary_up_user.position_level_id = params["evaluation_salary_up_user_#{user_id}"][:position_level_id]
        
        evaluation_salary_up_user.salary = params["evaluation_salary_up_user_#{user_id}"][:salary]
        evaluation_salary_up_user.is_eligible = params["evaluation_salary_up_user_#{user_id}"][:is_eligible]
        evaluation_salary_up_user.base_salary = params["evaluation_salary_up_user_#{user_id}"][:base_salary]
        evaluation_salary_up_user.base_salary_min = params["evaluation_salary_up_user_#{user_id}"][:base_salary_min]
        evaluation_salary_up_user.base_salary_max = params["evaluation_salary_up_user_#{user_id}"][:base_salary_max]
        evaluation_salary_up_user.percent_of_min_up = params["evaluation_salary_up_user_#{user_id}"][:percent_of_min_up]
        evaluation_salary_up_user.salary_min_up = params["evaluation_salary_up_user_#{user_id}"][:salary_min_up]
        evaluation_salary_up_user.avg_point = params["evaluation_salary_up_user_#{user_id}"][:avg_point]
        evaluation_salary_up_user.salary_up = params["evaluation_salary_up_user_#{user_id}"][:salary_up]
        evaluation_salary_up_user.percent_of_up = params["evaluation_salary_up_user_#{user_id}"][:percent_of_up]
        evaluation_salary_up_user.extra_money = params["evaluation_salary_up_user_#{user_id}"][:extra_money]
        evaluation_salary_up_user.workflow_state = :enabled
        evaluation_salary_up_user.save
      end
    end
    
    # redirect_to salary_calculator_assess_url(@role, evid: @current_evaluation.id)
    redirect_to dashboards_url
    return false
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
      
      if @role == "director" && current_user.is_director?(@current_evaluation)
      
      elsif @role == "vice_director" && current_user.is_vice_director?(@current_evaluation)

      #.................................................
      elsif @role == "vice_director2" && current_user.is_vice_director2?(@current_evaluation)
      elsif @role == "vice_director3" && current_user.is_vice_director3?(@current_evaluation)
      elsif @role == "secretary" && current_user.is_secretary?(@current_evaluation)
      #.................................................
      
      elsif @role == "committee" && current_user.is_committee?(@current_evaluation)
      
      elsif @role == "staff"
      
      elsif @role == "section_leader" && current_user.is_section_leader?
        if Section.exists?(params[:section_id])
          @section = Section.find(params[:section_id])
          unless @section.leader_id == current_user.id
            redirect_to root_url
            return false
          end  
        else
          redirect_to root_url
          return false
        end 
      elsif @role == "section_vice_leader" && current_user.is_section_vice_leader?
        if Section.exists?(params[:section_id])
          @section = Section.find(params[:section_id])
          unless @section.vice_leader_id == current_user.id
            redirect_to root_url
            return false
          end  
        else
          redirect_to root_url
          return false
        end    
      elsif @role == "team_leader" && current_user.is_team_leader?
        if Team.exists?(params[:team_id])
          @team = Team.find(params[:team_id])
          unless @team.leader_id == current_user.id
            redirect_to root_url
            return false
          end  
        else
          redirect_to root_url
          return false
        end       
      elsif @role == "faculty_leader" && current_user.is_faculty_leader?
        if Faculty.exists?(params[:faculty_id])
          @faculty = Faculty.find(params[:faculty_id])
          unless @faculty.leader_id == current_user.id
            redirect_to root_url
            return false
          end  
        else
          redirect_to root_url
          return false
        end  
      elsif @role == "faculty_dean" && current_user.is_faculty_dean?
        if Faculty.exists?(params[:faculty_id])
          @faculty = Faculty.find(params[:faculty_id])
          unless @faculty.dean_id == current_user.id
            redirect_to root_url
            return false
          end  
        else
          redirect_to root_url
          return false
        end     
      else
        redirect_to root_url
        return false
      end
    end
  end
  
end
