#encoding: utf-8
namespace :demo do
   
  task :init => :environment do
    (55..60).each do |i|
      (1..5).each do |j|
        k = (j % 1) + 1
        (1..2).each do |l|
          code = ("%02d" % i) + ("%02d" % j) + ("%01d" % k) + ("%02d" % l)
          project = Project.where(["code = ?", code]).first
          project = Project.new if project.nil?
          project.code = code
          project.name = code
          project.budget_amount = 1000000
          project.workflow_state = :enabled
          project.save
        end
      end
    end
    
    budget_groups = BudgetGroup.all
    budget_types = BudgetType.all
    
    Project.all_enabled.each do |project|
      
      year = project.code[0, 2].to_i + 2500 - 543
      
      puts xxx = project.code[3, 1].to_i
      
      date1 = Date.strptime("05/10/#{year - 1}", "%d/%m/%Y")
      date2 = Date.strptime("05/11/#{year - 1}", "%d/%m/%Y")
      date3 = Date.strptime("05/12/#{year - 1}", "%d/%m/%Y")
      date4 = Date.strptime("05/01/#{year}", "%d/%m/%Y")
      date5 = Date.strptime("05/02/#{year}", "%d/%m/%Y")
      date6 = Date.strptime("05/03/#{year}", "%d/%m/%Y")
      date7 = Date.strptime("05/04/#{year}", "%d/%m/%Y")
      date8 = Date.strptime("05/05/#{year}", "%d/%m/%Y")
      date9 = Date.strptime("05/06/#{year}", "%d/%m/%Y")
      date0 = Date.strptime("05/01/#{xxx == 5 ? 2017 : year }", "%d/%m/%Y")
      
      dates = [date1, date2, date3, date4, date5, date6, date7, date8, date9, date0]
      dates.each_index do |i|
        date = dates[i]
        expense = project.expenses.where(["date = ?", date]).first
        expense = project.expenses.new if expense.nil?
        expense.date = date
        expense.budget_type_id = budget_types.to_a[year % 3].id
        expense.budget_group_id = budget_groups.to_a[year % 2].id
        expense.description = "#{i}"
        expense.amount = 100000
        expense.by = "-"
        expense.workflow_state = :enabled
        unless expense.save
          puts expense.errors.inspect
        end
      end
    end
  end
   
end