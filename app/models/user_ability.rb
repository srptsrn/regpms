class UserAbility
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    alias_action :read, :create, :to => :cr
    alias_action :read, :create, :edit, :update, :to => :cru
    alias_action :cru, :destroy, :to => :crud
    alias_action :crud, :edit_inplace, :to => :crud_e
    alias_action :crud, :index_select, :to => :crud_s
    alias_action :crud, :index_select, :destroy_selected, :to => :crud_sd
    alias_action :crud, :edit_inplace, :index_select, :destroy_selected, :to => :crud_esd

    # user ||= User.new # guest user (not logged in)
    if user
      
      user_group = user.user_group ? user.user_group : UserGroup.new
      
      # JobPlan
      can [:cru, :submit, :save_change, :enable, :disable, :chose_job_template, :chose_job_template_group], JobPlan do |job_plan|
        job_plan.user_id.nil? || job_plan.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_plan.user.sections.collect {|s| s.id})
      end
      can [:terminate], JobPlan do |job_plan|
        (job_plan.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_plan.user.sections.collect {|s| s.id})) && 
        job_plan.evaluation_id && job_plan.evaluation.pd_start_date <= Date.current && job_plan.evaluation.pd_end_date >= Date.current # && job_plan.evaluation.pf_start_date > Date.current
      end
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobPlanFile do |job_plan_file|
        job_plan_file.job_plan.nil? || job_plan_file.job_plan.user_id.nil? || job_plan_file.job_plan.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_plan_file.job_plan.user.sections.collect {|s| s.id})
      end
      can [:read, :confirm, :unconfirm], JobPlan do |job_plan|
        job_plan.user # && Captain.where(["section_id = ? AND location_id = ? AND user_id = ?", job_plan.user.section_id, job_plan.user.location_id, user.id]).size > 0
      end
      
      # JobRoutine
      can [:cru, :submit, :save_change, :enable, :disable, :chose_job_template, :chose_job_template_group], JobRoutine do |job_routine|
        job_routine.user_id.nil? || job_routine.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_routine.user.sections.collect {|s| s.id})
      end
      can [:terminate], JobRoutine do |job_routine|
        (job_routine.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_routine.user.sections.collect {|s| s.id})) && 
        job_routine.evaluation_id && job_routine.evaluation.pd_start_date <= Date.current && job_routine.evaluation.pd_end_date >= Date.current # && job_routine.evaluation.pf_start_date > Date.current
      end
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobRoutineFile do |job_routine_file|
        job_routine_file.job_routine.nil? || job_routine_file.job_routine.user_id.nil? || job_routine_file.job_routine.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_routine_file.job_routine.user.sections.collect {|s| s.id})
      end
      can [:read, :confirm, :unconfirm], JobRoutine do |job_routine|
        job_routine.user # && Captain.where(["section_id = ? AND location_id = ? AND user_id = ?", job_routine.user.section_id, job_routine.user.location_id, user.id]).size > 0
      end
    
      # JobVice
      can [:cru, :submit, :save_change, :enable, :disable, :chose_job_template, :chose_job_template_group], JobVice do |job_vice|
        job_vice.user_id.nil? || job_vice.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_vice.user.sections.collect {|s| s.id})
      end
      can [:terminate], JobVice do |job_vice|
        (job_vice.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_vice.user.sections.collect {|s| s.id})) && 
        job_vice.evaluation_id && job_vice.evaluation.pd_start_date <= Date.current && job_vice.evaluation.pd_end_date >= Date.current # && job_vice.evaluation.pf_start_date > Date.current
      end
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobViceFile do |job_vice_file|
        job_vice_file.job_vice.nil? || job_vice_file.job_vice.user_id.nil? || job_vice_file.job_vice.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_vice_file.job_vice.user.sections.collect {|s| s.id})
      end
      can [:read, :confirm, :unconfirm], JobVice do |job_vice|
        job_vice.user # && Captain.where(["section_id = ? AND location_id = ? AND user_id = ?", job_vice.user.section_id, job_vice.user.location_id, user.id]).size > 0
      end
    
      # JobDevelopment
      can [:cru, :submit, :save_change, :enable, :disable, :chose_job_template, :chose_job_template_group], JobDevelopment do |job_development|
        job_development.user_id.nil? || job_development.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_development.user.sections.collect {|s| s.id})
      end
      can [:terminate], JobDevelopment do |job_development|
        (job_development.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_development.user.sections.collect {|s| s.id})) && 
        job_development.evaluation_id && job_development.evaluation.pd_start_date <= Date.current && job_development.evaluation.pd_end_date >= Date.current # && job_development.evaluation.pf_start_date > Date.current
      end
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobDevelopmentFile do |job_development_file|
        job_development_file.job_development.nil? || job_development_file.job_development.user_id.nil? || job_development_file.job_development.user_id == user.id || user.authorized_as?(:systemadmin) || user.is_section_leader?(job_development_file.job_development.user.sections.collect {|s| s.id})
      end
      can [:read, :confirm, :unconfirm], JobDevelopment do |job_development|
        job_development.user # && Captain.where(["section_id = ? AND location_id = ? AND user_id = ?", job_development.user.section_id, job_development.user.location_id, user.id]).size > 0
      end
      
      # Project
      can [:read], Project
      can [:update, :save_change, :save_change_as_draft, :change_to_draft, :finish, :reopen, :print, :chose_strategy, :chose_strategy_group, :chose_tactic, :chose_kku_strategic_pillar], Project do |project|
        project.responsibles.size == 0 || project.responsibles.select {|responsible| responsible.user_id == user.id}.size > 0
        # 20161019 ขอให้แก้ไขได้ทุกสถานะไปก่อน 
        # && [:draft, :enabled, :finished].include?(project.current_state.to_sym)
      end
      can [:read, :chose_user], Responsible
      
      # Activity
      can [:read, :create, :submit], Activity
      can [:read, :update, :save_change, :terminate], Activity do |activity|
        project = activity.project
        project.responsibles.size == 0 || project.responsibles.select {|responsible| responsible.user_id == user.id}.size > 0
        # 20161019 ขอให้แก้ไขได้ทุกสถานะไปก่อน 
        # && [:draft, :enabled, :finished].include?(project.current_state.to_sym)
      end
      
      #######################################################################################################################################################################################################################################################
      # :ibattz #############################################################################################################################################################################################################################################
      if user.authorized_as?(:ibattz) || user_group.authorized_as?([:ibattz])
        
        # User
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], User
        can :crud_sd, UserGroup
        
        # # News
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsImage
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsFront
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsCalendar
      
        # UserAccessLog
        can :read, UserAccessLog
      
        # template
        can :read, :template
        can :read, :frontend_template
      
        # system
        can [:read, :workflow_states], :system
        
        can :r4, :report
        can :comment, :report
        can :employee_type, :report
      end
      
      #######################################################################################################################################################################################################################################################
      # :systemadmin ########################################################################################################################################################################################################################################
      if user.authorized_as?(:systemadmin) || user_group.authorized_as?([:systemadmin])
        
        # User
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], User
        unless user.authorized_as?(:ibattz) || user_group.authorized_as?([:ibattz])
          cannot [:edit, :update, :submit, :save_change, :enable, :disable, :terminate], User do |u|
            u.role_names.select {|r| r.to_s.include?("ibattz")}.size > 0
          end
        end
        can :crud_sd, UserGroup
        
        # News
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsImage
        can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsFront
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsCalendar
        
      end
      
      #######################################################################################################################################################################################################################################################
      # :accounting ########################################################################################################################################################################################################################################
      if user.authorized_as?(:accounting) || user_group.authorized_as?([:accounting])
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], BudgetType
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], BudgetGroup
        
        # Project
        can [:cru, :submit, :submit_as_draft, :save_change, :save_change_as_draft, :enable, :disable, :change_to_draft, :finish, :reopen, :terminate, :print, :chose_kku_strategic_pillar, :chose_strategy, :chose_strategy_group, :chose_tactic, :project_approve, :project_expense, :change_to_enable, :change_to_project_expense], Project
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :chose_user], Responsible
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Budget
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :chose_project, :import, :import_save], Expense
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Benefit
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Indicator
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Activity
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], ProblemSuggesstion
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], ProjectImage
        
        can :read, :reports_project
        can :expenses, :reports_project
        can :expenses_by_range, :reports_project
        
      end
      
      #######################################################################################################################################################################################################################################################
      # :planner ########################################################################################################################################################################################################################################
      if user.authorized_as?(:planner) || user_group.authorized_as?([:planner])
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], KkuStrategicPillar
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], KkuStrategic
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Policy
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Strategy
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :chose_strategy_group], Tactic
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], StrategyGroup
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :chose_strategy, :chose_strategy_group], Measure
        
        # Project
        can [:cru, :submit, :submit_as_draft, :save_change, :save_change_as_draft, :enable, :disable, :change_to_draft, :finish, :reopen, :terminate, :print, :chose_strategy, :chose_strategy_group, :chose_tactic, :chose_kku_strategic_pillar, :start_project, :cancel_start_project], Project
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :chose_user], Responsible
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Budget
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Benefit
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Indicator
        can [:cru, :submit, :save_change, :enable, :disable, :terminate, :export], Activity
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], ProblemSuggesstion
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], ProjectImage
        
        can :read, :reports_planner
        can :summary_indicator, :reports_planner
        
      end
      
      #######################################################################################################################################################################################################################################################
      # :qa ########################################################################################################################################################################################################################################
      if user.authorized_as?(:qa) || user_group.authorized_as?([:qa])
        
        can :crud_sd, EdpexKkuGroup
        can :crud_sd, EdpexKku
        can :crud_sd, EdpexKkuItem
        
      end
      
      #######################################################################################################################################################################################################################################################
      # :hr ########################################################################################################################################################################################################################################
      if user.authorized_as?(:hr) || user_group.authorized_as?([:hr])
        
        # User
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], User
        unless user.authorized_as?(:ibattz) || user_group.authorized_as?([:ibattz])
          cannot [:edit, :update, :submit, :save_change, :enable, :disable, :terminate], User do |u|
            u.role_names.select {|r| r.to_s.include?("ibattz")}.size > 0
          end
        end
        can :crud_sd, UserGroup
        
        # Settings
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobTemplateGroup
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobTemplate
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Task
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], EmployeeType
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], EmployeeTypeTaskGroup
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], EmployeeTypeTask
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Evaluation
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], EvaluationEmployeeType
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Committee
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Section
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], SectionUser
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Faculty
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], FacultyUser
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Team
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], TeamUser
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Capacity
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], PositionType
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], PositionLevel
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], Position
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], PositionCapacity
        
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], E360Item
        can [:cru, :submit, :save_change, :enable, :disable, :terminate], BaseSalary
        
        # News
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsImage
        can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsFront
        # can [:cru, :submit, :save_change, :publish, :unpublish, :terminate], NewsCalendar
        
        can :read, :report
        can :users, :report
        can :user, :report
        # can :comment, :report
        # can :r4, :report
        # can :employee_type, :report
        can :job_result_others, :report
        
        can [:x, :x_user], :pd
        can [:x, :x_user], :pf
        
        can :r4, :report
        can :comment, :report
        can :employee_type, :report
        
      end
      
      can [:read, :create, :submit], EmployeeTypeUser
      can [:read, :update, :save_change, :enable, :disable, :terminate], EmployeeTypeUser do |employee_type_user|
        employee_type_user.user_id == user.id
      end

      # dashboard
      can :read, :dashboard # everyone can read root
      can :evaluation, :dashboard # everyone can read root
      can :change_current_evaluation, :dashboard
      
      can :pd, :dashboard
      can [:read, :print, :clone, :confirm], :pd
      can [:chose_job_template_group_job_plan, :add_job_plan, :edit_job_plan, :update_job_plan, :remove_job_plan], :pd
      can [:chose_job_template_group_job_routine, :add_job_routine, :edit_job_routine, :update_job_routine, :remove_job_routine], :pd
      can [:chose_job_template_group_job_vice, :add_job_vice, :edit_job_vice, :update_job_vice, :remove_job_vice], :pd
      can [:chose_job_template_group_job_development, :add_job_development, :edit_job_development, :update_job_development, :remove_job_development], :pd
      can [:x, :x_user], :pd do
        Section.where(["leader_id = ?", user.id]).size > 0
      end
      
      can :pf, :dashboard
      can [:read, :print, :clone], :pf
      can [:add_job_plan_result, :edit_job_plan_result, :update_job_plan_result, :remove_job_plan_result, :upload_job_plan_result, :edit_job_plan_result_file, :update_job_plan_result_file, :remove_job_plan_result_file, :update_job_plan_self_point], :pf
      can [:add_job_routine_result, :edit_job_routine_result, :update_job_routine_result, :remove_job_routine_result, :upload_job_routine_result, :edit_job_routine_result_file, :update_job_routine_result_file, :remove_job_routine_result_file, :update_job_routine_self_point], :pf
      can [:add_job_vice_result, :edit_job_vice_result, :update_job_vice_result, :remove_job_vice_result, :upload_job_vice_result, :edit_job_vice_result_file, :update_job_vice_result_file, :remove_job_vice_result_file, :update_job_vice_self_point], :pf
      can [:add_job_development_result, :edit_job_development_result, :update_job_development_result, :remove_job_development_result, :upload_job_development_result, :edit_job_development_result_file, :update_job_development_result_file, :remove_job_development_result_file, :update_job_development_self_point], :pf
      can [:x, :x_user], :pf do
        Section.where(["leader_id = ?", user.id]).size > 0
      end
      
      can :confirm, :dashboard
      can [:read, :user, :confirm_job_plan, :confirm_job_routine, :confirm_job_vice, :confirm_job_development, :unconfirm_job_plan, :unconfirm_job_routine, :unconfirm_job_vice, :unconfirm_job_development, :confirm_job_plan_result, :confirm_job_routine_result, :confirm_job_vice_result, :confirm_job_development_result, :unconfirm_job_plan_result, :unconfirm_job_routine_result, :unconfirm_job_vice_result, :unconfirm_job_development_result, :confirm_selected], :confirm do
        Section.where(["leader_id = ? OR vice_leader_id = ?", user.id, user.id]).size > 0 || Evaluation.all_enabled.collect {|ev| ev.director_id}.include?(user.id) || Evaluation.all_enabled.collect {|ev| ev.vice_director_id}.include?(user.id) || Evaluation.all_enabled.collect {|ev| ev.vice_director2_id}.include?(user.id) || Evaluation.all_enabled.collect {|ev| ev.vice_director3_id}.include?(user.id) || Evaluation.all_enabled.collect {|ev| ev.secretary_id}.include?(user.id)
      end if Evaluation.current_evaluation
      
      can [:read, :update, :save_change], EvaluationUser do |eu|
        eu.committee_id == user.id
      end
      
      if user.is_director? || user.is_vice_director? || user.is_vice_director2? || user.is_vice_director3? || user.is_secretary?
        can :read, :report
        can :users, :report
        can :user, :report
        can :comment, :report
        can :r4, :report
        can :employee_type, :report
        can :job_result_others, :report
      end
      
      can :read, :report
      can :edpex_kku_report, :report
        
      # Settings
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobTemplateGroup do
        Section.where(["leader_id = ?", user.id]).size > 0
      end
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], JobTemplate do
        Section.where(["leader_id = ?", user.id]).size > 0
      end
      
      Evaluation.order(:id).each do |ev|
        if user.is_director?(ev)
          can :manage, :director_confirm
        end
      end
      
      can [:cru, :submit, :save_change, :enable, :disable, :terminate], EvaluationScoreCard do |evaluation_score_dard|
        evaluation_score_dard.committee_id == user.id
      end
      
    end
    
    can :read, :manual

  end
end
