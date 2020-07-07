# encoding: utf-8
class Reports::ProjectsController < OrbController
  
  skip_authorization_check
  # authorize_resource :class => false
  
  def expenses
    
    if params[:filters]
      @filters = Struct.new(:year).new(params[:filters][:year] ? params[:filters][:year].to_i : Date.current.year)
    else
      @filters = Struct.new(:year).new(Date.current.year)
    end
    
    @year = @filters.year.to_i
    @year_thai = @year + 543
    @date = Date.strptime("30/09/#{@year}", "%d/%m/%Y")
    @date0 = Date.strptime("01/10/#{@year - 1}", "%d/%m/%Y")
    
    @budget_groups = BudgetGroup.all_enabled + [BudgetGroup.new(name: "ยังไม่ระบุประเภทเงิน")]
    
    @projects = Project.all_enabled.where(["projects.code LIKE ? AND project_id IS NULL", "#{@year_thai - 2500}%"]).sort_by {|p| p.code} #.collect {|p| p}
    
  end
  
  def expenses_by_range
    
    if params[:filters]
      @filters = Struct.new(:year).new(params[:filters][:year] ? params[:filters][:year].to_i : Date.current.year)
    else
      @filters = Struct.new(:year).new(Date.current.year)
    end
    
    @year = @filters.year.to_i
    @year_thai = @year + 543
    @date = Date.strptime("30/09/#{@year}", "%d/%m/%Y")
    @date0 = Date.strptime("01/10/#{@year - 1}", "%d/%m/%Y")
    @months = []
    (@date0..@date).each do |date|
      @months << [date.year, date.mon] if date.day == 1
    end
    @quaters = [
      [1, @year - 1, [10, 11, 12]], 
      [2, @year, [1, 2, 3]], 
      [3, @year, [4, 5, 6]], 
      [4, @year, [7, 8, 9]], 
    ]

    select = "EXTRACT(YEAR FROM expenses.date) AS year, EXTRACT(MONTH FROM expenses.date) AS mon, expenses.project_id, expenses.budget_group_id, SUM(expenses.amount) AS amount, projects.code AS project_code, projects.name AS projename, budget_groups.name AS budget_group_name"
    
    joins = ""
    joins += "JOIN projects ON projects.id = expenses.project_id "
    joins += "JOIN budget_groups ON budget_groups.id = expenses.budget_group_id "
    
    con_st = "expenses.workflow_state = ? AND expenses.date >= ? AND expenses.date <= ? "
    con_pr = [:enabled, @date0, @date]
    where = [con_st, *con_pr]
    
    group = "EXTRACT(YEAR FROM expenses.date), EXTRACT(MONTH FROM expenses.date), expenses.project_id, expenses.budget_group_id, projects.code, projects.name, budget_groups.name"
    
    order = "EXTRACT(YEAR FROM expenses.date), EXTRACT(MONTH FROM expenses.date), budget_groups.name, projects.code, projects.name"
    
    @expenses = Expense.order(order).group(group).joins(joins).where(where).select(select)
    
    @budget_groups = BudgetGroup.all_enabled
    
    @projects = Project.all_enabled.where(["projects.code LIKE ?", "#{@year_thai - 2500}%"]).sort_by {|p| p.code} #.collect {|p| p}
    @project_lates = (Project.find(@expenses.collect {|ex| ex.project_id}.uniq) - @projects).sort_by {|p| p.code}
    
  end
  
end
