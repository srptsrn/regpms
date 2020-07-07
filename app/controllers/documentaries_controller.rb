#encoding: utf-8
require 'open-uri'

class DocumentariesController < ApplicationController
  
  skip_before_filter :authenticate_user!
  skip_authorization_check
  layout "orb_blank"
  
  def index
    t1 = Time.current
    
    if params[:filters]
      @filters = Struct.new(:pid, :year, :evaluation_id).new(params[:filters][:pid], params[:filters][:year].to_i, params[:filters][:evaluation_id])
    else
      evaluation_id = @current_evaluation ? @current_evaluation.id : Evaluation.first.id
      year = @current_evaluation ? @current_evaluation.year : Date.current.year
      year = params[:year].to_i if params[:year]
      year -= 543 if year > 2500
      pid = params[:pid]
      
      @filters = Struct.new(:pid, :year, :evaluation_id).new(pid, year, evaluation_id)
    end
    
    evaluation = Evaluation.find(@filters.evaluation_id)
    year = evaluation.year > 2500 ? evaluation.year - 543 : evaluation.year
    pid = @filters.pid
    
    @query_start_date = evaluation.query_start_date
    @query_end_date = evaluation.query_end_date
    
    @user = User.where(["pid = ?", pid]).first
    
    if year && pid
      if @user && evaluation
        @job_plans = @user.job_plans.where(["evaluation_id = ?", evaluation.id])
        @job_routines = @user.job_routines.where(["evaluation_id = ?", evaluation.id])
        @job_vices = @user.job_vices.where(["evaluation_id = ?", evaluation.id])
        @job_developments = @user.job_developments.where(["evaluation_id = ?", evaluation.id])
        
        select = ""
        select += "users.username AS pid, "
        select += "users.alias AS user_name, "
        select += "user_groups.`name` AS user_group, "
        select += "strategies.`year` AS `year`, "
        select += "strategies.id AS strategy_id, "
        select += "strategies.`name` AS strategy_name, "
        select += "purposes.id AS purpose_id, "
        select += "purposes.`name` AS purpose_name, "
        select += "tactics.id AS tactic_id, "
        select += "tactics.`name` AS tactic_name, "
        select += "projects.id AS project_id, "
        select += "projects.`name` AS project_name, "
        select += "kpi_projects.id AS kpi_project_id, "
        select += "kpi_templates.id AS kpi_template_id, "
        select += "kpi_templates.`name` AS kpi_template_name, "
        select += "kpi_eval_quantity_processes.id AS kpi_eval_quantity_process_id, "
        select += "kpi_eval_quantity_processes.`data` AS data " 
        
        joins = ""
        joins += "JOIN user_groups ON user_groups.id = users.user_group_id "
        joins += "JOIN user_group_responsibilities ON (user_groups.id = user_group_responsibilities.user_group_id AND user_group_responsibilities.user_id = 0) or (user_groups.id = user_group_responsibilities.user_group_id AND user_group_responsibilities.user_id = users.id) "
        joins += "JOIN activities ON activities.id = user_group_responsibilities.activity_id "
        joins += "JOIN projects ON projects.id = activities.project_id "
        joins += "JOIN tactics ON tactics.id = projects.tactics_id "
        joins += "JOIN purposes ON purposes.id = tactics.purpose_id "
        joins += "JOIN strategies ON strategies.id = purposes.strategy_id "
        joins += "JOIN kpi_projects ON kpi_projects.project_id = projects.id "
        joins += "JOIN kpi_year_templates ON kpi_year_templates.id = kpi_projects.id "
        joins += "JOIN kpi_templates ON kpi_year_templates.kpi_template_id = kpi_templates.id "
        joins += "LEFT OUTER JOIN kpi_eval_quantity_processes ON kpi_eval_quantity_processes.kpi_project_id = kpi_projects.id "
        
        group = ""
        group += "users.username, "
        group += "users.alias, "
        group += "user_groups.`name`, "
        group += "strategies.`year`, "
        group += "strategies.id, "
        group += "strategies.`name`, "
        group += "purposes.id, "
        group += "purposes.`name`, "
        group += "tactics.id, "
        group += "tactics.`name`, "
        group += "projects.id, "
        group += "projects.`name`, "
        group += "kpi_projects.id, "
        group += "kpi_templates.id, "
        group += "kpi_templates.`name`, "
        group += "kpi_eval_quantity_processes.id, "
        group += "kpi_eval_quantity_processes.`data` " 
        
        order = ""
        order += "strategies.`year`, "
        order += "strategies.`order`, "
        order += "purposes.`order`, "
        order += "tactics.`order`, "
        order += "projects.`order` "
        
        where = ["strategies.`year` = ? and users.username = ?", year + 543, pid]
        
        begin
          @job_xs = Evaluation198User.select(select).order(order).group(group).joins(joins).where(where)
        rescue Exception => exc
          @job_xs = []
          @job_xs_errors = exc.message
        end
      else
        @job_plans = []
        @job_routines = []
        @job_vices = []
        @job_developments = []
        
        @job_xs = []
      end
      
      @result_leaves = get_leaves(year, pid, @query_start_date, @query_end_date)
      @result_checkinouts = get_checkinouts(year, pid, @query_start_date, @query_end_date)
      @result_holidays = get_holidays(year, @query_start_date, @query_end_date)
    else
      
      @user = User.new
      
      @result_leaves = {}
      @result_checkinouts = {}
      @result_holidays = {}
      
      @job_plans = []
      @job_routines = []
      @job_vices = []
      @job_developments = []
      
      @job_xs = []
    end
    
    t2 = Time.current
    @response_time = t2 - t1
  end
    
  def leaves
    year = @current_evaluation ? @current_evaluation.year : Date.current.year
    year = params[:year].to_i if params[:year]
    year -= 543 if year > 2500
    @user = params[:user_id] && User.exists?(params[:user_id]) ? User.find(params[:user_id]) : nil
    pid = @user ? @user.pid : params[:pid]
    
    evaluation = params[:evaluation_id] && Evaluation.exists?(params[:evaluation_id]) ? Evaluation.find(params[:evaluation_id]) : @current_evaluation 
    from = evaluation ? evaluation.query_start_date : "01/01/#{year}"
    to = evaluation ? evaluation.query_end_date : "01/12/#{year}"
    
    @result_leaves = get_leaves(year, pid, from, to)
  end
    
  def checkinouts
    year = @current_evaluation ? @current_evaluation.year : Date.current.year
    year = params[:year].to_i if params[:year]
    year -= 543 if year > 2500
    pid = params[:pid]
    @result_checkinouts = get_checkinouts(year, pid)
  end
  
end
