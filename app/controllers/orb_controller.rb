# encoding: utf-8
class OrbController < ApplicationController
  
  # devise
  before_filter :authenticate_user!
  # authorize_resource :class => false
  skip_authorization_check :only => [:template]
  
  before_filter :load_menu

  private  
  def default_layout
    "orb"
  end

  # cancan
  def current_ability
    # @current_ability ||= UserAbility.new(current_user)
    current_user.ability
  end
  check_authorization :unless => :devise_controller?

  private
  def load_menu
    @nav_shortcuts = []
    @nav_items = []
    
    @nav_items << {:title => t(:dashboard), :icon_class => "entypo-briefcase", :url => dashboards_url, :resource => :dashboard, :force_inactive => ["pds", "pfs", "confirms"].include?(controller_name) || (controller_name == "dashboards" && action_name == "evaluation")}
    
    if ["pds", "pfs", "confirms"].include?(controller_name) || (controller_name == "dashboards" && action_name == "evaluation")
      sub_navs = []
      sub_navs << {:title => "สรุป", :icon_class => "fa fa-cubes", :url => evaluation_dashboards_path, :resource => Project}
      sub_navs << {:title => "ข้อตกลง", :icon_class => "entypo-doc-text", :url => pds_url, :resource => :pd, :force_active => ["job_routines", "job_vices", "job_developments"].include?(controller_name) && params[:pf].blank?} unless @current_evaluation.nil?
      sub_navs << {:title => "แบบรายงานผล", :icon_class => "entypo-doc-text", :url => pfs_url, :resource => :pf, :force_active => ["job_routines", "job_vices", "job_developments"].include?(controller_name) && !params[:pf].blank?} unless @current_evaluation.nil?
      # sub_navs << {:title => t(:confirm), :icon_class => "entypo-briefcase", :url => confirms_url, :resource => :confirm}
  
      @nav_items << {:title => t(:evaluations), :sub_id => "evaluations", :icon_class => "fa fa-cubes", :force_active => true, :items => sub_navs}
    else
      @nav_items << {:title => t(:evaluations), :icon_class => "fa fa-cubes", :url => evaluation_dashboards_path, :resource => Project}
    end

    sub_navs = []
    sub_navs << {:title => Evaluation.model_name.human, :icon_class => "fa fa-cog", :url => settings_evaluations_path, :resource => Evaluation}

    sub_navs << {:title => Section.model_name.human, :icon_class => "fa fa-cog", :url => settings_sections_path, :resource => Section}
    # sub_navs << {:title => Team.model_name.human, :icon_class => "fa fa-cog", :url => settings_teams_path, :resource => Team}
    # sub_navs << {:title => Faculty.model_name.human, :icon_class => "fa fa-cog", :url => settings_faculties_path, :resource => Faculty}
    
    sub_navs << {:title => EmployeeType.model_name.human, :icon_class => "fa fa-cog", :url => settings_employee_types_path, :resource => EmployeeType}
    # sub_navs << {:title => EmployeeTypeUser.model_name.human, :icon_class => "fa fa-cog", :url => settings_employee_type_users_path, :resource => EmployeeTypeUser}
    sub_navs << {:title => Task.model_name.human, :icon_class => "fa fa-cog", :url => settings_tasks_path, :resource => Task}

    sub_navs << {:title => Position.model_name.human, :icon_class => "fa fa-cog", :url => settings_positions_path, :resource => Position}
    sub_navs << {:title => PositionType.model_name.human, :icon_class => "fa fa-cog", :url => settings_position_types_path, :resource => PositionType}
    sub_navs << {:title => PositionLevel.model_name.human, :icon_class => "fa fa-cog", :url => settings_position_levels_path, :resource => PositionLevel}
    sub_navs << {:title => Capacity.model_name.human, :icon_class => "fa fa-cog", :url => settings_capacities_path, :resource => Capacity}

    sub_navs << {:title => t(:personel) + " / " + User.model_name.human, :icon_class => "fa fa-user", :url => admin_users_path, :resource => User}
    # sub_navs << {:title => UserGroup.model_name.human, :icon_class => "fa fa-users", :url => admin_user_groups_path, :resource => UserGroup}

    # sub_navs << {:title => JobTemplateGroup.model_name.human, :icon_class => "fa fa-cog", :url => settings_job_template_groups_path, :resource => JobTemplateGroup}
    # sub_navs << {:title => JobTemplate.model_name.human, :icon_class => "fa fa-cog", :url => settings_job_templates_path, :resource => JobTemplate}

    @nav_items << {:title => t(:evaluations), :sub_id => "settings-evaluations", :icon_class => "fa fa-cogs", :items => sub_navs}

    # @nav_items << {:title => Assessment.model_name.human, :icon_class => "fa fa-envelope", :url => assessments_path, :resource => Assessment}
    # @nav_items << {:title => Assessment2.model_name.human, :icon_class => "fa fa-envelope", :url => assessment2s_path, :resource => Assessment2}
    
    @nav_items << {:title => Project.model_name.human, :icon_class => "fa fa-cubes", :url => projects_path, :resource => Project}
    @nav_items << {:title => Activity.model_name.human, :icon_class => "fa fa-cubes", :url => projects_activities_path, :resource => Activity}
    @nav_items << {:title => Expense.model_name.human, :icon_class => "fa fa-dollar", :url => projects_expenses_path, :resource => Expense}
    
    @nav_items << {:title => t(:reports_edpex_kku), :icon_class => "glyphicon glyphicon-stats", :url => edpex_kku_reports_path, :resource => :report}
    @nav_items << {:title => EdpexKkuGroup.model_name.human, :icon_class => "fa fa-cog", :url => edpex_kku_groups_path, :resource => EdpexKkuGroup}
    @nav_items << {:title => EdpexKku.model_name.human, :icon_class => "fa fa-cog", :url => edpex_kkus_path, :resource => EdpexKku}
    
    sub_navs = []
    sub_navs << {:title => NewsFront.model_name.human, :icon_class => "fa fa-bullhorn", :url => news_fronts_path, :resource => NewsFront}

    sub_navs << {:title => KkuStrategicPillar.model_name.human, :icon_class => "fa fa-cog", :url => settings_kku_strategic_pillars_path, :resource => KkuStrategicPillar}
    sub_navs << {:title => KkuStrategic.model_name.human, :icon_class => "fa fa-cog", :url => settings_kku_strategics_path, :resource => KkuStrategic}
    sub_navs << {:title => Policy.model_name.human, :icon_class => "fa fa-cog", :url => settings_policies_path, :resource => Policy}
    sub_navs << {:title => StrategyGroup.model_name.human, :icon_class => "fa fa-cog", :url => settings_strategy_groups_path, :resource => StrategyGroup}
    sub_navs << {:title => Strategy.model_name.human, :icon_class => "fa fa-cog", :url => settings_strategies_path, :resource => Strategy}
    sub_navs << {:title => Tactic.model_name.human, :icon_class => "fa fa-cog", :url => settings_tactics_path, :resource => Tactic}
    sub_navs << {:title => Measure.model_name.human, :icon_class => "fa fa-cog", :url => settings_measures_path, :resource => Measure}
    sub_navs << {:title => BudgetType.model_name.human, :icon_class => "fa fa-cog", :url => settings_budget_types_path, :resource => BudgetType}
    sub_navs << {:title => BudgetGroup.model_name.human, :icon_class => "fa fa-cog", :url => settings_budget_groups_path, :resource => BudgetGroup}

    @nav_items << {:title => t(:settings), :sub_id => "settings", :icon_class => "fa fa-cogs", :items => sub_navs}
    
    sub_navs = []
    sub_navs << {:title => t(:reports_user), :icon_class => "glyphicon glyphicon-stats", :url => users_reports_url, :resource => :report}
    sub_navs << {:title => t(:reports_employee_type), :icon_class => "glyphicon glyphicon-stats", :url => employee_type_reports_url, :resource => :report} if current_user.can?(:employee_type, :report)
    sub_navs << {:title => t(:reports_expenses_projects), :icon_class => "glyphicon glyphicon-stats", :url => expenses_projects_reports_url, :resource => :reports_project}
    sub_navs << {:title => t(:reports_expenses_by_range_projects), :icon_class => "glyphicon glyphicon-stats", :url => expenses_by_range_projects_reports_url, :resource => :reports_project}
    # sub_navs << {:title => "PF ที่กรอกเอง #{@current_evaluation.to_s}", :icon_class => "glyphicon glyphicon-stats", :url => job_result_others_reports_url(evaluation_id: @current_evaluation), :resource => :report}itle => t(:reports_expenses_projects), :icon_class => "glyphicon glyphicon-stats", :url => expenses_projects_reports_url, :resource => :report}
    sub_navs << {:title => t(:reports_indicator), :icon_class => "glyphicon glyphicon-stats", :url => summary_indicator_planners_reports_url, :resource => :reports_planner}
    @nav_items << {:title => t(:reports), :sub_id => "reports", :icon_class => "glyphicon glyphicon-stats", :items => sub_navs}
    
    @nav_items << {:title => t(:manual), :icon_class => "glyphicon glyphicon-book", :url => manuals_url, :resource => :manual}
    
    sub_navs = []
    sub_navs << {:title => UserAccessLog.model_name.human, :icon_class => "fa fa-cog", :url => user_access_logs_path, :resource => UserAccessLog}
    sub_navs << {:title => t(:workflow_state), :icon_class => "glyphicon glyphicon-transfer", :url => systems_workflow_states_url, :resource => :template, :target => "_blank"}
    sub_navs << {:title => t(:orb_template), :icon_class => "fa fa-magic", :url => orb_template_url, :resource => :template, :target => "_blank"}
    @nav_items << {:title => t(:system), :sub_id => "system", :icon_class => "fa fa-terminal", :items => sub_navs}
    
  end
  
  public
  def template
    redirect_to "/orb/index.html"
    return false
  end
  
end
