#encoding: utf-8
namespace :fix do
   
  task :position_capacity_weights => :environment do
    Position.all_enabled.each do |position|
      position_capacities = []
      position.position_capacity_groups.each do |position_capacity_group|
        position_capacity_group.position_capacities.each do |position_capacity|
          position_capacities << position_capacity
        end
      end
      
      avg_weight = position_capacities.size > 0 ? 100.0 / position_capacities.size : 0
      
      position_capacities.each do |position_capacity|
        position_capacity.weight = avg_weight
        position_capacity.save
      end
      
      puts "#{position.id} :: #{avg_weight}"
    end
  end
  
  task :project_budget_group_id => :environment do
    Expense.all.each do |expense|
      project = expense.project
      project.budget_group_id = expense.budget_group_id
      project.save
    end
  end
   
end